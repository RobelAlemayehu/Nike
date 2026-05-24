// ─────────────────────────────────────────────────────────────────────────────
// lib/constants/app_colors.dart
// Central color palette for the Nike Shopping App
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary accent – orange
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeLight = Color(0xFFFFE8DF);

  // Neutral palette – Light mode
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF4A4A4A);
  static const Color mediumGray = Color(0xFF9B9B9B);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Background – Light mode
  static const Color background = Color(0xFFF8F8F8);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Dark mode specific
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2A2A2A);
  static const Color darkText = Color(0xFFEEEEEE);
  static const Color darkSubtext = Color(0xFFAAAAAA);
  static const Color darkBorder = Color(0xFF3A3A3A);

  // Star rating
  static const Color star = Color(0xFFFFB800);

  // Shadow
  static final Color shadow = Colors.black.withValues(alpha: 0.08);

  // ── Helper: returns correct surface color based on brightness ──────────────
  static Color surface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkCard : white;
  }

  static Color scaffoldBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBackground : background;
  }

  static Color primaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkText : black;
  }

  static Color secondaryText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkSubtext : mediumGray;
  }

  /// CTA button background — black in light mode, white in dark mode
  static Color blackButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? white : black;
  }
}
