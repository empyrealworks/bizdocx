import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_color_tokens.dart';
import '../constants/app_colors.dart';

abstract final class AppTheme {
  // ── Dark ──────────────────────────────────────────────────
  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    tokens: AppColorTokens.dark,
    systemOverlay: SystemUiOverlayStyle.light,
  );

  // ── Light ─────────────────────────────────────────────────
  static ThemeData get light => _build(
    brightness: Brightness.light,
    tokens: AppColorTokens.light,
    systemOverlay: SystemUiOverlayStyle.dark,
  );

  // ── Builder ───────────────────────────────────────────────
  static ThemeData _build({
    required Brightness brightness,
    required AppColorTokens tokens,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.surface,
      extensions: [tokens],
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: tokens.textPrimary,
        onPrimary: tokens.surface,
        secondary: tokens.textBody,
        onSecondary: tokens.surface,
        error: AppColors.error,
        onError: AppColors.white,
        surface: tokens.card,
        onSurface: tokens.textPrimary,
      ),

      // ── AppBar ─────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: systemOverlay,
        iconTheme: IconThemeData(color: tokens.iconPrimary),
        titleTextStyle: TextStyle(
          color: tokens.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),

      // ── Card ───────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: tokens.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: tokens.border),
        ),
      ),

      // ── Filled Button ──────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.filledButtonBg,
          foregroundColor: tokens.filledButtonFg,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // ── Outlined Button ────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.outlinedButtonFg,
          side: BorderSide(color: tokens.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // ── Text Button ────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.textPrimary,
        ),
      ),

      // ── Input ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.inputFill,
        hintStyle: TextStyle(color: tokens.textMuted, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: tokens.borderStrong, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Divider ────────────────────────────────────────────
      dividerTheme: DividerThemeData(color: tokens.border, space: 1),

      // ── Dialog ────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.card,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Bottom Sheet ───────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── Text ───────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          color: tokens.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: tokens.textSecondary,
          fontSize: 15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: tokens.textBody,
          fontSize: 14,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          color: tokens.textMuted,
          fontSize: 11,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── Snackbar ───────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
        contentTextStyle: const TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}