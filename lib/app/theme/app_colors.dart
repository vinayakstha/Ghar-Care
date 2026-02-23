import 'package:flutter/material.dart';

/// Centralized color definitions for the application
class AppColors {
  // Light theme colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color inputFill = Color(0xFFF0F0F0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE5E5E5);

  // Dark theme colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF808080);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkInputFill = Color(0xFF2D2D2D);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkDivider = Color(0xFF333333);

  // Common colors
  static const Color primary = Color(0xFF006BAA);
  static const Color primaryDark = Color(0xFF3A9F20);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);

  // Opacity variants
  static const Color textSecondary60 = Color(0x99666666); // 60% opacity
  static const Color textSecondary50 = Color(0x80666666); // 50% opacity

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> darkSoftShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
}
