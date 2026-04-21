// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserContext _$UserContextFromJson(Map<String, dynamic> json) => _UserContext(
  userId: json['userId'] as String,
  portfolioId: json['portfolioId'] as String,
  companyName: json['companyName'] as String? ?? '',
  mission: json['mission'] as String? ?? '',
  brandColors:
      (json['brandColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  targetAudience: json['targetAudience'] as String? ?? '',
  logoStorageUrl: json['logoStorageUrl'] as String?,
  recentDocumentTitles:
      (json['recentDocumentTitles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  savedClientDetails:
      (json['savedClientDetails'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  uploadedAssetStoragePaths:
      (json['uploadedAssetStoragePaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$UserContextToJson(_UserContext instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'portfolioId': instance.portfolioId,
      'companyName': instance.companyName,
      'mission': instance.mission,
      'brandColors': instance.brandColors,
      'targetAudience': instance.targetAudience,
      'logoStorageUrl': instance.logoStorageUrl,
      'recentDocumentTitles': instance.recentDocumentTitles,
      'savedClientDetails': instance.savedClientDetails,
      'uploadedAssetStoragePaths': instance.uploadedAssetStoragePaths,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
