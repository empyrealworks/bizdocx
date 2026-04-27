import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum UserTier { free, pro, premium }

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String email,
    String? displayName,
    @Default(UserTier.free) UserTier tier,
    @Default(0) int credits,
    DateTime? lastCreditReset,
    
    // Limits tracking for Free Tier
    @Default(0) int dailyDocGens,
    DateTime? lastDocGenDate,
    @Default(0) int weeklyImageGens,
    DateTime? lastImageGenDate,
    
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserProfile.fromJson({
      ...data,
      'uid': doc.id,
      'lastCreditReset': _toIso(data['lastCreditReset']),
      'lastDocGenDate': _toIso(data['lastDocGenDate']),
      'lastImageGenDate': _toIso(data['lastImageGenDate']),
      'createdAt': _toIso(data['createdAt']),
      'updatedAt': _toIso(data['updatedAt']),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'lastCreditReset': _toTs(lastCreditReset),
      'lastDocGenDate': _toTs(lastDocGenDate),
      'lastImageGenDate': _toTs(lastImageGenDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now(),
    }..remove('uid');
  }

  static String? _toIso(dynamic val) {
    if (val is Timestamp) return val.toDate().toIso8601String();
    return val as String?;
  }

  static dynamic _toTs(DateTime? dt) {
    if (dt == null) return null;
    return Timestamp.fromDate(dt);
  }

  bool get isFree => tier == UserTier.free;
  bool get isPro => tier == UserTier.pro;
  bool get isPremium => tier == UserTier.premium;
}

class TierLimits {
  final int maxWorkspaces;
  final int monthlyCredits;
  final bool premiumTemplates;
  final bool watermarked;

  const TierLimits({
    required this.maxWorkspaces,
    required this.monthlyCredits,
    required this.premiumTemplates,
    required this.watermarked,
  });

  static const free = TierLimits(
    maxWorkspaces: 1,
    monthlyCredits: 0, // Uses time-based limits instead
    premiumTemplates: false,
    watermarked: true,
  );

  static const pro = TierLimits(
    maxWorkspaces: 1,
    monthlyCredits: 100,
    premiumTemplates: true,
    watermarked: false,
  );

  static const premium = TierLimits(
    maxWorkspaces: 3,
    monthlyCredits: 500,
    premiumTemplates: true,
    watermarked: false,
  );

  static TierLimits get(UserTier tier) {
    switch (tier) {
      case UserTier.free: return free;
      case UserTier.pro: return pro;
      case UserTier.premium: return premium;
    }
  }
}
