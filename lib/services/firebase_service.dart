import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/firestore_paths.dart';
import '../env/env.dart';
import '../models/business_portfolio.dart';
import '../models/document_asset.dart';
import '../models/document_version.dart';
import '../models/user_context.dart';
import '../models/user_profile.dart';

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

  // ── Auth & Profile ───────────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<UserCredential> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    await ensureProfile(cred.user!);
    return cred;
  }
  
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await ensureProfile(cred.user!);
    return cred;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await cred.user?.updateDisplayName(name);
    await ensureProfile(cred.user!, name: name);
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
      await ensureProfile(cred.user!);
      return cred;
    } catch (e) {
      debugPrint('[FirebaseService] Google Sign-In error: $e');
      rethrow;
    }
  }

  Future<void> ensureProfile(User user, {String? name}) async {
    final doc = _db.doc(FirestorePaths.user(user.uid));
    final snap = await doc.get();
    if (!snap.exists) {
      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: name ?? user.displayName,
        createdAt: DateTime.now(),
        subscriptionCredits: 50, // Initial free allowance
      );
      await doc.set(profile.toFirestore());
      debugPrint('[Profile] Created profile for user ${user.uid}');
    }
  }

  Stream<UserProfile?> watchProfile() {
    return _db
        .doc(FirestorePaths.user(currentUid))
        .snapshots()
        .map((s) => s.exists ? UserProfile.fromFirestore(s) : null);
  }

  Future<UserProfile> fetchProfile() async {
    final snap = await _db.doc(FirestorePaths.user(currentUid)).get();
    if (!snap.exists) {
      throw Exception('Profile not found');
    }
    return UserProfile.fromFirestore(snap);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _db
        .doc(FirestorePaths.user(profile.uid))
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  // ── Usage Tracking & Credits ─────────────────────────────────────────────
  
  Future<void> trackUsage({
    required AssetPipeline pipeline,
    DocumentType? type,
    DocumentAsset? existingAsset,
    bool isFinalImage = false,
  }) async {
    final docRef = _db.doc(FirestorePaths.user(currentUid));
    
    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) throw Exception('User profile not found.');
      
      var profile = UserProfile.fromFirestore(snap);
      final now = DateTime.now();

      int cost = 0;
      if (pipeline == AssetPipeline.structural) {
        if (existingAsset == null) {
          cost = CreditCosts.getDocCost(type ?? DocumentType.other);
        } else {
          if (existingAsset.isComplexType && existingAsset.revisionCount < 3) {
            cost = 0;
          } else {
            cost = CreditCosts.minorRevision;
          }
        }
      } else {
        cost = isFinalImage ? CreditCosts.imageFinal : CreditCosts.imageDraft;
      }

      if (profile.totalCredits < cost) {
        throw Exception('Insufficient credits. Need $cost, have ${profile.totalCredits}. Please top up.');
      }

      int subBalance = profile.subscriptionCredits;
      int topBalance = profile.topUpCredits;

      if (subBalance >= cost) {
        subBalance -= cost;
      } else {
        int remainder = cost - subBalance;
        subBalance = 0;
        topBalance -= remainder;
      }

      profile = profile.copyWith(
        subscriptionCredits: subBalance,
        topUpCredits: topBalance,
        updatedAt: now,
      );
      
      tx.update(docRef, profile.toFirestore());
      
      if (existingAsset != null && pipeline == AssetPipeline.structural) {
         final assetRef = _db.doc(FirestorePaths.document(currentUid, existingAsset.portfolioId, existingAsset.id));
         tx.update(assetRef, {'revisionCount': existingAsset.revisionCount + 1});
      }
    });
  }

  Future<void> processSubscriptionChange({
    required UserTier newTier,
    required DateTime purchaseDate,
    DateTime? expiryDate,
  }) async {
    final docRef = _db.doc(FirestorePaths.user(currentUid));
    debugPrint('[Subscription] Processing change to ${newTier.name} (Purchase Date: $purchaseDate)');

    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) {
        debugPrint('[Subscription] ABORT: Profile not found in Firestore.');
        return;
      }
      
      final profile = UserProfile.fromFirestore(snap);
      final now = DateTime.now();
      
      // Credit grant rule: only if this specific purchase (period) hasn't been credited yet
      bool shouldGrantCredits = profile.lastCreditReset == null || 
                                purchaseDate.isAfter(profile.lastCreditReset!);

      if (!shouldGrantCredits) {
        debugPrint('[Subscription] No credit grant needed (already processed). Updating tier/expiry only.');
        tx.update(docRef, {
          'tier': newTier.name, // Enum.name is used for string-indexed enums
          'subscriptionEndDate': expiryDate != null ? Timestamp.fromDate(expiryDate) : null,
          'updatedAt': Timestamp.now(),
        });
        return;
      }

      final limits = TierLimits.get(newTier);
      
      // Rollover Logic
      int rolledOver = profile.subscriptionCredits;
      if (profile.isFree) rolledOver = 0;
      
      if (rolledOver > limits.rolloverCap) {
        rolledOver = limits.rolloverCap;
      }
      
      int newBalance = rolledOver + limits.monthlyAllowance;
      if (newBalance > limits.rolloverCap) {
        newBalance = limits.rolloverCap;
      }

      debugPrint('[Subscription] GRANTING CREDITS: $rolledOver (rollover) + ${limits.monthlyAllowance} (allowance) = $newBalance');

      final updated = profile.copyWith(
        tier: newTier,
        subscriptionCredits: newBalance,
        lastCreditReset: purchaseDate,
        subscriptionEndDate: expiryDate,
        updatedAt: now,
      );
      
      tx.update(docRef, updated.toFirestore());
    });
  }

  Future<void> addTopUpCredits(int amount) async {
    final docRef = _db.doc(FirestorePaths.user(currentUid));
    debugPrint('[Top-Up] Adding $amount credits to top-up wallet.');
    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final profile = UserProfile.fromFirestore(snap);
      tx.update(docRef, {
        'topUpCredits': profile.topUpCredits + amount, 
        'updatedAt': Timestamp.now()
      });
    });
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();

  Future<void> deleteUserAccount() async {
    final uid = currentUid;
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _db.batch();
    final portfolios = await _db.collection(FirestorePaths.portfoliosCol(uid)).get();
    for (final p in portfolios.docs) {
      final docs = await _db.collection(FirestorePaths.documentsCol(uid, p.id)).get();
      for (final d in docs.docs) {
        batch.delete(d.reference);
      }
      batch.delete(p.reference);
      batch.delete(_db.doc(FirestorePaths.userContextDoc(uid, p.id)));
    }
    batch.delete(_db.doc(FirestorePaths.user(uid)));
    await batch.commit();

    try {
      final userRef = _storage.ref('users/$uid');
      final list = await userRef.listAll();
      for (final prefix in list.prefixes) {
        final folderList = await prefix.listAll();
        for (final item in folderList.items) {
          await item.delete();
        }
      }
    } catch (e) {
      debugPrint('[FirebaseService] Storage deletion warning: $e');
    }

    await user.delete();
  }

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
    final profile = await fetchProfile();
    final limits = TierLimits.get(profile.tier);
    final countSnap = await _db.collection(FirestorePaths.portfoliosCol(uid)).count().get();
    if ((countSnap.count ?? 0) >= limits.maxWorkspaces) {
      throw Exception('Workspace limit reached for your tier (${profile.tier.name.toUpperCase()}). Please upgrade to add more.');
    }

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

  Future<DocumentAsset> updateDocumentAsset(DocumentAsset asset) async {
    final updated = asset.copyWith(updatedAt: DateTime.now());
    await _db
        .doc(FirestorePaths.document(currentUid, asset.portfolioId, asset.id))
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

  Future<int> getNextVersionNumber(
      String portfolioId, String documentId) async {
    final snap = await _db
        .collection(FirestorePaths.versionsCol(
        currentUid, portfolioId, documentId))
        .count()
        .get();
    return (snap.count ?? 0) + 1;
  }

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
    try { await _storage.refFromURL(assetUrl).delete(); } catch (_) {}
    await _db
        .doc(FirestorePaths.userContextDoc(currentUid, portfolioId))
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
