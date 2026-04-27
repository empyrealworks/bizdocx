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
  credits: (json['credits'] as num?)?.toInt() ?? 0,
  lastCreditReset: json['lastCreditReset'] == null
      ? null
      : DateTime.parse(json['lastCreditReset'] as String),
  dailyDocGens: (json['dailyDocGens'] as num?)?.toInt() ?? 0,
  lastDocGenDate: json['lastDocGenDate'] == null
      ? null
      : DateTime.parse(json['lastDocGenDate'] as String),
  weeklyImageGens: (json['weeklyImageGens'] as num?)?.toInt() ?? 0,
  lastImageGenDate: json['lastImageGenDate'] == null
      ? null
      : DateTime.parse(json['lastImageGenDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'tier': _$UserTierEnumMap[instance.tier]!,
      'credits': instance.credits,
      'lastCreditReset': instance.lastCreditReset?.toIso8601String(),
      'dailyDocGens': instance.dailyDocGens,
      'lastDocGenDate': instance.lastDocGenDate?.toIso8601String(),
      'weeklyImageGens': instance.weeklyImageGens,
      'lastImageGenDate': instance.lastImageGenDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserTierEnumMap = {
  UserTier.free: 'free',
  UserTier.pro: 'pro',
  UserTier.premium: 'premium',
};
