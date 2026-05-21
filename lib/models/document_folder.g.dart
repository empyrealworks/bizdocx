// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentFolder _$DocumentFolderFromJson(Map<String, dynamic> json) =>
    _DocumentFolder(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      name: json['name'] as String,
      isAiGenerated: json['isAiGenerated'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DocumentFolderToJson(_DocumentFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'name': instance.name,
      'isAiGenerated': instance.isAiGenerated,
      'createdAt': instance.createdAt.toIso8601String(),
    };
