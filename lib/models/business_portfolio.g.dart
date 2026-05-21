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
      businessAddress: json['businessAddress'] as String? ?? '',
      businessEmail: json['businessEmail'] as String? ?? '',
      businessPhone: json['businessPhone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      country: json['country'] as String? ?? 'Nigeria',
      defaultCurrency: json['defaultCurrency'] as String? ?? 'NGN',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      documentIds:
          (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      enableManualMode: json['enableManualMode'] as bool? ?? false,
      recentClients:
          (json['recentClients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'businessAddress': instance.businessAddress,
      'businessEmail': instance.businessEmail,
      'businessPhone': instance.businessPhone,
      'website': instance.website,
      'country': instance.country,
      'defaultCurrency': instance.defaultCurrency,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'documentIds': instance.documentIds,
      'enableManualMode': instance.enableManualMode,
      'recentClients': instance.recentClients,
    };
