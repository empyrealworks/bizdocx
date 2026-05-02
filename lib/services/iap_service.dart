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

  // Entitlement IDs - MUST match exactly what is in your RevenueCat Dashboard -> Entitlements
  static const _solopreneurEntitlement = 'solopreneur'; 
  static const _agencyEntitlement = 'agency';           

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
    
    debugPrint('[IAP] Initialized for user: $uid');
    
    // Explicitly fetch customer info to sync state
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
      debugPrint('[IAP] Purchase attempt: ${package.identifier}');
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      
      // Update Firestore based on the purchase result
      await _handleCustomerInfo(result.customerInfo);
      
      // Top-up check (Using exact keywords to avoid partial matches like 'solopreneur' matching 'pro')
      final id = package.identifier.toLowerCase();
      if (id.contains('topup') || id.contains('refill')) {
        int amount = 0;
        if (id.contains('mini')) amount = 400;
        else if (id.contains('standard')) amount = 900;
        else if (id.contains('pro_refill') || (id.contains('pro') && id.contains('topup'))) amount = 2000;

        if (amount > 0) {
          debugPrint('[IAP] Top-up confirmed: adding $amount credits.');
          await FirebaseService.instance.addTopUpCredits(amount);
        }
      }
      
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
    
    // VITAL: If 'Registered Entitlements' is empty in your logs, RevenueCat 
    // does not see your Entitlements associated with the current API Key/App.
    debugPrint('[IAP] Registered Entitlements in Dashboard: ${info.entitlements.all.keys.join(', ')}');
    debugPrint('[IAP] Active Entitlements for User: ${info.entitlements.active.keys.join(', ')}');

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

    final fb = FirebaseService.instance;
    if (purchaseDate != null) {
      debugPrint('[IAP] Found Active Entitlement: $newTier. Syncing to Firestore...');
      await fb.processSubscriptionChange(
        newTier: newTier,
        purchaseDate: purchaseDate,
        expiryDate: expiryDate,
      );
    } else {
       // Only revert if we were previously on a paid tier
       // This prevents unnecessary network calls on every app start for free users
       final profile = await fb.fetchProfile();
       if (profile.tier != UserTier.free) {
          debugPrint('[IAP] No active paid entitlements found. Reverting Firestore profile to FREE.');
          await fb.processSubscriptionChange(
            newTier: UserTier.free,
            purchaseDate: DateTime.now(), // Anchor for free tier
          );
       }
    }
  }
}
