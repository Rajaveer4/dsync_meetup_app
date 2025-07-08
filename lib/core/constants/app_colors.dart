import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // Default colors for fallback use
  static const Color primary = primaryLight;
  static const Color secondary = secondaryLight;
  static const Color background = backgroundLight;

  // ==================== Light Theme Colors ====================
  static const Color primaryLight = Color(0xFF4361EE);
  static const Color primaryLightVariant = Color(0xFF3A56D5);
  static const Color secondaryLight = Color(0xFF3F37C9);
  static const Color secondaryLightVariant = Color(0xFF372FB5);
  static const Color accentLight = Color(0xFF4895EF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFE63946);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF212529);
  static const Color onSurfaceLight = Color(0xFF212529);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // ==================== Dark Theme Colors ====================
  static const Color primaryDark = Color(0xFF7209B7);
  static const Color primaryDarkVariant = Color(0xFF5E08A0);
  static const Color secondaryDark = Color(0xFF560BAD);
  static const Color secondaryDarkVariant = Color(0xFF4A0993);
  static const Color accentDark = Color(0xFFB5179E);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color errorDark = Color(0xFFEF233C);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);

  // ==================== Common Colors ====================
  static const Color success = Color(0xFF2ECC71);
  static const Color successVariant = Color(0xFF25A55B);
  static const Color warning = Color(0xFFFF9F1C);
  static const Color warningVariant = Color(0xFFE88E0F);
  static const Color info = Color(0xFF17C3B2);
  static const Color disabled = Color(0xFFADB5BD);

  // ==================== Neutral Colors ====================
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF6C757D);
  static const Color lightGrey = Color(0xFFE9ECEF);
  static const Color darkGrey = Color(0xFF343A40);

  // ==================== Text Colors ====================
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF495057);
  static const Color textHint = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFFADB5BD);

  // ==================== Border Colors ====================
  static const Color borderLight = Color(0xFFDEE2E6);
  static const Color borderDark = Color(0xFF343A40);

  // ==================== Overlay Colors ====================
  static const Color overlayLight = Color(0x33000000); // 20% opacity
  static const Color overlayDark = Color(0x80FFFFFF); // 50% opacity

  // ==================== Elevation Overlays ====================
  static const Color elevationOverlayLight = Color(0x0D000000); // 5% opacity
  static const Color elevationOverlayDark = Color(0x1AFFFFFF); // 10% opacity

  // ==================== Helper Methods ====================
  /// Returns the appropriate color based on theme brightness
  static Color getPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryDark
        : primaryLight;
  }

  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  /// Creates a MaterialColor swatch from a single color
  static MaterialColor createMaterialSwatch(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = (color.red * 255.0).round();
    final int g = (color.green * 255.0).round();
    final int b = (color.blue * 255.0).round();

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // Predefined Material color swatches
  static MaterialColor primarySwatch = createMaterialSwatch(primaryLight);
  static MaterialColor secondarySwatch = createMaterialSwatch(secondaryLight);
  static MaterialColor accentSwatch = createMaterialSwatch(accentLight);
}