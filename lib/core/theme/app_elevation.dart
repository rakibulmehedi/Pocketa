import 'package:flutter/material.dart';

/// Elevation tokens for consistent depth and shadow
/// Based on Material 3 elevation system
class AppElevation {
  AppElevation._();

  /// Level 0 - No elevation (flat surfaces)
  static const double level0 = 0.0;

  /// Level 1 - Subtle elevation (cards, buttons)
  static const double level1 = 1.0;

  /// Level 2 - Standard elevation (raised cards, floating buttons)
  static const double level2 = 3.0;

  /// Level 3 - High elevation (modals, dropdowns)
  static const double level3 = 6.0;

  /// Level 4 - Highest elevation (dialogs, tooltips)
  static const double level4 = 8.0;

  /// Get elevation for a given level
  static double getElevation(double level) {
    switch (level) {
      case 0:
        return level0;
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
        return level4;
      default:
        return level2;
    }
  }

  /// Get shadow for a given elevation level
  static List<BoxShadow> getShadow(BuildContext context, double level) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final shadowColor = isDark 
        ? Colors.black.withValues(alpha: 0.3)
        : colorScheme.shadow.withValues(alpha: 0.15);
    
    switch (level) {
      case 0:
        return [];
      case 1:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      case 4:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ];
      default:
        return getShadow(context, 2);
    }
  }
}
