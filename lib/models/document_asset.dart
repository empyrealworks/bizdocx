import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_asset.freezed.dart';
part 'document_asset.g.dart';

enum DocumentType {
  invoice,
  proposal,
  letterhead,
  businessCard,
  logo,
  icon,
  contract,
  other,
}

enum AssetPipeline { structural, graphical }

@freezed
abstract class DocumentAsset with _$DocumentAsset {
  const factory DocumentAsset({
    required String id,
    required String portfolioId,
    required String userId,
    required String title,
    required DocumentType type,
    required AssetPipeline pipeline,
    // Structural pipeline fields
    String? htmlContent,
    // Graphical pipeline fields
    String? storageUrl,
    // Shared / cache
    String? localCachePath,  // absolute path on device
    String? prompt,          // the original user prompt
    @Default(false) bool isCached,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _DocumentAsset;

  const DocumentAsset._();

  factory DocumentAsset.fromJson(Map<String, dynamic> json) =>
      _$DocumentAssetFromJson(json);

  factory DocumentAsset.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DocumentAsset.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': data['createdAt'] is Timestamp 
          ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
          : data['createdAt'],
      'updatedAt': data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
          : data['updatedAt'],
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    }..remove('id')..remove('localCachePath')..remove('isCached');
  }

  bool get isStructural => pipeline == AssetPipeline.structural;
  bool get isGraphical => pipeline == AssetPipeline.graphical;
}
