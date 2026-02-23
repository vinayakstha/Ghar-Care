import 'package:flutter/material.dart';
import 'package:ghar_care/app/theme/app_colors.dart';

ThemeData getApplicationTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: 'Inter Regular',

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 3.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}

ThemeData getApplicationDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: "Inter Regular",

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 3.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
  );
}
