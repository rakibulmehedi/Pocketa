import 'package:flutter/material.dart';

/// App-wide color utilities for consistent theming with performance optimizations
class AppColors {
  AppColors._();

  // Performance optimization: Cache frequently used colors
  static final Map<String, Color> _colorCache = {};
  
  /// Clear cache when theme changes (call this in theme provider)
  static void clearCache() {
    _colorCache.clear();
  }
  
  /// Get cached color or compute and cache it
  static Color _getCachedColor(String key, Color Function() generator) {
    return _colorCache.putIfAbsent(key, generator);
  }
  

  /// Success colors that adapt to theme (cached for performance)
  static Color success(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'success_${theme.brightness.name}',
      () => theme.colorScheme.secondary,
    );
  }

  static Color successContainer(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'success_container_${theme.brightness.name}',
      () => theme.colorScheme.secondaryContainer,
    );
  }

  static Color onSuccess(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'on_success_${theme.brightness.name}',
      () => theme.colorScheme.onSecondary,
    );
  }

  /// Warning colors (cached for performance)
  static Color warning(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'warning_${theme.brightness.name}',
      () => theme.colorScheme.tertiary,
    );
  }

  static Color warningContainer(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'warning_container_${theme.brightness.name}',
      () => theme.colorScheme.tertiaryContainer,
    );
  }

  /// Error colors (cached for performance)
  static Color error(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'error_${theme.brightness.name}',
      () => theme.colorScheme.error,
    );
  }

  static Color errorContainer(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'error_container_${theme.brightness.name}',
      () => theme.colorScheme.errorContainer,
    );
  }

  /// Surface colors with proper contrast
  static Color surfaceElevated(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.surfaceContainerHighest;
  }

  static Color surfaceOverlay(BuildContext context, {double opacity = 0.1}) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface.withValues(alpha: opacity);
  }

  /// Text colors with proper opacity
  static Color textPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface;
  }

  static Color textSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface.withValues(alpha: 0.7);
  }

  static Color textTertiary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface.withValues(alpha: 0.6);
  }

  /// Shadow colors that adapt to theme
  static Color shadowLight(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.shadow.withValues(alpha: 0.08);
  }

  static Color shadowMedium(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.shadow.withValues(alpha: 0.15);
  }

  static Color shadowStrong(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.shadow.withValues(alpha: 0.25);
  }

  /// Border colors
  static Color borderSubtle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.outline.withValues(alpha: 0.12);
  }

  static Color borderMedium(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.outline.withValues(alpha: 0.2);
  }

  static Color borderStrong(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.outline;
  }

  /// Primary color variations
  static Color primaryLight(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.1);
  }

  static Color primaryMedium(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.2);
  }

  static Color primaryStrong(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.3);
  }

  /// Gradient helpers
  static LinearGradient primaryGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.primary.withValues(alpha: 0.8),
      ],
    );
  }

  static LinearGradient surfaceGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.surface.withValues(alpha: 0.95),
      ],
    );
  }

  /// Success state colors
  static LinearGradient successGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        success(context),
        success(context).withValues(alpha: 0.8),
      ],
    );
  }

  /// Card background with proper elevation
  static Color cardBackground(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  /// Icon colors
  static Color iconPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface;
  }

  static Color iconSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface.withValues(alpha: 0.6);
  }

  static Color iconSuccess(BuildContext context) {
    return success(context);
  }

  /// Button text colors (cached for performance)
  static Color buttonTextPrimary(BuildContext context) {
    return Colors.white; // Always white on primary buttons
  }

  static Color buttonTextSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'button_text_secondary_${theme.brightness.name}',
      () => theme.colorScheme.primary,
    );
  }

  static Color buttonTextDisabled(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'button_text_disabled_${theme.brightness.name}',
      () => theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  // Additional commonly used colors for migration
  
  /// Primary color (cached)
  static Color primary(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'primary_${theme.brightness.name}',
      () => theme.colorScheme.primary,
    );
  }

  /// On primary color (cached)
  static Color onPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'on_primary_${theme.brightness.name}',
      () => theme.colorScheme.onPrimary,
    );
  }

  /// Surface color (cached)
  static Color surface(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'surface_${theme.brightness.name}',
      () => theme.colorScheme.surface,
    );
  }

  /// On surface color (cached)
  static Color onSurface(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'on_surface_${theme.brightness.name}',
      () => theme.colorScheme.onSurface,
    );
  }

  /// Background color (cached)
  static Color background(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'background_${theme.brightness.name}',
      () => theme.colorScheme.surface,
    );
  }

  /// Outline color (cached)
  static Color outline(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'outline_${theme.brightness.name}',
      () => theme.colorScheme.outline,
    );
  }

  /// Shadow color (cached)
  static Color shadow(BuildContext context) {
    final theme = Theme.of(context);
    return _getCachedColor(
      'shadow_${theme.brightness.name}',
      () => theme.colorScheme.shadow,
    );
  }

  /// Transparent color (constant)
  static const Color transparent = Colors.transparent;

  /// White color (constant)
  static const Color white = Colors.white;

  /// Black color (constant)
  static const Color black = Colors.black;

  /// Red color for errors (cached)
  static Color red(BuildContext context) {
    return error(context);
  }

  /// Green color for success (cached)
  static Color green(BuildContext context) {
    return success(context);
  }

  /// Orange color for warnings (cached)
  static Color orange(BuildContext context) {
    return warning(context);
  }

  /// Blue color (cached)
  static Color blue(BuildContext context) {
    return primary(context);
  }
}
