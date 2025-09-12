import 'package:flutter/material.dart';

/// Centralized color scheme definitions for PocketA
/// Replaces multiple color files with a single source of truth
class AppColorScheme {
  AppColorScheme._();

  // Light Theme Color Scheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0EA5E9), // Sky-500 - Trust, stability
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE0F2FE), // Sky-50
    onPrimaryContainer: Color(0xFF0B6A8F), // Sky-700
    secondary: Color(0xFF10B981), // Emerald-500 - Growth, success
    onSecondary: Color(0xFF062D20), // Emerald-900
    secondaryContainer: Color(0xFFD1FAE5), // Emerald-50
    onSecondaryContainer: Color(0xFF064E3B), // Emerald-800
    tertiary: Color(0xFF94A3B8), // Slate-400
    onTertiary: Color(0xFF0F172A), // Slate-900
    error: Color(0xFFEF4444), // Red-500
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2), // Red-50
    onErrorContainer: Color(0xFF991B1B), // Red-800
    surface: Colors.white,
    onSurface: Color(0xFF121417), // Slate-900
    surfaceContainerHighest: Color(0xFFF3F5F7), // Slate-50
    onSurfaceVariant: Color(0xFF344055), // Slate-600
    outline: Color(0xFFE5EAF0), // Slate-200
    shadow: Color(0x14102028), // Custom shadow
  );

  // Dark Theme Color Scheme
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF38BDF8), // Sky-400
    onPrimary: Color(0xFF0B1220), // Slate-900
    primaryContainer: Color(0xFF0B3A53), // Sky-900
    onPrimaryContainer: Color(0xFFE0F2FE), // Sky-50
    secondary: Color(0xFF34D399), // Emerald-400
    onSecondary: Color(0xFF061A14), // Emerald-900
    secondaryContainer: Color(0xFF065F46), // Emerald-800
    onSecondaryContainer: Color(0xFFA7F3D0), // Emerald-200
    tertiary: Color(0xFF64748B), // Slate-500
    onTertiary: Color(0xFFE2E8F0), // Slate-200
    error: Color(0xFFF87171), // Red-400
    onError: Color(0xFF1C0C0C), // Red-900
    errorContainer: Color(0xFF7F1D1D), // Red-900
    onErrorContainer: Color(0xFFFEE2E2), // Red-50
    surface: Color(0xFF0B0F14), // Slate-950
    onSurface: Color(0xFFE5EAF0), // Slate-200
    surfaceContainerHighest: Color(0xFF121821), // Slate-800
    onSurfaceVariant: Color(0xFFC7D1DE), // Slate-300
    outline: Color(0xFF1E2631), // Slate-700
    shadow: Colors.black54,
  );

  /// Get the appropriate color scheme based on brightness
  static ColorScheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Get semantic colors that adapt to theme
  static Color success(BuildContext context) => of(context).secondary;
  static Color onSuccess(BuildContext context) => of(context).onSecondary;
  static Color successContainer(BuildContext context) => of(context).secondaryContainer;
  static Color onSuccessContainer(BuildContext context) => of(context).onSecondaryContainer;

  static Color warning(BuildContext context) => of(context).tertiary;
  static Color onWarning(BuildContext context) => of(context).onTertiary;
  static Color warningContainer(BuildContext context) => of(context).tertiaryContainer;
  static Color onWarningContainer(BuildContext context) => of(context).onTertiaryContainer;

  static Color error(BuildContext context) => of(context).error;
  static Color onError(BuildContext context) => of(context).onError;
  static Color errorContainer(BuildContext context) => of(context).errorContainer;
  static Color onErrorContainer(BuildContext context) => of(context).onErrorContainer;

  /// Get text colors with proper opacity
  static Color textPrimary(BuildContext context) => of(context).onSurface;
  static Color textSecondary(BuildContext context) => of(context).onSurface.withValues(alpha: 0.7);
  static Color textTertiary(BuildContext context) => of(context).onSurface.withValues(alpha: 0.6);

  /// Get surface colors
  static Color surfaceElevated(BuildContext context) => of(context).surfaceContainerHighest;
  static Color surfaceOverlay(BuildContext context, {double opacity = 0.1}) => 
      of(context).surface.withValues(alpha: opacity);

  /// Get border colors
  static Color borderSubtle(BuildContext context) => of(context).outline.withValues(alpha: 0.12);
  static Color borderMedium(BuildContext context) => of(context).outline.withValues(alpha: 0.2);
  static Color borderStrong(BuildContext context) => of(context).outline;

  /// Get shadow colors
  static Color shadowLight(BuildContext context) => of(context).shadow.withValues(alpha: 0.08);
  static Color shadowMedium(BuildContext context) => of(context).shadow.withValues(alpha: 0.15);
  static Color shadowStrong(BuildContext context) => of(context).shadow.withValues(alpha: 0.25);

  /// Get primary color variations
  static Color primaryLight(BuildContext context) => of(context).primary.withValues(alpha: 0.1);
  static Color primaryMedium(BuildContext context) => of(context).primary.withValues(alpha: 0.2);
  static Color primaryStrong(BuildContext context) => of(context).primary.withValues(alpha: 0.3);

  /// Background gradient for app
  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF070A0F), // background
          Color(0xFF0B0F14), // surface
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF7F9FB), // background
          Colors.white, // surface
        ],
      );
    }
  }
}
