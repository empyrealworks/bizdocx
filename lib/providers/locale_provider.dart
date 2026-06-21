import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_service.dart';
import '../services/prefs_service.dart';
import 'profile_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    ref.listen(userProfileProvider, (prev, next) {
      final remoteSettings = next.value?.settings;
      if (remoteSettings != null && remoteSettings.containsKey('localeCode')) {
        final remoteLocale = Locale(remoteSettings['localeCode'] as String);
        if (state != remoteLocale) {
          state = remoteLocale;
          PrefsService.instance.setLocaleCode(remoteLocale.languageCode);
        }
      }
    });

    final code = PrefsService.instance.localeCode;
    if (code != null) return Locale(code);
    
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    await PrefsService.instance.setLocaleCode(locale.languageCode);
    _syncToRemote();
  }

  void _syncToRemote() {
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      final updatedSettings = Map<String, dynamic>.from(profile.settings);
      updatedSettings['localeCode'] = state.languageCode;
      FirebaseService.instance.updateSettings(updatedSettings);
    }
  }
}
