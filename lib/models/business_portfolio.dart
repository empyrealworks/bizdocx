import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_portfolio.freezed.dart';
part 'business_portfolio.g.dart';

@freezed
abstract class BusinessPortfolio with _$BusinessPortfolio {
  const factory BusinessPortfolio({
    required String id,
    required String userId,
    required String name,
    @Default('') String description,
    @Default('') String mission,
    @Default([]) List<String> brandColors,
    @Default('') String targetAudience,
    String? logoStoragePath,
    String? logoLocalPath,
    @Default([]) List<String> documentIds,
    @Default([]) List<String> uploadedAssetPaths,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BusinessPortfolio;

  const BusinessPortfolio._();

  factory BusinessPortfolio.fromJson(Map<String, dynamic> json) =>
      _$BusinessPortfolioFromJson(json);

  factory BusinessPortfolio.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BusinessPortfolio.fromJson({
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
      'id': FieldValue.delete(),
      'logoLocalPath': FieldValue.delete(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    }..remove('id')..remove('logoLocalPath');
  }
}
