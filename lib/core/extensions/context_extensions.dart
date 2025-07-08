import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  // Theme and MediaQuery shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Navigation methods using GoRouter
  void pushNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).pushNamed(routeName, extra: extra);
  }

  void pushReplacementNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).pushReplacementNamed(routeName, extra: extra);
  }

  void goNamed(String routeName, {Object? extra}) {
    GoRouter.of(this).goNamed(routeName, extra: extra);
  }

  void pop<T extends Object?>([T? result]) {
    GoRouter.of(this).pop(result);
  }

  // Dialog and Snackbar helpers
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }

  // Responsive helpers
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;

  // Text scaling helpers
  TextScaler get textScaler => mediaQuery.textScaler;
  bool get isLargeText => textScaler.scale(1.0) > 1.3;
}