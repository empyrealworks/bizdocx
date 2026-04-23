import 'package:flutter/material.dart';

import '../constants/app_color_tokens.dart';

extension AppColorsX on BuildContext {
  /// Shorthand for the semantic color tokens of the current theme.
  /// Usage: `context.colors.surface`, `context.colors.textPrimary`, etc.
  AppColorTokens get colors =>
      Theme.of(this).extension<AppColorTokens>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}