import 'package:flutter/material.dart';

/// Semantic color tokens that adapt to light / dark mode.
/// Accessed via `context.colors` (see context_extensions.dart).
///
/// Brand colors that never change (black, white, error, success) stay
/// as compile-time constants on [AppColors].
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.surface,
    required this.card,
    required this.cardElevated,
    required this.border,
    required this.borderStrong,
    required this.inputFill,
    required this.chipFill,
    required this.textPrimary,
    required this.textSecondary,
    required this.textBody,
    required this.textMuted,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.overlayBarrier,
    required this.filledButtonBg,
    required this.filledButtonFg,
    required this.outlinedButtonFg,
  });

  // ── Surfaces ──────────────────────────────────────────────
  final Color surface;       // scaffold background
  final Color card;          // card / bottom sheet background
  final Color cardElevated;  // slightly elevated card (e.g. overlays)

  // ── Borders ───────────────────────────────────────────────
  final Color border;        // default hairline border
  final Color borderStrong;  // focused / accent border

  // ── Fills ─────────────────────────────────────────────────
  final Color inputFill;     // TextField background
  final Color chipFill;      // filter chip / tag background

  // ── Text ──────────────────────────────────────────────────
  final Color textPrimary;   // headings, title
  final Color textSecondary; // body large
  final Color textBody;      // body medium (secondary prose)
  final Color textMuted;     // hints, labels, captions

  // ── Icons ─────────────────────────────────────────────────
  final Color iconPrimary;
  final Color iconSecondary;

  // ── Misc ──────────────────────────────────────────────────
  final Color overlayBarrier;
  final Color filledButtonBg;
  final Color filledButtonFg;
  final Color outlinedButtonFg;

  // ── Presets ───────────────────────────────────────────────

  static const dark = AppColorTokens(
    surface: Color(0xFF141414),
    card: Color(0xFF1A1A1A),
    cardElevated: Color(0xFF222222),
    border: Color(0xFF2A2A2A),
    borderStrong: Color(0xFF4A4A4A),
    inputFill: Color(0xFF2D2D2D),
    chipFill: Color(0xFF2D2D2D),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFF5F5F5),
    textBody: Color(0xFFB0B0B0),
    textMuted: Color(0xFF6B6B6B),
    iconPrimary: Color(0xFFFFFFFF),
    iconSecondary: Color(0xFFB0B0B0),
    overlayBarrier: Color(0xCC000000),
    filledButtonBg: Color(0xFFFFFFFF),
    filledButtonFg: Color(0xFF0A0A0A),
    outlinedButtonFg: Color(0xFFB0B0B0),
  );

  static const light = AppColorTokens(
    surface: Color(0xFFF5F5F5),
    card: Color(0xFFFFFFFF),
    cardElevated: Color(0xFFFAFAFA),
    border: Color(0xFFE8E8E8),
    borderStrong: Color(0xFFAAAAAA),
    inputFill: Color(0xFFF0F0F0),
    chipFill: Color(0xFFEEEEEE),
    textPrimary: Color(0xFF0A0A0A),
    textSecondary: Color(0xFF1A1A1A),
    textBody: Color(0xFF4A4A4A),
    textMuted: Color(0xFF8A8A8A),
    iconPrimary: Color(0xFF0A0A0A),
    iconSecondary: Color(0xFF5A5A5A),
    overlayBarrier: Color(0xB3000000),
    filledButtonBg: Color(0xFF0A0A0A),
    filledButtonFg: Color(0xFFFFFFFF),
    outlinedButtonFg: Color(0xFF4A4A4A),
  );

  // ── ThemeExtension boilerplate ────────────────────────────

  @override
  AppColorTokens copyWith({
    Color? surface,
    Color? card,
    Color? cardElevated,
    Color? border,
    Color? borderStrong,
    Color? inputFill,
    Color? chipFill,
    Color? textPrimary,
    Color? textSecondary,
    Color? textBody,
    Color? textMuted,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? overlayBarrier,
    Color? filledButtonBg,
    Color? filledButtonFg,
    Color? outlinedButtonFg,
  }) =>
      AppColorTokens(
        surface: surface ?? this.surface,
        card: card ?? this.card,
        cardElevated: cardElevated ?? this.cardElevated,
        border: border ?? this.border,
        borderStrong: borderStrong ?? this.borderStrong,
        inputFill: inputFill ?? this.inputFill,
        chipFill: chipFill ?? this.chipFill,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textBody: textBody ?? this.textBody,
        textMuted: textMuted ?? this.textMuted,
        iconPrimary: iconPrimary ?? this.iconPrimary,
        iconSecondary: iconSecondary ?? this.iconSecondary,
        overlayBarrier: overlayBarrier ?? this.overlayBarrier,
        filledButtonBg: filledButtonBg ?? this.filledButtonBg,
        filledButtonFg: filledButtonFg ?? this.filledButtonFg,
        outlinedButtonFg: outlinedButtonFg ?? this.outlinedButtonFg,
      );

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) return this;
    return AppColorTokens(
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardElevated: Color.lerp(cardElevated, other.cardElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      chipFill: Color.lerp(chipFill, other.chipFill, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      overlayBarrier: Color.lerp(overlayBarrier, other.overlayBarrier, t)!,
      filledButtonBg: Color.lerp(filledButtonBg, other.filledButtonBg, t)!,
      filledButtonFg: Color.lerp(filledButtonFg, other.filledButtonFg, t)!,
      outlinedButtonFg:
      Color.lerp(outlinedButtonFg, other.outlinedButtonFg, t)!,
    );
  }
}