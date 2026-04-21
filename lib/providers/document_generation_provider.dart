import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/document_asset.dart';
import '../models/user_context.dart';
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
enum GenerationPhase { idle, fetchingContext, generating, converting, saving, cancelled }

class GenerationState {
  const GenerationState({
    this.phase = GenerationPhase.idle,
    this.result,
    this.error,
  });

  final GenerationPhase phase;
  final DocumentAsset? result;
  final Object? error;

  bool get isLoading => phase != GenerationPhase.idle && phase != GenerationPhase.cancelled && error == null && result == null;
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

  @override
  String toString() => 'GenerationState(phase: $phase)';
}

class DocumentGenerationNotifier
    extends Notifier<GenerationState> {
  
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

  // ── Main generation entry-point ───────────────────────────────────────────
  Future<DocumentAsset?> generate({
    required String prompt,
    required DocumentType type,
    required AssetPipeline pipeline,
    required String title,
  }) async {
    final fb = FirebaseService.instance;
    final uid = fb.currentUid;
    final gemini = GeminiRagService.instance;
    const uuid = Uuid();
    _isCancelled = false;

    try {
      // 1. Fetch RAG context
      state = const GenerationState(phase: GenerationPhase.fetchingContext);
      final context = await fb.fetchContext(_portfolioId);
      _checkCancelled();

      // 2. Generate content
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
  }) async {
    // 1. Generate HTML (The high-fidelity design phase)
    final html = await gemini.generateStructuralDocument(
      userPrompt: prompt,
      documentType: type,
      context: context,
    );
    _checkCancelled();

    final docId = uuid.v4();

    // 2. Save to Firestore (Skipping immediate PDF conversion to prevent hangs)
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
      isCached: false, // PDF will be generated on-demand in the viewer
      createdAt: DateTime.now(),
    );

    final saved = await fb.saveDocumentAsset(asset);
    _checkCancelled();
    
    await fb.appendRecentDocument(portfolioId, title);
    _checkCancelled();

    state = GenerationState(
      phase: GenerationPhase.idle,
      result: saved,
    );
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
  }) async {
    // 2. Generate Image Bytes
    final bytes = await gemini.generateImage(
      userPrompt: prompt,
      context: context,
    );
    _checkCancelled();

    final docId = uuid.v4();
    final cache = LocalCacheService.instance;

    // 3. Cache locally first
    state = const GenerationState(phase: GenerationPhase.converting);
    final localFile = await cache.cacheImageBytes(bytes, uid, portfolioId, docId);
    _checkCancelled();

    // 4. Upload to Storage
    state = const GenerationState(phase: GenerationPhase.saving);
    final storagePath = 'users/$uid/portfolios/$portfolioId/images/$docId.png';
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
    );

    final saved = await fb.saveDocumentAsset(asset);
    _checkCancelled();
    
    state = GenerationState(phase: GenerationPhase.idle, result: saved);
    return saved;
  }

  void reset() => state = const GenerationState();
}

// In Riverpod 3.0, the family factory takes (ref, arg)
final documentGenerationProvider = NotifierProvider.family<
    DocumentGenerationNotifier, GenerationState, String>(
  (ref, arg) => DocumentGenerationNotifier(arg),
);
