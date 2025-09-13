import 'package:flutter/material.dart';

/// App color scheme utilities
class AppColorScheme {
  /// Background gradient for the app
  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0A0A0A),
          Color(0xFF1A1A1A),
          Color(0xFF0F0F0F),
        ],
        stops: [0.0, 0.5, 1.0],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF8F9FA),
          Color(0xFFFFFFFF),
          Color(0xFFF1F3F4),
        ],
        stops: [0.0, 0.5, 1.0],
      );
    }
  }

  /// Card gradient for UI elements
  static LinearGradient cardGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        ],
      );
    }
  }
}
