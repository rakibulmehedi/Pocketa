import 'package:flutter/material.dart';

/// Comprehensive color system for consistent theming
/// Extends the existing AppColors with additional semantic tokens
class ColorTokens {
  ColorTokens._();

  // ── Primary Color Variations ──────────────────────────────────────────────
  
  /// Primary color with different opacity levels
  static Color primary(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.primary.withValues(alpha: opacity);
  }

  static Color primaryLight(BuildContext context) => primary(context, opacity: 0.1);
  static Color primaryMedium(BuildContext context) => primary(context, opacity: 0.2);
  static Color primaryStrong(BuildContext context) => primary(context, opacity: 0.3);
  static Color primarySubtle(BuildContext context) => primary(context, opacity: 0.05);

  /// Primary container colors
  static Color primaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color onPrimaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimaryContainer;
  }

  // ── Secondary Color Variations ────────────────────────────────────────────
  
  static Color secondary(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.secondary.withValues(alpha: opacity);
  }

  static Color secondaryLight(BuildContext context) => secondary(context, opacity: 0.1);
  static Color secondaryMedium(BuildContext context) => secondary(context, opacity: 0.2);
  static Color secondaryStrong(BuildContext context) => secondary(context, opacity: 0.3);

  static Color secondaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  static Color onSecondaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  // ── Surface Color Variations ──────────────────────────────────────────────
  
  static Color surface(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.surface.withValues(alpha: opacity);
  }

  static Color surfaceElevated(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  static Color surfaceOverlay(BuildContext context, {double opacity = 0.1}) {
    return surface(context, opacity: opacity);
  }

  static Color surfaceGlass(BuildContext context) {
    return surface(context, opacity: 0.85);
  }

  static Color onSurface(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: opacity);
  }

  // ── Text Color Variations ──────────────────────────────────────────────────
  
  static Color textPrimary(BuildContext context) => onSurface(context);
  static Color textSecondary(BuildContext context) => onSurface(context, opacity: 0.7);
  static Color textTertiary(BuildContext context) => onSurface(context, opacity: 0.6);
  static Color textDisabled(BuildContext context) => onSurface(context, opacity: 0.38);
  static Color textHint(BuildContext context) => onSurface(context, opacity: 0.5);

  // ── Semantic Color Variations ──────────────────────────────────────────────
  
  /// Success colors
  static Color success(BuildContext context) {
    return Theme.of(context).colorScheme.secondary; // Green accent
  }

  static Color successLight(BuildContext context) => success(context).withValues(alpha: 0.1);
  static Color successMedium(BuildContext context) => success(context).withValues(alpha: 0.2);
  static Color successStrong(BuildContext context) => success(context).withValues(alpha: 0.3);

  static Color successContainer(BuildContext context) {
    return Theme.of(context).colorScheme.secondaryContainer;
  }

  static Color onSuccessContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onSecondaryContainer;
  }

  /// Warning colors
  static Color warning(BuildContext context) {
    return Theme.of(context).colorScheme.tertiary;
  }

  static Color warningLight(BuildContext context) => warning(context).withValues(alpha: 0.1);
  static Color warningMedium(BuildContext context) => warning(context).withValues(alpha: 0.2);
  static Color warningStrong(BuildContext context) => warning(context).withValues(alpha: 0.3);

  static Color warningContainer(BuildContext context) {
    return Theme.of(context).colorScheme.tertiaryContainer;
  }

  static Color onWarningContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onTertiaryContainer;
  }

  /// Error colors
  static Color error(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static Color errorLight(BuildContext context) => error(context).withValues(alpha: 0.1);
  static Color errorMedium(BuildContext context) => error(context).withValues(alpha: 0.2);
  static Color errorStrong(BuildContext context) => error(context).withValues(alpha: 0.3);

  static Color errorContainer(BuildContext context) {
    return Theme.of(context).colorScheme.errorContainer;
  }

  static Color onErrorContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onErrorContainer;
  }

  /// Info colors
  static Color info(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color infoLight(BuildContext context) => info(context).withValues(alpha: 0.1);
  static Color infoMedium(BuildContext context) => info(context).withValues(alpha: 0.2);
  static Color infoStrong(BuildContext context) => info(context).withValues(alpha: 0.3);

  static Color infoContainer(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color onInfoContainer(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimaryContainer;
  }

  // ── Border Color Variations ───────────────────────────────────────────────
  
  static Color borderSubtle(BuildContext context) {
    return Theme.of(context).colorScheme.outline.withValues(alpha: 0.12);
  }

  static Color borderMedium(BuildContext context) {
    return Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
  }

  static Color borderStrong(BuildContext context) {
    return Theme.of(context).colorScheme.outline;
  }

  static Color borderFocus(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  // ── Shadow Color Variations ───────────────────────────────────────────────
  
  static Color shadowLight(BuildContext context) {
    return Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08);
  }

  static Color shadowMedium(BuildContext context) {
    return Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15);
  }

  static Color shadowStrong(BuildContext context) {
    return Theme.of(context).colorScheme.shadow.withValues(alpha: 0.25);
  }

  static Color shadowPrimary(BuildContext context) {
    return primary(context, opacity: 0.4);
  }

  // ── Icon Color Variations ─────────────────────────────────────────────────
  
  static Color iconPrimary(BuildContext context) => onSurface(context);
  static Color iconSecondary(BuildContext context) => onSurface(context, opacity: 0.6);
  static Color iconDisabled(BuildContext context) => onSurface(context, opacity: 0.38);
  static Color iconSuccess(BuildContext context) => success(context);
  static Color iconWarning(BuildContext context) => warning(context);
  static Color iconError(BuildContext context) => error(context);
  static Color iconInfo(BuildContext context) => info(context);

  // ── Button Color Variations ───────────────────────────────────────────────
  
  static Color buttonPrimary(BuildContext context) => primary(context);
  static Color buttonOnPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;
  static Color buttonSecondary(BuildContext context) => secondary(context);
  static Color buttonOnSecondary(BuildContext context) => Theme.of(context).colorScheme.onSecondary;
  static Color buttonDisabled(BuildContext context) => surfaceElevated(context);
  static Color buttonOnDisabled(BuildContext context) => onSurface(context, opacity: 0.38);

  // ── Gradient Helpers ──────────────────────────────────────────────────────
  
  /// Primary gradient
  static LinearGradient primaryGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primary(context),
        primary(context, opacity: 0.8),
      ],
    );
  }

  /// Secondary gradient
  static LinearGradient secondaryGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        secondary(context),
        secondary(context, opacity: 0.8),
      ],
    );
  }

  /// Success gradient
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

  /// Surface gradient
  static LinearGradient surfaceGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        surface(context),
        surface(context, opacity: 0.95),
      ],
    );
  }

  /// Glass gradient
  static LinearGradient glassGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        surface(context, opacity: 0.98),
        surface(context, opacity: 0.92),
      ],
    );
  }

  // ── Background Gradients ──────────────────────────────────────────────────
  
  /// App background gradient
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

  // ── State-Based Colors ────────────────────────────────────────────────────
  
  /// Get color based on state
  static Color getStateColor(BuildContext context, {
    required Color normal,
    Color? selected,
    Color? pressed,
    Color? disabled,
    Color? hovered,
    Color? focused,
    bool isSelected = false,
    bool isPressed = false,
    bool isDisabled = false,
    bool isHovered = false,
    bool isFocused = false,
  }) {
    if (isDisabled && disabled != null) return disabled;
    if (isPressed && pressed != null) return pressed;
    if (isSelected && selected != null) return selected;
    if (isHovered && hovered != null) return hovered;
    if (isFocused && focused != null) return focused;
    return normal;
  }

  // ── Contrast Helpers ──────────────────────────────────────────────────────
  
  /// Get high contrast color for given background
  static Color getContrastColor(BuildContext context, Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Get accessible text color for given background
  static Color getAccessibleTextColor(BuildContext context, Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 
        ? Theme.of(context).colorScheme.onSurface 
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9);
  }
}
