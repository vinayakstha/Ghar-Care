import 'package:flutter/material.dart';
import 'package:ghar_care/app/theme/app_colors.dart';

/// Extension to get theme-aware colors from BuildContext
extension ThemeColorsExtension on BuildContext {
  /// Returns true if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Primary text color (adapts to theme)
  Color get textPrimary =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;

  /// Secondary text color (adapts to theme)
  Color get textSecondary =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;

  /// Tertiary text color (adapts to theme)
  Color get textTertiary =>
      isDarkMode ? AppColors.darkTextTertiary : AppColors.textTertiary;

  /// Background color (adapts to theme)
  Color get backgroundColor =>
      isDarkMode ? AppColors.darkBackground : AppColors.background;

  /// Surface color (adapts to theme)
  Color get surfaceColor =>
      isDarkMode ? AppColors.darkSurface : AppColors.surface;

  /// Surface variant color (adapts to theme)
  Color get surfaceVariantColor =>
      isDarkMode ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant;

  /// Input fill color (adapts to theme)
  Color get inputFillColor =>
      isDarkMode ? AppColors.darkInputFill : AppColors.inputFill;

  /// Border color (adapts to theme)
  Color get borderColor => isDarkMode ? AppColors.darkBorder : AppColors.border;

  /// Divider color (adapts to theme)
  Color get dividerColor =>
      isDarkMode ? AppColors.darkDivider : AppColors.divider;

  /// Card shadow (adapts to theme)
  List<BoxShadow> get cardShadow =>
      isDarkMode ? AppColors.darkCardShadow : AppColors.cardShadow;

  /// Soft shadow (adapts to theme)
  List<BoxShadow> get softShadow =>
      isDarkMode ? AppColors.darkSoftShadow : AppColors.softShadow;

  /// Text secondary with 60% opacity (adapts to theme)
  Color get textSecondary60 => isDarkMode
      ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
      : AppColors.textSecondary60;

  /// Text secondary with 50% opacity (adapts to theme)
  Color get textSecondary50 => isDarkMode
      ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
      : AppColors.textSecondary50;
}
