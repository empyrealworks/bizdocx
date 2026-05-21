import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_folder.freezed.dart';
part 'document_folder.g.dart';

@freezed
abstract class DocumentFolder with _$DocumentFolder {
  const factory DocumentFolder({
    required String id,
    required String portfolioId,
    required String name,
    @Default(true) bool isAiGenerated,
    required DateTime createdAt,
  }) = _DocumentFolder;

  const DocumentFolder._();

  factory DocumentFolder.fromJson(Map<String, dynamic> json) =>
      _$DocumentFolderFromJson(json);

  factory DocumentFolder.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DocumentFolder.fromJson({
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
