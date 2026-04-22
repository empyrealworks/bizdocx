import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/firestore_paths.dart';
import '../models/business_portfolio.dart';
import '../models/document_asset.dart';
import '../models/document_version.dart';
import '../models/user_context.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = const Uuid();

  String get currentUid => _auth.currentUser!.uid;

  // ── Offline Persistence ──────────────────────────────────────────────────
  static Future<void> initOfflinePersistence() async {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint('[Firestore] Offline persistence enabled.');
  }

  // ── Auth ─────────────────────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();
  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await cred.user?.updateDisplayName(name);
    return cred;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: '776742749745-08dos1v3uk0th6e36komovsgk2hq3uqc.apps.googleusercontent.com'
      );
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential =
      GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final cred = await _auth.signInWithCredential(credential);
      return cred;
    } catch (e) {
      debugPrint('[FirebaseService] Google Sign-In error: $e');
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();

  // ── Portfolio CRUD ────────────────────────────────────────────────────────
  Stream<List<BusinessPortfolio>> watchPortfolios() {
    return _db
        .collection(FirestorePaths.portfoliosCol(currentUid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(BusinessPortfolio.fromFirestore).toList());
  }

  Future<BusinessPortfolio> createPortfolio({
    required String name,
    String description = '',
    String mission = '',
    List<String> brandColors = const [],
    String targetAudience = '',
  }) async {
    final uid = currentUid;
    final id = _uuid.v4();
    final now = DateTime.now();
    final portfolio = BusinessPortfolio(
      id: id,
      userId: uid,
      name: name,
      description: description,
      mission: mission,
      brandColors: brandColors,
      targetAudience: targetAudience,
      createdAt: now,
    );
    await _db
        .doc(FirestorePaths.portfolio(uid, id))
        .set(portfolio.toFirestore());

    final ctx = UserContext(
      userId: uid,
      portfolioId: id,
      companyName: name,
      mission: mission,
      brandColors: brandColors,
      targetAudience: targetAudience,
      lastUpdated: now,
    );
    await _db
        .doc(FirestorePaths.userContextDoc(uid, id))
        .set(ctx.toFirestore());

    return portfolio;
  }

  /// Updates portfolio and UserContext atomically (RAG context stays in sync).
  Future<void> updatePortfolio(BusinessPortfolio portfolio) async {
    final uid = currentUid;
    final batch = _db.batch();
    batch.update(
      _db.doc(FirestorePaths.portfolio(uid, portfolio.id)),
      {...portfolio.toFirestore(), 'updatedAt': Timestamp.now()},
    );
    batch.update(
      _db.doc(FirestorePaths.userContextDoc(uid, portfolio.id)),
      {
        'companyName': portfolio.name,
        'mission': portfolio.mission,
        'brandColors': portfolio.brandColors,
        'targetAudience': portfolio.targetAudience,
        'lastUpdated': Timestamp.now(),
      },
    );
    await batch.commit();
  }

  Future<void> deletePortfolio(String portfolioId) async {
    final uid = currentUid;
    final batch = _db.batch();
    final docs = await _db
        .collection(FirestorePaths.documentsCol(uid, portfolioId))
        .get();
    for (final doc in docs.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_db.doc(FirestorePaths.portfolio(uid, portfolioId)));
    await batch.commit();
  }

  // ── Document CRUD ─────────────────────────────────────────────────────────
  Stream<List<DocumentAsset>> watchDocuments(String portfolioId) {
    return _db
        .collection(FirestorePaths.documentsCol(currentUid, portfolioId))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(DocumentAsset.fromFirestore).toList());
  }

  Future<DocumentAsset> saveDocumentAsset(DocumentAsset asset) async {
    final uid = currentUid;
    final id = asset.id.isEmpty ? _uuid.v4() : asset.id;
    final doc = asset.copyWith(id: id);
    await _db
        .doc(FirestorePaths.document(uid, asset.portfolioId, id))
        .set(doc.toFirestore());
    await _db.doc(FirestorePaths.portfolio(uid, asset.portfolioId)).update({
      'documentIds': FieldValue.arrayUnion([id]),
      'updatedAt': Timestamp.now(),
    });
    return doc;
  }

  /// In-place update after refinement. Returns the updated asset.
  Future<DocumentAsset> updateDocumentAsset(DocumentAsset asset) async {
    final uid = currentUid;
    final updated = asset.copyWith(updatedAt: DateTime.now());
    await _db
        .doc(FirestorePaths.document(uid, asset.portfolioId, asset.id))
        .update({...updated.toFirestore(), 'updatedAt': Timestamp.now()});
    return updated;
  }

  Future<void> deleteDocumentAsset(DocumentAsset asset) async {
    final uid = currentUid;
    await _db
        .doc(FirestorePaths.document(uid, asset.portfolioId, asset.id))
        .delete();
    if (asset.isGraphical && asset.storageUrl != null) {
      try { await _storage.refFromURL(asset.storageUrl!).delete(); } catch (_) {}
    }
    await _db.doc(FirestorePaths.portfolio(uid, asset.portfolioId)).update({
      'documentIds': FieldValue.arrayRemove([asset.id]),
      'updatedAt': Timestamp.now(),
    });
  }

  // ── Version History ───────────────────────────────────────────────────────

  /// Streams all versions, newest first.
  Stream<List<DocumentVersion>> watchVersions({
    required String portfolioId,
    required String documentId,
  }) {
    return _db
        .collection(
        FirestorePaths.versionsCol(currentUid, portfolioId, documentId))
        .orderBy('versionNumber', descending: true)
        .snapshots()
        .map((s) => s.docs
        .map((d) => DocumentVersion.fromFirestore(
        d as DocumentSnapshot<Map<String, dynamic>>))
        .toList());
  }

  /// Returns how many versions exist + 1 (for the next version number).
  Future<int> getNextVersionNumber(
      String portfolioId, String documentId) async {
    final snap = await _db
        .collection(FirestorePaths.versionsCol(
        currentUid, portfolioId, documentId))
        .count()
        .get();
    return (snap.count ?? 0) + 1;
  }

  /// Snapshots the current HTML as an immutable version record.
  Future<DocumentVersion> saveDocumentVersion({
    required DocumentAsset asset,
    required int versionNumber,
    String? refinementPrompt,
    String? label,
  }) async {
    final uid = currentUid;
    final vid = _uuid.v4();
    final version = DocumentVersion(
      id: vid,
      documentId: asset.id,
      portfolioId: asset.portfolioId,
      userId: uid,
      htmlContent: asset.htmlContent!,
      versionNumber: versionNumber,
      refinementPrompt: refinementPrompt,
      label: label,
      createdAt: DateTime.now(),
    );
    await _db
        .doc(FirestorePaths.version(
        uid, asset.portfolioId, asset.id, vid))
        .set(version.toFirestore());
    debugPrint('[Versions] Saved v$versionNumber for ${asset.id}');
    return version;
  }

  /// Restores the document to a previous version's HTML.
  /// Intentionally does NOT save a new version entry — history stays factual.
  Future<DocumentAsset> restoreDocumentVersion({
    required DocumentAsset currentAsset,
    required DocumentVersion version,
  }) async {
    final restored = currentAsset.copyWith(
      htmlContent: version.htmlContent,
      updatedAt: DateTime.now(),
      isCached: false,
    );
    return updateDocumentAsset(restored);
  }

  // ── UserContext ───────────────────────────────────────────────────────────
  Future<UserContext> fetchContext(String portfolioId) async {
    final uid = currentUid;
    final snap = await _db
        .doc(FirestorePaths.userContextDoc(uid, portfolioId))
        .get(const GetOptions(source: Source.serverAndCache));
    if (!snap.exists || snap.data() == null) {
      return UserContext.empty(uid, portfolioId);
    }
    return UserContext.fromFirestore(snap);
  }

  Future<void> updateContext(UserContext ctx) async {
    await _db
        .doc(FirestorePaths.userContextDoc(currentUid, ctx.portfolioId))
        .set(ctx.copyWith(lastUpdated: DateTime.now()).toFirestore(),
        SetOptions(merge: true));
  }

  Future<void> appendRecentDocument(
      String portfolioId, String docTitle) async {
    await _db
        .doc(FirestorePaths.userContextDoc(currentUid, portfolioId))
        .update({
      'recentDocumentTitles': FieldValue.arrayUnion([docTitle]),
      'lastUpdated': Timestamp.now(),
    });
  }

  // ── Logo Upload ───────────────────────────────────────────────────────────

  /// Uploads a logo and atomically updates the portfolio + UserContext.
  /// The download URL (Firebase CDN, auth-free) is stored in UserContext
  /// so Gemini can embed it directly in generated HTML.
  Future<String> uploadLogo({
    required File file,
    required String portfolioId,
    String contentType = 'image/png',
  }) async {
    final uid = currentUid;
    final storagePath =
    FirestorePaths.logoPath(uid, portfolioId, 'logo.png');
    final downloadUrl = await uploadAsset(
      file: file,
      storagePath: storagePath,
      contentType: contentType,
    );

    final batch = _db.batch();
    batch.update(_db.doc(FirestorePaths.portfolio(uid, portfolioId)),
        {'logoStoragePath': storagePath, 'updatedAt': Timestamp.now()});
    batch.update(
        _db.doc(FirestorePaths.userContextDoc(uid, portfolioId)),
        {'logoStorageUrl': downloadUrl, 'lastUpdated': Timestamp.now()});
    await batch.commit();

    debugPrint('[Storage] Logo uploaded: $downloadUrl');
    return downloadUrl;
  }

  /// Removes logo from Storage and clears references.
  Future<void> deleteLogo(String portfolioId) async {
    final uid = currentUid;
    try {
      await _storage
          .ref(FirestorePaths.logoPath(uid, portfolioId, 'logo.png'))
          .delete();
    } catch (_) {}

    final batch = _db.batch();
    batch.update(_db.doc(FirestorePaths.portfolio(uid, portfolioId)), {
      'logoStoragePath': FieldValue.delete(),
      'updatedAt': Timestamp.now(),
    });
    batch.update(_db.doc(FirestorePaths.userContextDoc(uid, portfolioId)), {
      'logoStorageUrl': FieldValue.delete(),
      'lastUpdated': Timestamp.now(),
    });
    await batch.commit();
  }

  /// Uploads a supporting context asset (PDF, image, text).
  Future<String> uploadContextAsset({
    required File file,
    required String portfolioId,
    required String filename,
    String? contentType,
  }) async {
    final uid = currentUid;
    final storagePath =
    FirestorePaths.uploadedAssetPath(uid, portfolioId, filename);
    final downloadUrl = await uploadAsset(
        file: file, storagePath: storagePath, contentType: contentType);

    await _db
        .doc(FirestorePaths.userContextDoc(uid, portfolioId))
        .update({
      'uploadedAssetStoragePaths': FieldValue.arrayUnion([downloadUrl]),
      'lastUpdated': Timestamp.now(),
    });

    return downloadUrl;
  }

  Future<void> removeContextAsset({
    required String portfolioId,
    required String assetUrl,
  }) async {
    final uid = currentUid;
    try { await _storage.refFromURL(assetUrl).delete(); } catch (_) {}
    await _db
        .doc(FirestorePaths.userContextDoc(uid, portfolioId))
        .update({
      'uploadedAssetStoragePaths': FieldValue.arrayRemove([assetUrl]),
      'lastUpdated': Timestamp.now(),
    });
  }

  // ── Storage ───────────────────────────────────────────────────────────────
  Future<String> uploadAsset({
    required File file,
    required String storagePath,
    String? contentType,
  }) async {
    final ref = _storage.ref(storagePath);
    final meta = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;
    final task = await ref.putFile(file, meta);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteStorageAsset(String storagePath) async {
    try { await _storage.ref(storagePath).delete(); } catch (_) {}
  }
}