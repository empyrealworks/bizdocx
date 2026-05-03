// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentVersion _$DocumentVersionFromJson(Map<String, dynamic> json) =>
    _DocumentVersion(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      portfolioId: json['portfolioId'] as String,
      userId: json['userId'] as String,
      htmlContent: json['htmlContent'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      versionNumber: (json['versionNumber'] as num).toInt(),
      refinementPrompt: json['refinementPrompt'] as String?,
      label: json['label'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DocumentVersionToJson(_DocumentVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'portfolioId': instance.portfolioId,
      'userId': instance.userId,
      'htmlContent': instance.htmlContent,
      'imageUrl': instance.imageUrl,
      'versionNumber': instance.versionNumber,
      'refinementPrompt': instance.refinementPrompt,
      'label': instance.label,
      'createdAt': instance.createdAt.toIso8601String(),
    };
