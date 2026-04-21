// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessPortfolio _$BusinessPortfolioFromJson(Map<String, dynamic> json) =>
    _BusinessPortfolio(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      mission: json['mission'] as String? ?? '',
      brandColors:
          (json['brandColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetAudience: json['targetAudience'] as String? ?? '',
      logoStoragePath: json['logoStoragePath'] as String?,
      logoLocalPath: json['logoLocalPath'] as String?,
      documentIds:
          (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      uploadedAssetPaths:
          (json['uploadedAssetPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BusinessPortfolioToJson(_BusinessPortfolio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'mission': instance.mission,
      'brandColors': instance.brandColors,
      'targetAudience': instance.targetAudience,
      'logoStoragePath': instance.logoStoragePath,
      'logoLocalPath': instance.logoLocalPath,
      'documentIds': instance.documentIds,
      'uploadedAssetPaths': instance.uploadedAssetPaths,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
