import 'package:flutter/material.dart';
import 'package:pocketa/core/theme/app_elevation.dart';
import 'package:pocketa/core/theme/app_radius.dart';
import 'package:pocketa/core/theme/app_spacing.dart';

/// Centralized button theme configurations
class AppButtonThemes {
  AppButtonThemes._();

  /// Primary button style (FilledButton)
  static ButtonStyle getPrimaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: AppElevation.level1,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      padding: AppSpacing.getButtonPaddingInsets(context),
      minimumSize: Size(0, 48),
      maximumSize: Size.infinite,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Secondary button style (OutlinedButton)
  static ButtonStyle getSecondaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      side: BorderSide(
        color: colorScheme.outline,
        width: 1.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      padding: AppSpacing.getButtonPaddingInsets(context),
      minimumSize: Size(0, 48),
      maximumSize: Size.infinite,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Tonal button style (ElevatedButton)
  static ButtonStyle getTonalButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ElevatedButton.styleFrom(
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      elevation: AppElevation.level1,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      padding: AppSpacing.getButtonPaddingInsets(context),
      minimumSize: Size(0, 48),
      maximumSize: Size.infinite,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Ghost button style (TextButton with background)
  static ButtonStyle getGhostButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return TextButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      backgroundColor: colorScheme.onSurface.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      padding: AppSpacing.getButtonPaddingInsets(context),
      minimumSize: Size(0, 48),
      maximumSize: Size.infinite,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Icon button style
  static ButtonStyle getIconButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return IconButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      minimumSize: Size(48, 48),
      maximumSize: Size(48, 48),
    );
  }

  /// Small button style for compact spaces
  static ButtonStyle getSmallButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return FilledButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: AppElevation.level1,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.getButtonRadius(context)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.getResponsiveSpacing(context, AppSpacing.md),
        vertical: AppSpacing.getResponsiveSpacing(context, AppSpacing.sm),
      ),
      minimumSize: Size(0, 36),
      maximumSize: Size.infinite,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
