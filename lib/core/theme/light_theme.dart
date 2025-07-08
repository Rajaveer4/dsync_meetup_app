import 'package:flutter/material.dart';
import 'package:dsync_meetup_app/core/constants/app_colors.dart';

ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight, // Using correct color name
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryLight, // Using correct color name
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight, // Using correct color name
      ),
    );