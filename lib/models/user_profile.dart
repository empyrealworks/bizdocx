import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_asset.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum UserTier { 
  @JsonValue('free') free, 
  @JsonValue('solopreneur') solopreneur, 
  @JsonValue('agency') agency 
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String email,
    String? displayName,
    @Default(UserTier.free) UserTier tier,
    
    // Wallets
    @Default(50) int subscriptionCredits,
    @Default(0) int topUpCredits,
    
    // Limits tracking
    DateTime? lastCreditReset,
    DateTime? subscriptionEndDate,
    @Default(false) bool autoRenew,
    
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
      'subscriptionEndDate': _toIso(data['subscriptionEndDate']),
      'createdAt': _toIso(data['createdAt']),
      'updatedAt': _toIso(data['updatedAt']),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'lastCreditReset': _toTs(lastCreditReset),
      'subscriptionEndDate': _toTs(subscriptionEndDate),
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

  int get totalCredits => subscriptionCredits + topUpCredits;
  bool get isFree => tier == UserTier.free;
  bool get isSolopreneur => tier == UserTier.solopreneur;
  bool get isAgency => tier == UserTier.agency;
}

class TierLimits {
  final int maxWorkspaces;
  final int monthlyAllowance;
  final int rolloverCap;
  final bool unlockMultiPage;
  final bool unlockHighRes;
  final bool unlockHeavyModels;
  final bool watermarked;

  const TierLimits({
    required this.maxWorkspaces,
    required this.monthlyAllowance,
    required this.rolloverCap,
    required this.unlockMultiPage,
    required this.unlockHighRes,
    required this.unlockHeavyModels,
    required this.watermarked,
  });

  static const free = TierLimits(
    maxWorkspaces: 1,
    monthlyAllowance: 50,
    rolloverCap: 50, // Does not roll over
    unlockMultiPage: false,
    unlockHighRes: false,
    unlockHeavyModels: false,
    watermarked: true,
  );

  static const solopreneur = TierLimits(
    maxWorkspaces: 1,
    monthlyAllowance: 1200,
    rolloverCap: 3600,
    unlockMultiPage: true,
    unlockHighRes: true,
    unlockHeavyModels: false,
    watermarked: false,
  );

  static const agency = TierLimits(
    maxWorkspaces: 3,
    monthlyAllowance: 3500,
    rolloverCap: 10500,
    unlockMultiPage: true,
    unlockHighRes: true,
    unlockHeavyModels: true,
    watermarked: false,
  );

  static TierLimits get(UserTier tier) {
    switch (tier) {
      case UserTier.free: return free;
      case UserTier.solopreneur: return solopreneur;
      case UserTier.agency: return agency;
    }
  }
}

class CreditCosts {
  static const singlePageDoc = 15;
  static const multiPageDoc = 100;
  static const minorRevision = 5;
  static const imageDraft = 25;
  static const imageFinal = 150;
  
  static int getDocCost(DocumentType type, {bool isRevision = false}) {
    if (isRevision) return minorRevision;
    switch (type) {
      case DocumentType.invoice:
      case DocumentType.letterhead:
      case DocumentType.businessCard:
        return singlePageDoc;
      case DocumentType.proposal:
      case DocumentType.contract:
        return multiPageDoc;
      default:
        return singlePageDoc;
    }
  }
}
