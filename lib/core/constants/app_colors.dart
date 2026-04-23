import 'package:flutter/material.dart';

/// Compile-time constants for colours that never change between themes.
/// Semantic / surface colours are in [AppColorTokens] and accessed via
/// `context.colors` so they respond to light / dark switching.
abstract final class AppColors {
  // ── Brand palette ─────────────────────────────────────────
  static const black    = Color(0xFF0A0A0A);
  static const white    = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF5F5F5);
  static const silver   = Color(0xFFB0B0B0);

  // ── Status colours (same across both themes) ──────────────
  static const error   = Color(0xFFFF453A);
  static const success = Color(0xFF30D158);
  static const warning = Color(0xFFFFD60A);

  // ── Dark-theme surface palette (kept for places that still
  //    use const AppColors.X and haven't been migrated yet) ──
  /// @deprecated Use context.colors.surface
  static const surface  = Color(0xFF141414);
  /// @deprecated Use context.colors.card
  static const card     = Color(0xFF1A1A1A);
  /// @deprecated Use context.colors.border
  static const border   = Color(0xFF2A2A2A);
  /// @deprecated Use context.colors.inputFill
  static const graphite = Color(0xFF2D2D2D);
  /// @deprecated Use context.colors.textMuted
  static const muted    = Color(0xFF6B6B6B);
}