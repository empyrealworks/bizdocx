/// Centralised path factory — all Firestore/Storage paths in one place.
/// Firestore: users/{uid}/portfolios/{pid}/documents/{did}
/// Storage:   users/{uid}/portfolios/{pid}/{assetType}/{filename}
abstract final class FirestorePaths {
  // ── Firestore ────────────────────────────────────────────
  static String user(String uid) => 'users/$uid';

  static String portfoliosCol(String uid) => 'users/$uid/portfolios';
  static String portfolio(String uid, String pid) =>
      'users/$uid/portfolios/$pid';

  static String documentsCol(String uid, String pid) =>
      'users/$uid/portfolios/$pid/documents';
  static String document(String uid, String pid, String did) =>
      'users/$uid/portfolios/$pid/documents/$did';

  /// Version snapshots for a single document.
  static String versionsCol(String uid, String pid, String did) =>
      'users/$uid/portfolios/$pid/documents/$did/versions';
  static String version(String uid, String pid, String did, String vid) =>
      'users/$uid/portfolios/$pid/documents/$did/versions/$vid';

  static String userContextDoc(String uid, String pid) =>
      'users/$uid/portfolios/$pid/context/profile';

  // ── Storage ──────────────────────────────────────────────
  static String logoPath(String uid, String pid, String filename) =>
      'users/$uid/portfolios/$pid/logos/$filename';
  static String documentAssetPath(String uid, String pid, String filename) =>
      'users/$uid/portfolios/$pid/assets/$filename';
  static String uploadedAssetPath(String uid, String pid, String filename) =>
      'users/$uid/portfolios/$pid/uploads/$filename';
  static String imagePath(String uid, String pid, String filename) =>
      'users/$uid/portfolios/$pid/images/$filename';

  // ── Local Cache ──────────────────────────────────────────
  static String localDocumentDir(String uid, String pid) =>
      '$uid/$pid/documents';
  static String localLogoDir(String uid, String pid) => '$uid/$pid/logos';
}