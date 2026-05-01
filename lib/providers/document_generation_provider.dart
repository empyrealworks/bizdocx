import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/document_asset.dart';
import '../models/user_context.dart';
import '../models/document_template.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../services/gemini_rag_service.dart';
import '../services/local_cache_service.dart';
import 'profile_provider.dart';

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
  checkingLimits,
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
    final gemini = GeminiRagService.instance;
    const uuid = Uuid();
    _isCancelled = false;

    try {
      state = const GenerationState(phase: GenerationPhase.fetchingContext);
      final context = await fb.fetchContext(_portfolioId);
      _checkCancelled();

      // NEW: Credit & Usage Tracking
      state = const GenerationState(phase: GenerationPhase.checkingLimits);
      
      // Fixed: Pass type to correctly calculate cost (15 or 100)
      await fb.trackUsage(pipeline: pipeline, type: type); 
      _checkCancelled();

      state = const GenerationState(phase: GenerationPhase.generating);
      
      // Fetch fresh profile for tier-based model selection
      final profile = await fb.fetchProfile();

      if (pipeline == AssetPipeline.structural) {
        return await _generateStructural(
          uid: profile.uid,
          portfolioId: _portfolioId,
          prompt: prompt,
          type: type,
          title: title,
          context: context,
          uuid: uuid,
          fb: fb,
          gemini: gemini,
          tier: profile.tier,
          template: template,
          orientation: orientation,
        );
      } else {
        return await _generateGraphical(
          uid: profile.uid,
          portfolioId: _portfolioId,
          prompt: prompt,
          type: type,
          title: title,
          context: context,
          uuid: uuid,
          fb: fb,
          gemini: gemini,
          tier: profile.tier,
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
    required UserTier tier,
    DocumentTemplate? template,
    String? orientation,
  }) async {
    final html = await gemini.generateStructuralDocument(
      userPrompt: prompt,
      documentType: type,
      context: context,
      template: template,
      orientation: orientation,
      tier: tier,
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
      revisionCount: 0,
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
    required UserTier tier,
    DocumentTemplate? template,
    String? aspectRatio,
  }) async {
    final bytes = await gemini.generateImage(
      userPrompt: prompt,
      context: context,
      template: template,
      aspectRatio: aspectRatio,
      tier: tier,
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

      // NEW: Credit tracking for refinement (free iterations or 5 credits)
      state = const GenerationState(phase: GenerationPhase.checkingLimits);
      await fb.trackUsage(
        pipeline: AssetPipeline.structural,
        existingAsset: existingAsset,
      );
      _checkCancelled();

      // 2. Fetch tier for model selection
      final profile = await fb.fetchProfile();

      // 3. Generate refined HTML
      state = const GenerationState(phase: GenerationPhase.generating);
      final newHtml = await gemini.refineStructuralDocument(
        existingHtml: existingAsset.htmlContent!,
        refinementPrompt: refinementPrompt,
        documentType: existingAsset.type,
        context: context,
        tier: profile.tier,
      );
      _checkCancelled();

      // 4. Persist to Firestore
      state = const GenerationState(phase: GenerationPhase.saving);
      final nextVersion =
      await fb.getNextVersionNumber(
          existingAsset.portfolioId, existingAsset.id);
      
      // Update local object to reflect the revision increment for the UI
      final updated = existingAsset.copyWith(
        htmlContent: newHtml,
        updatedAt: DateTime.now(),
        isCached: false,
        revisionCount: existingAsset.revisionCount + 1,
      );

      final saved = await fb.updateDocumentAsset(updated);
      _checkCancelled();

      // 5. Save the version snapshot
      state = const GenerationState(phase: GenerationPhase.savingVersion);
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
