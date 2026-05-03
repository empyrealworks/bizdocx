import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_version.freezed.dart';
part 'document_version.g.dart';

@freezed
abstract class DocumentVersion with _$DocumentVersion {
  const factory DocumentVersion({
    required String id,
    required String documentId,
    required String portfolioId,
    required String userId,
    
    // Content snapshots
    @Default('') String htmlContent, // Used for structural
    String? imageUrl,               // Used for graphical
    
    required int versionNumber,
    String? refinementPrompt,
    String? label,
    required DateTime createdAt,
  }) = _DocumentVersion;

  const DocumentVersion._();

  factory DocumentVersion.fromJson(Map<String, dynamic> json) =>
      _$DocumentVersionFromJson(json);

  factory DocumentVersion.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DocumentVersion.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': data['createdAt'] is Timestamp 
          ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
          : data['createdAt'],
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'createdAt': Timestamp.fromDate(createdAt),
    }..remove('id');
  }
}
