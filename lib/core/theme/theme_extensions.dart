import 'package:flutter/material.dart';
import 'dart:ui'; // For lerpDouble


class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final Color success;
  final Color warning;
  final double cardCornerRadius;
  final EdgeInsets cardPadding;

  const AppThemeExtensions({
    required this.success,
    required this.warning,
    this.cardCornerRadius = 12.0,
    this.cardPadding = const EdgeInsets.all(12),
  });

  @override
  ThemeExtension<AppThemeExtensions> copyWith({
    Color? success,
    Color? warning,
    double? cardCornerRadius,
    EdgeInsets? cardPadding,
  }) {
    return AppThemeExtensions(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      cardCornerRadius: cardCornerRadius ?? this.cardCornerRadius,
      cardPadding: cardPadding ?? this.cardPadding,
    );
  }

  @override
  ThemeExtension<AppThemeExtensions> lerp(
    ThemeExtension<AppThemeExtensions>? other,
    double t,
  ) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    return AppThemeExtensions(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      cardCornerRadius: lerpDouble(cardCornerRadius, other.cardCornerRadius, t)!,
      cardPadding: EdgeInsets.lerp(cardPadding, other.cardPadding, t)!,
    );
  }
}
