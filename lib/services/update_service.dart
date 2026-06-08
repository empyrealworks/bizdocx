import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  /// Checks for updates on Android and triggers the immediate update flow if available.
  /// On iOS, this is a no-op as 'upgrader' handles the UI via a widget wrapper.
  Future<void> checkForUpdates() async {
    if (!Platform.isAndroid || kDebugMode) return;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          // Flexible update downloads in background.
          // For simplicity and following the user's "force update" request,
          // we prefer immediate if possible. Flexible is a fallback.
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('[UpdateService] Android update check failed: $e');
    }
  }
}
