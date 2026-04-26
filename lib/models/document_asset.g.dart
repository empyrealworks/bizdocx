// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentAsset _$DocumentAssetFromJson(Map<String, dynamic> json) =>
    _DocumentAsset(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
      pipeline: $enumDecode(_$AssetPipelineEnumMap, json['pipeline']),
      htmlContent: json['htmlContent'] as String?,
      storageUrl: json['storageUrl'] as String?,
      localCachePath: json['localCachePath'] as String?,
      prompt: json['prompt'] as String?,
      isCached: json['isCached'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      templateId: json['templateId'] as String?,
      aspectRatio: json['aspectRatio'] as String?,
      orientation: json['orientation'] as String?,
    );

Map<String, dynamic> _$DocumentAssetToJson(_DocumentAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'userId': instance.userId,
      'title': instance.title,
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'pipeline': _$AssetPipelineEnumMap[instance.pipeline]!,
      'htmlContent': instance.htmlContent,
      'storageUrl': instance.storageUrl,
      'localCachePath': instance.localCachePath,
      'prompt': instance.prompt,
      'isCached': instance.isCached,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'templateId': instance.templateId,
      'aspectRatio': instance.aspectRatio,
      'orientation': instance.orientation,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.invoice: 'invoice',
  DocumentType.proposal: 'proposal',
  DocumentType.letterhead: 'letterhead',
  DocumentType.businessCard: 'businessCard',
  DocumentType.logo: 'logo',
  DocumentType.icon: 'icon',
  DocumentType.contract: 'contract',
  DocumentType.other: 'other',
};

const _$AssetPipelineEnumMap = {
  AssetPipeline.structural: 'structural',
  AssetPipeline.graphical: 'graphical',
};
