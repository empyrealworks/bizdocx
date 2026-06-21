import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_service.dart';
import '../services/prefs_service.dart';
import 'profile_provider.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Sync with remote settings if available
    ref.listen(userProfileProvider, (prev, next) {
      final remoteSettings = next.value?.settings;
      if (remoteSettings != null && remoteSettings.containsKey('themeMode')) {
        final remoteTheme = ThemeMode.values[remoteSettings['themeMode'] as int];
        if (state != remoteTheme) {
          state = remoteTheme;
          PrefsService.instance.setThemeMode(remoteTheme);
        }
      }
    });

    return PrefsService.instance.themeMode;
  }

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;
    state = mode;
    PrefsService.instance.setThemeMode(mode);
    _syncToRemote();
  }

  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(mode);
  }

  void _syncToRemote() {
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      final updatedSettings = Map<String, dynamic>.from(profile.settings);
      updatedSettings['themeMode'] = state.index;
      FirebaseService.instance.updateSettings(updatedSettings);
    }
  }
}
