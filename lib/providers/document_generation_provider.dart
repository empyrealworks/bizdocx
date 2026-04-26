import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/document_asset.dart';
import '../models/user_context.dart';
import '../models/document_template.dart';
import '../services/firebase_service.dart';
import '../services/gemini_rag_service.dart';
import '../services/local_cache_service.dart';

// ── Documents per Portfolio ───────────────────────────────────────────────────
final documentListProvider =
StreamProvider.family.autoDispose<List<DocumentAsset>, String>(
      (ref, portfolioId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseService.instance.watchDocuments(portfolioId);
  },
);

// ── Generation State ──────────────────────────────────────────────────────────
enum GenerationPhase {
  idle,
  fetchingContext,
  generating,
  converting,
  saving,
  savingVersion,
  deleting,
  cancelled,
}

class GenerationState {
  const GenerationState({
    this.phase = GenerationPhase.idle,
    this.result,
    this.error,
  });

  final GenerationPhase phase;
  final DocumentAsset? result;
  final Object? error;

  bool get isLoading =>
      phase != GenerationPhase.idle &&
          phase != GenerationPhase.cancelled &&
          error == null &&
          result == null;
  bool get hasError => error != null;
  bool get hasResult => result != null;
  bool get isCancelled => phase == GenerationPhase.cancelled;

  GenerationState copyWith({
    GenerationPhase? phase,
    DocumentAsset? result,
    Object? error,
  }) =>
      GenerationState(
        phase: phase ?? this.phase,
        result: result ?? this.result,
        error: error ?? this.error,
      );
}

class DocumentGenerationNotifier extends Notifier<GenerationState> {
  DocumentGenerationNotifier(this._portfolioId);
  final String _portfolioId;
  bool _isCancelled = false;

  @override
  GenerationState build() => const GenerationState();

  void cancel() {
    _isCancelled = true;
    state = const GenerationState(phase: GenerationPhase.cancelled);
  }

  void _checkCancelled() {
    if (_isCancelled) throw Exception('Operation cancelled by user');
  }

  // ── Initial Generation ────────────────────────────────────────────────────
  Future<DocumentAsset?> generate({
    required String prompt,
    required DocumentType type,
    required AssetPipeline pipeline,
    required String title,
    DocumentTemplate? template,
    String? aspectRatio,
    String? orientation,
  }) async {
    final fb = FirebaseService.instance;
    final uid = fb.currentUid;
    final gemini = GeminiRagService.instance;
    const uuid = Uuid();
    _isCancelled = false;

    try {
      state = const GenerationState(phase: GenerationPhase.fetchingContext);
      final context = await fb.fetchContext(_portfolioId);
      _checkCancelled();

      state = const GenerationState(phase: GenerationPhase.generating);

      if (pipeline == AssetPipeline.structural) {
        return await _generateStructural(
          uid: uid,
          portfolioId: _portfolioId,
          prompt: prompt,
          type: type,
          title: title,
          context: context,
          uuid: uuid,
          fb: fb,
          gemini: gemini,
          template: template,
          orientation: orientation,
        );
      } else {
        return await _generateGraphical(
          uid: uid,
          portfolioId: _portfolioId,
          prompt: prompt,
          type: type,
          title: title,
          context: context,
          uuid: uuid,
          fb: fb,
          gemini: gemini,
          template: template,
          aspectRatio: aspectRatio,
        );
      }
    } catch (e) {
      if (_isCancelled) return null;
      state = GenerationState(error: e);
      return null;
    }
  }

  Future<DocumentAsset> _generateStructural({
    required String uid,
    required String portfolioId,
    required String prompt,
    required DocumentType type,
    required String title,
    required UserContext context,
    required Uuid uuid,
    required FirebaseService fb,
    required GeminiRagService gemini,
    DocumentTemplate? template,
    String? orientation,
  }) async {
    final html = await gemini.generateStructuralDocument(
      userPrompt: prompt,
      documentType: type,
      context: context,
      template: template,
      orientation: orientation,
    );
    _checkCancelled();

    final docId = uuid.v4();
    state = const GenerationState(phase: GenerationPhase.saving);

    final asset = DocumentAsset(
      id: docId,
      portfolioId: portfolioId,
      userId: uid,
      title: title,
      type: type,
      pipeline: AssetPipeline.structural,
      htmlContent: html,
      prompt: prompt,
      isCached: false,
      createdAt: DateTime.now(),
      templateId: template?.id,
      orientation: orientation,
    );

    final saved = await fb.saveDocumentAsset(asset);
    _checkCancelled();

    // Save initial version (v1 = original generation)
    state = const GenerationState(phase: GenerationPhase.savingVersion);
    await fb.saveDocumentVersion(
      asset: saved,
      versionNumber: 1,
      refinementPrompt: null, // original generation has no refinement prompt
      label: 'Original',
    );
    _checkCancelled();

    await fb.appendRecentDocument(portfolioId, title);
    _checkCancelled();

    state = GenerationState(phase: GenerationPhase.idle, result: saved);
    return saved;
  }

