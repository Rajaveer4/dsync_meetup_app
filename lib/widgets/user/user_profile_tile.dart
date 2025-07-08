import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? placeholderText;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.placeholderText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;
    
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      backgroundImage: imageUrl != null 
          ? CachedNetworkImageProvider(imageUrl!)
          : null,
      child: imageUrl == null
          ? _buildPlaceholder(theme, fgColor)
          : null,
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: avatar,
          )
        : avatar;
  }

  Widget _buildPlaceholder(ThemeData theme, Color fgColor) {
    if (placeholderText != null && placeholderText!.isNotEmpty) {
      return Text(
        placeholderText!.substring(0, 1).toUpperCase(),
        style: theme.textTheme.titleLarge?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Icon(Icons.person, size: radius, color: fgColor);
  }
}