// ─────────────────────────────────────────────────────────────────────────────
// lib/constants/app_colors.dart
// Central color palette for the Nike Shopping App
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary accent – orange exactly as seen in the Dribbble design
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeLight = Color(0xFFFFE8DF);

  // Neutral palette
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF4A4A4A);
  static const Color mediumGray = Color(0xFF9B9B9B);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Background
  static const Color background = Color(0xFFF8F8F8);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Star rating
  static const Color star = Color(0xFFFFB800);

  // Shadow
  static final Color shadow = Colors.black.withValues(alpha: 0.08);
}
