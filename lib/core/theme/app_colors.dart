import 'package:flutter/material.dart';

/// App-wide color utilities for consistent theming
class AppColors {
  AppColors._();

  /// Success colors that adapt to theme
  static Color success(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.secondary; // Green accent from theme
  }

  static Color successContainer(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.secondaryContainer;
  }

  static Color onSuccess(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSecondary;
  }

  /// Warning colors
  static Color warning(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.tertiary;
  }

  static Color warningContainer(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.tertiaryContainer;
  }

  /// Error colors
  static Color error(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.error;
  }

  static Color errorContainer(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.errorContainer;
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

  /// Button text colors
  static Color buttonTextPrimary(BuildContext context) {
    return Colors.white; // Always white on primary buttons
  }

  static Color buttonTextSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary;
  }

  static Color buttonTextDisabled(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.onSurface.withValues(alpha: 0.6);
  }
}
