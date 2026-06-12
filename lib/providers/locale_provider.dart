import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prefs_service.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = PrefsService.instance.localeCode;
    if (code != null) return Locale(code);
    
    // Default to system locale if supported, otherwise English
    // Note: WidgetsBinding.instance.platformDispatcher.locale might be useful here
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await PrefsService.instance.setLocaleCode(locale.languageCode);
  }
}
