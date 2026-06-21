// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  tier: $enumDecodeNullable(_$UserTierEnumMap, json['tier']) ?? UserTier.free,
  subscriptionCredits: (json['subscriptionCredits'] as num?)?.toInt() ?? 50,
  topUpCredits: (json['topUpCredits'] as num?)?.toInt() ?? 0,
  lastCreditReset: json['lastCreditReset'] == null
      ? null
      : DateTime.parse(json['lastCreditReset'] as String),
  subscriptionEndDate: json['subscriptionEndDate'] == null
      ? null
      : DateTime.parse(json['subscriptionEndDate'] as String),
  autoRenew: json['autoRenew'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  settings: json['settings'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'tier': _$UserTierEnumMap[instance.tier]!,
      'subscriptionCredits': instance.subscriptionCredits,
      'topUpCredits': instance.topUpCredits,
      'lastCreditReset': instance.lastCreditReset?.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'settings': instance.settings,
    };

const _$UserTierEnumMap = {
  UserTier.free: 'free',
  UserTier.solopreneur: 'solopreneur',
  UserTier.agency: 'agency',
};
