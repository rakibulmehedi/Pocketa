import 'package:flutter/material.dart';

/// Centralized elevation tokens for consistent depth hierarchy
class AppElevation {
  AppElevation._();

  /// Level 0 - No elevation (flat surfaces)
  static const double level0 = 0.0;

  /// Level 1 - Subtle elevation (cards, buttons)
  static const double level1 = 1.0;

  /// Level 2 - Medium elevation (modals, dropdowns)
  static const double level2 = 3.0;

  /// Level 3 - High elevation (dialogs, overlays)
  static const double level3 = 6.0;

  /// Level 4 - Maximum elevation (tooltips, floating elements)
  static const double level4 = 8.0;

  /// Get elevation with proper shadow configuration
  static List<BoxShadow> getShadow(BuildContext context, double elevation) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (elevation == level0) return [];
    
    final shadowColor = theme.colorScheme.shadow;
    final opacity = isDark ? 0.3 : 0.1;
    
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: opacity),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
      if (elevation > level1)
        BoxShadow(
          color: shadowColor.withValues(alpha: opacity * 0.5),
          blurRadius: elevation * 4,
          offset: Offset(0, elevation * 0.5),
        ),
    ];
  }

  /// Get elevation for different component types
  static double getCardElevation(BuildContext context) => level1;
  static double getButtonElevation(BuildContext context) => level1;
  static double getModalElevation(BuildContext context) => level2;
  static double getDialogElevation(BuildContext context) => level3;
  static double getTooltipElevation(BuildContext context) => level4;
}
