import 'package:flutter/material.dart';
import 'package:dsync_meetup_app/core/constants/app_colors.dart';

ThemeData get lightTheme {
  try {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceLight, // Replaced deprecated background with surface
        error: AppColors.errorLight,
        onPrimary: AppColors.onPrimaryLight,
        onSecondary: AppColors.onSecondaryLight,
        onSurface: AppColors.onSurfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimaryLight,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentLight,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.surfaceLight.withOpacity(0.9),
      ),
    );
  } catch (e) {
    debugPrint('Error creating light theme: $e');
    return ThemeData.light();
  }
}

ThemeData get darkTheme {
  try {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark, // Replaced deprecated background with surface
        error: AppColors.errorDark,
        onPrimary: AppColors.onPrimaryDark,
        onSecondary: AppColors.onSecondaryDark,
        onSurface: AppColors.onSurfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimaryDark,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentDark,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.surfaceDark.withOpacity(0.8),
      ),
    );
  } catch (e) {
    debugPrint('Error creating dark theme: $e');
    return ThemeData.dark();
  }
}