  Future<DocumentAsset> _generateGraphical({
    required String uid,
    required String portfolioId,
    required String prompt,
    required DocumentType type,
    required String title,
    required UserContext context,
    required Uuid uuid,
    required FirebaseService fb,
    required GeminiRagService gemini,
    DocumentTemplate? template,
    String? aspectRatio,
  }) async {
    final bytes = await gemini.generateImage(
      userPrompt: prompt,
      context: context,
      template: template,
      aspectRatio: aspectRatio,
    );
    _checkCancelled();

    final docId = uuid.v4();
    final cache = LocalCacheService.instance;

    state = const GenerationState(phase: GenerationPhase.converting);
    final localFile =
    await cache.cacheImageBytes(bytes, uid, portfolioId, docId);
    _checkCancelled();

    state = const GenerationState(phase: GenerationPhase.saving);
    final storagePath =
        'users/$uid/portfolios/$portfolioId/images/$docId.png';
    final downloadUrl = await fb.uploadAsset(
      file: localFile,
      storagePath: storagePath,
      contentType: 'image/png',
    );
    _checkCancelled();

    final asset = DocumentAsset(
      id: docId,
      portfolioId: portfolioId,
      userId: uid,
      title: title,
      type: type,
      pipeline: AssetPipeline.graphical,
      storageUrl: downloadUrl,
      localCachePath: localFile.path,
      prompt: prompt,
      isCached: true,
      createdAt: DateTime.now(),
      templateId: template?.id,
      aspectRatio: aspectRatio,
    );

    final saved = await fb.saveDocumentAsset(asset);
    _checkCancelled();

    state = GenerationState(phase: GenerationPhase.idle, result: saved);
    return saved;
  }

  // ── Iterative Refinement ─────────────────────────────────────────────────
  Future<DocumentAsset?> refineDocument({
    required DocumentAsset existingAsset,
    required String refinementPrompt,
  }) async {
    if (!existingAsset.isStructural || existingAsset.htmlContent == null) {
      state = GenerationState(
          error: Exception(
              'Refinement is only supported for structural documents.'));
      return null;
    }

    final fb = FirebaseService.instance;
    final gemini = GeminiRagService.instance;
    _isCancelled = false;

    try {
      // 1. Fetch context
      state = const GenerationState(phase: GenerationPhase.fetchingContext);
      final context = await fb.fetchContext(existingAsset.portfolioId);
      _checkCancelled();

      // 2. Generate refined HTML
      state = const GenerationState(phase: GenerationPhase.generating);
      final newHtml = await gemini.refineStructuralDocument(
        existingHtml: existingAsset.htmlContent!,
        refinementPrompt: refinementPrompt,
        documentType: existingAsset.type,
        context: context,
      );
      _checkCancelled();

      // 3. Save a version of the NEW result BEFORE updating the live doc.
      //    This means versions are "what it looked like after this change".
      state = const GenerationState(phase: GenerationPhase.savingVersion);
      final nextVersion =
      await fb.getNextVersionNumber(
          existingAsset.portfolioId, existingAsset.id);
      final updated = existingAsset.copyWith(
        htmlContent: newHtml,
        updatedAt: DateTime.now(),
        isCached: false,
      );

      // 4. Persist to Firestore
      state = const GenerationState(phase: GenerationPhase.saving);
      final saved = await fb.updateDocumentAsset(updated);
      _checkCancelled();

      // 5. Save the version snapshot
      await fb.saveDocumentVersion(
        asset: saved,
        versionNumber: nextVersion,
        refinementPrompt: refinementPrompt,
      );
      _checkCancelled();

      state = GenerationState(phase: GenerationPhase.idle, result: saved);
      return saved;
    } catch (e) {
      if (_isCancelled) return null;
      state = GenerationState(error: e);
      return null;
    }
  }

  // ── Deletion ─────────────────────────────────────────────────────────────
  Future<void> deleteDocument(DocumentAsset asset) async {
    try {
      state = const GenerationState(phase: GenerationPhase.deleting);
      await FirebaseService.instance.deleteDocumentAsset(asset);
      state = const GenerationState(phase: GenerationPhase.idle);
    } catch (e) {
      state = GenerationState(error: e);
    }
  }

  void reset() => state = const GenerationState();
}

final documentGenerationProvider = NotifierProvider.family<
    DocumentGenerationNotifier, GenerationState, String>(
  DocumentGenerationNotifier.new,
);
