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
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    return cred;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // google_sign_in 7.2.0+ uses a singleton and authenticate() method.
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Authentication (ID Token) is now a synchronous getter.
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken is moved to googleUser.authorizationClient.authorizeScopes(...)
        // but idToken is sufficient for Firebase Auth sign-in.
      );

      return await _auth.signInWithCredential(credential);
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
        .map((snap) => snap.docs.map(BusinessPortfolio.fromFirestore).toList());
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

    // Initialise the empty context profile
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

  Future<void> updatePortfolio(BusinessPortfolio portfolio) async {
    await _db
        .doc(FirestorePaths.portfolio(currentUid, portfolio.id))
        .update({...portfolio.toFirestore(), 'updatedAt': Timestamp.now()});
  }

  Future<void> deletePortfolio(String portfolioId) async {
    final uid = currentUid;
    // Batch-delete all sub-documents
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
        .map((snap) => snap.docs.map(DocumentAsset.fromFirestore).toList());
  }

  Future<DocumentAsset> saveDocumentAsset(DocumentAsset asset) async {
    final uid = currentUid;
    final id = asset.id.isEmpty ? _uuid.v4() : asset.id;
    final doc = asset.copyWith(id: id);

    await _db
        .doc(FirestorePaths.document(uid, asset.portfolioId, id))
        .set(doc.toFirestore());

    // Update document list on the portfolio record
    await _db
        .doc(FirestorePaths.portfolio(uid, asset.portfolioId))
        .update({
      'documentIds': FieldValue.arrayUnion([id]),
      'updatedAt': Timestamp.now(),
    });

    return doc;
  }

  Future<void> deleteDocumentAsset(DocumentAsset asset) async {
    final uid = currentUid;
    await _db
        .doc(FirestorePaths.document(uid, asset.portfolioId, asset.id))
        .delete();

    // Remove from Storage if graphical
    if (asset.isGraphical && asset.storageUrl != null) {
      try {
        await _storage.refFromURL(asset.storageUrl!).delete();
      } catch (_) {}
    }

    await _db
        .doc(FirestorePaths.portfolio(uid, asset.portfolioId))
        .update({
      'documentIds': FieldValue.arrayRemove([asset.id]),
      'updatedAt': Timestamp.now(),
    });
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
    final uid = currentUid;
    await _db
        .doc(FirestorePaths.userContextDoc(uid, portfolioId))
        .update({
      'recentDocumentTitles': FieldValue.arrayUnion([docTitle]),
      'lastUpdated': Timestamp.now(),
    });
  }

  // ── Storage ───────────────────────────────────────────────────────────────
  /// Uploads a local file to Firebase Storage and returns its download URL.
  Future<String> uploadAsset({
    required File file,
    required String storagePath,
    String? contentType,
  }) async {
    final ref = _storage.ref(storagePath);
    final metadata =
    contentType != null ? SettableMetadata(contentType: contentType) : null;
    final task = await ref.putFile(file, metadata);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteStorageAsset(String storagePath) async {
    try {
      await _storage.ref(storagePath).delete();
    } catch (_) {}
  }
}
