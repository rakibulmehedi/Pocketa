import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Responsive color system that adapts to different screen sizes and themes
class ResponsiveColors {
  ResponsiveColors._();

  /// Get responsive shadow color based on screen size
  static Color shadow(BuildContext context, {ShadowIntensity intensity = ShadowIntensity.medium}) {
    final layout = context.layout;
    final baseColor = _getShadowBaseColor(context, intensity);
    
    // Adjust opacity based on screen size
    final opacity = _getShadowOpacity(layout, intensity);
    
    return baseColor.withValues(alpha: opacity);
  }

  /// Get responsive border color based on screen size
  static Color border(BuildContext context, {BorderIntensity intensity = BorderIntensity.medium}) {
    final layout = context.layout;
    final baseColor = _getBorderBaseColor(context, intensity);
    
    // Adjust opacity based on screen size
    final opacity = _getBorderOpacity(layout, intensity);
    
    return baseColor.withValues(alpha: opacity);
  }

  /// Get responsive surface color with proper elevation
  static Color surface(BuildContext context, {SurfaceElevation elevation = SurfaceElevation.normal}) {
    final theme = Theme.of(context);
    
    switch (elevation) {
      case SurfaceElevation.none:
        return theme.colorScheme.surface;
      case SurfaceElevation.low:
        return theme.colorScheme.surfaceContainerLow;
      case SurfaceElevation.normal:
        return theme.colorScheme.surfaceContainerHighest;
      case SurfaceElevation.high:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  /// Get responsive text color with proper contrast
  static Color text(BuildContext context, {TextIntensity intensity = TextIntensity.primary}) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    // Adjust opacity based on screen size for better readability
    final opacity = _getTextOpacity(layout, intensity);
    
    return theme.colorScheme.onSurface.withValues(alpha: opacity);
  }

  /// Get responsive primary color with proper contrast
  static Color primary(BuildContext context, {PrimaryIntensity intensity = PrimaryIntensity.normal}) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    // Adjust opacity based on screen size
    final opacity = _getPrimaryOpacity(layout, intensity);
    
    return theme.colorScheme.primary.withValues(alpha: opacity);
  }

  /// Get responsive success color with proper contrast
  static Color success(BuildContext context, {SuccessIntensity intensity = SuccessIntensity.normal}) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    // Adjust opacity based on screen size
    final opacity = _getSuccessOpacity(layout, intensity);
    
    return theme.colorScheme.secondary.withValues(alpha: opacity);
  }

  /// Get responsive gradient based on screen size
  static LinearGradient gradient(BuildContext context, {GradientType type = GradientType.primary}) {
    final theme = Theme.of(context);
    
    switch (type) {
      case GradientType.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        );
      case GradientType.surface:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.95),
          ],
        );
      case GradientType.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.secondary.withValues(alpha: 0.8),
          ],
        );
    }
  }

  // Private helper methods
  static Color _getShadowBaseColor(BuildContext context, ShadowIntensity intensity) {
    final theme = Theme.of(context);
    switch (intensity) {
      case ShadowIntensity.light:
        return theme.colorScheme.shadow;
      case ShadowIntensity.medium:
        return theme.colorScheme.shadow;
      case ShadowIntensity.strong:
        return theme.colorScheme.shadow;
    }
  }

  static double _getShadowOpacity(AppSize layout, ShadowIntensity intensity) {
    final baseOpacity = switch (intensity) {
      ShadowIntensity.light => 0.08,
      ShadowIntensity.medium => 0.15,
      ShadowIntensity.strong => 0.25,
    };
    
    // Adjust based on screen size
    if (layout.isDesktop) return baseOpacity * 1.2;
    if (layout.isTablet) return baseOpacity * 1.1;
    return baseOpacity;
  }

  static Color _getBorderBaseColor(BuildContext context, BorderIntensity intensity) {
    final theme = Theme.of(context);
    switch (intensity) {
      case BorderIntensity.subtle:
        return theme.colorScheme.outline;
      case BorderIntensity.medium:
        return theme.colorScheme.outline;
      case BorderIntensity.strong:
        return theme.colorScheme.outline;
    }
  }

  static double _getBorderOpacity(AppSize layout, BorderIntensity intensity) {
    final baseOpacity = switch (intensity) {
      BorderIntensity.subtle => 0.12,
      BorderIntensity.medium => 0.2,
      BorderIntensity.strong => 1.0,
    };
    
    // Adjust based on screen size
    if (layout.isDesktop) return baseOpacity * 1.1;
    if (layout.isTablet) return baseOpacity * 1.05;
    return baseOpacity;
  }

  static double _getTextOpacity(AppSize layout, TextIntensity intensity) {
    final baseOpacity = switch (intensity) {
      TextIntensity.primary => 1.0,
      TextIntensity.secondary => 0.7,
      TextIntensity.tertiary => 0.6,
    };
    
    // Adjust based on screen size for better readability
    if (layout.isDesktop) return baseOpacity * 1.05;
    if (layout.isTablet) return baseOpacity * 1.02;
    return baseOpacity;
  }

  static double _getPrimaryOpacity(AppSize layout, PrimaryIntensity intensity) {
    final baseOpacity = switch (intensity) {
      PrimaryIntensity.light => 0.1,
      PrimaryIntensity.normal => 0.2,
      PrimaryIntensity.strong => 0.3,
    };
    
    // Adjust based on screen size
    if (layout.isDesktop) return baseOpacity * 1.1;
    if (layout.isTablet) return baseOpacity * 1.05;
    return baseOpacity;
  }

  static double _getSuccessOpacity(AppSize layout, SuccessIntensity intensity) {
    final baseOpacity = switch (intensity) {
      SuccessIntensity.light => 0.1,
      SuccessIntensity.normal => 0.2,
      SuccessIntensity.strong => 0.3,
    };
    
    // Adjust based on screen size
    if (layout.isDesktop) return baseOpacity * 1.1;
    if (layout.isTablet) return baseOpacity * 1.05;
    return baseOpacity;
  }
}

// Enums for better type safety
enum ShadowIntensity { light, medium, strong }
enum BorderIntensity { subtle, medium, strong }
enum SurfaceElevation { none, low, normal, high }
enum TextIntensity { primary, secondary, tertiary }
enum PrimaryIntensity { light, normal, strong }
enum SuccessIntensity { light, normal, strong }
enum GradientType { primary, surface, success }
