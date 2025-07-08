import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); // Prevent instantiation

  // ==================== HEADLINES ====================
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ==================== BODY TEXT ====================
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ==================== CAPTIONS ====================
  static const TextStyle captionLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle captionMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.4,
  );

  // ==================== BUTTONS ====================
static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 0, 0, 0), // Changed from onPrimary
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 0, 0, 0), // Changed from onPrimary
    height: 1.5,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimaryLight, // Changed from onPrimary
    height: 1.5,
    letterSpacing: 0.5,
  );

  // ==================== SPECIAL CASES ====================
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.errorLight,
    height: 1.4,
  );

  static const TextStyle link = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryLight,
    height: 1.5,
    decoration: TextDecoration.underline,
  );

  // ==================== THEME AWARE METHODS ====================
  static TextStyle getHeadline1(BuildContext context) {
    return headline1.copyWith(
      color: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.onBackgroundDark 
          : AppColors.onBackgroundLight,
    );
  }

  static TextStyle getBodyText(BuildContext context) {
    return bodyMedium.copyWith(
      color: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.onSurfaceDark 
          : AppColors.onSurfaceLight,
    );
  }

  // ==================== HELPER METHODS ====================
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}