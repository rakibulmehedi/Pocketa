import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Button theme definitions for consistent button styling
/// Based on Material 3 button specifications
class AppButtonThemes {
  AppButtonThemes._();

  /// Primary button style (FilledButton)
  static ButtonStyle primary(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: colorScheme.surfaceContainerHighest,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      elevation: 1,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surfaceTint,
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceXl,
        vertical: layout.spaceL,
      ),
      minimumSize: const Size(64, 40),
      maximumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusM),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Secondary button style (OutlinedButton)
  static ButtonStyle secondary(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      side: BorderSide(
        color: colorScheme.outline,
        width: 1,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceXl,
        vertical: layout.spaceL,
      ),
      minimumSize: const Size(64, 40),
      maximumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusM),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Tonal button style (FilledButton.tonal)
  static ButtonStyle tonal(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return FilledButton.styleFrom(
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      disabledBackgroundColor: colorScheme.surfaceContainerHighest,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: colorScheme.surfaceTint,
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceXl,
        vertical: layout.spaceL,
      ),
      minimumSize: const Size(64, 40),
      maximumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusM),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Text button style (TextButton)
  static ButtonStyle text(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceL,
        vertical: layout.spaceM,
      ),
      minimumSize: const Size(48, 40),
      maximumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusS),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Icon button style
  static ButtonStyle icon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return IconButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      padding: EdgeInsets.all(layout.spaceM),
      minimumSize: const Size(48, 48),
      maximumSize: const Size(48, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusS),
      ),
    );
  }

  /// Floating action button style
  static FloatingActionButtonThemeData fab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final layout = context.layout;

    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusL),
      ),
    );
  }
}
