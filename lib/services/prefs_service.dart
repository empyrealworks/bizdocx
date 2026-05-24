import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService._();
  static final PrefsService instance = PrefsService._();

  static const _themeKey = 'app_theme_mode';
  static const _portfolioTutorialKey = 'has_seen_portfolio_tutorial';
  static const _viewerTutorialKey = 'has_seen_viewer_tutorial';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ThemeMode get themeMode {
    final index = _prefs.getInt(_themeKey);
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
  }

  bool get hasSeenPortfolioTutorial => _prefs.getBool(_portfolioTutorialKey) ?? false;
  Future<void> markPortfolioTutorialSeen() => _prefs.setBool(_portfolioTutorialKey, true);

  bool get hasSeenViewerTutorial => _prefs.getBool(_viewerTutorialKey) ?? false;
  Future<void> markViewerTutorialSeen() => _prefs.setBool(_viewerTutorialKey, true);
}
