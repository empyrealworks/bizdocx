import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../env/env.dart';
import '../models/user_profile.dart';
import 'firebase_service.dart';

class IapService {
  IapService._();
  static final IapService instance = IapService._();

  static const _solopreneurEntitlement = 'solopreneur'; // Updated to match architecture
  static const _agencyEntitlement = 'agency';           // Updated to match architecture

  Future<void> init(String uid) async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(Env.revenueCatAndroidKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(Env.revenueCatIosKey);
    } else {
      return;
    }

    configuration.appUserID = uid;
    await Purchases.configure(configuration);
    
    // Sync entitlement with Firestore immediately
    await syncEntitlements();
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      debugPrint('[IAP] Error fetching offerings: $e');
      return null;
    }
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      await _handleCustomerInfo(result.customerInfo);
      return true;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('[IAP] Purchase error: $e');
      }
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      await _handleCustomerInfo(customerInfo);
    } on PlatformException catch (e) {
      debugPrint('[IAP] Restore error: $e');
    }
  }

  Future<void> syncEntitlements() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      await _handleCustomerInfo(customerInfo);
    } catch (e) {
      debugPrint('[IAP] Sync error: $e');
    }
  }

  Future<void> _handleCustomerInfo(CustomerInfo info) async {
    UserTier newTier = UserTier.free;
    DateTime? purchaseDate;
    DateTime? expiryDate;
    
    final agencyEnt = info.entitlements.all[_agencyEntitlement];
    final soloEnt = info.entitlements.all[_solopreneurEntitlement];

    if (agencyEnt != null && agencyEnt.isActive) {
      newTier = UserTier.agency;
      purchaseDate = DateTime.tryParse(agencyEnt.latestPurchaseDate);
      expiryDate = agencyEnt.expirationDate != null ? DateTime.tryParse(agencyEnt.expirationDate!) : null;
    } else if (soloEnt != null && soloEnt.isActive) {
      newTier = UserTier.solopreneur;
      purchaseDate = DateTime.tryParse(soloEnt.latestPurchaseDate);
      expiryDate = soloEnt.expirationDate != null ? DateTime.tryParse(soloEnt.expirationDate!) : null;
    }

    if (purchaseDate != null) {
      await FirebaseService.instance.processSubscriptionChange(
        newTier: newTier,
        purchaseDate: purchaseDate,
        expiryDate: expiryDate,
      );
    } else if (newTier == UserTier.free) {
       // If no active entitlements, ensure we are on free tier
       final fb = FirebaseService.instance;
       final profile = await fb.fetchProfile();
       if (profile.tier != UserTier.free) {
          debugPrint('[IAP] No active entitlements. Reverting to free tier.');
          await fb.updateProfile(profile.copyWith(
            tier: UserTier.free,
            subscriptionEndDate: null,
            updatedAt: DateTime.now(),
          ));
       }
    }
  }
}
