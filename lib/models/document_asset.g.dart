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
      paperSize:
          $enumDecodeNullable(_$PaperSizeEnumMap, json['paperSize']) ??
          PaperSize.a4,
      revisionCount: (json['revisionCount'] as num?)?.toInt() ?? 0,
      folderId: json['folderId'] as String?,
      clientName: json['clientName'] as String?,
      isScanned: json['isScanned'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      status:
          $enumDecodeNullable(_$DocumentStatusEnumMap, json['status']) ??
          DocumentStatus.draft,
      signatureBase64: json['signatureBase64'] as String?,
      signedAt: json['signedAt'] == null
          ? null
          : DateTime.parse(json['signedAt'] as String),
      signatureMetadata: json['signatureMetadata'] as Map<String, dynamic>?,
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
      'paperSize': _$PaperSizeEnumMap[instance.paperSize]!,
      'revisionCount': instance.revisionCount,
      'folderId': instance.folderId,
      'clientName': instance.clientName,
      'isScanned': instance.isScanned,
      'metadata': instance.metadata,
      'status': _$DocumentStatusEnumMap[instance.status]!,
      'signatureBase64': instance.signatureBase64,
      'signedAt': instance.signedAt?.toIso8601String(),
      'signatureMetadata': instance.signatureMetadata,
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

const _$PaperSizeEnumMap = {
  PaperSize.a4: 'a4',
  PaperSize.a3: 'a3',
  PaperSize.a5: 'a5',
  PaperSize.letter: 'letter',
  PaperSize.legal: 'legal',
  PaperSize.executive: 'executive',
  PaperSize.tabloid: 'tabloid',
  PaperSize.continuous: 'continuous',
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.draft: 'draft',
  DocumentStatus.signed: 'signed',
};
