import 'package:cloud_firestore/cloud_firestore.dart';

/// A point-in-time snapshot of a structural document's HTML content.
/// Stored at: users/{uid}/portfolios/{pid}/documents/{did}/versions/{vid}
class DocumentVersion {
  const DocumentVersion({
    required this.id,
    required this.documentId,
    required this.portfolioId,
    required this.userId,
    required this.htmlContent,
    required this.versionNumber,
    required this.createdAt,
    this.label, // null = "Version N"; non-null = user-readable label
    this.refinementPrompt, // null for the initial generation (v1)
  });

  final String id;
  final String documentId;
  final String portfolioId;
  final String userId;
  final String htmlContent;
  final int versionNumber;
  final DateTime createdAt;
  final String? label;
  final String? refinementPrompt;

  bool get isOriginal => versionNumber == 1;

  String get displayLabel {
    if (label != null && label!.isNotEmpty) return label!;
    if (isOriginal) return 'Original';
    return 'Version $versionNumber';
  }

  factory DocumentVersion.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DocumentVersion(
      id: doc.id,
      documentId: data['documentId'] as String,
      portfolioId: data['portfolioId'] as String,
      userId: data['userId'] as String,
      htmlContent: data['htmlContent'] as String,
      versionNumber: (data['versionNumber'] as num).toInt(),
      label: data['label'] as String?,
      refinementPrompt: data['refinementPrompt'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'documentId': documentId,
    'portfolioId': portfolioId,
    'userId': userId,
    'htmlContent': htmlContent,
    'versionNumber': versionNumber,
    'label': label,
    'refinementPrompt': refinementPrompt,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}