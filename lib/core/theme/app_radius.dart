import 'package:flutter/material.dart';

/// Centralized radius tokens for consistent border radius
class AppRadius {
  AppRadius._();

  /// Extra small radius (4px) - Small elements, tags
  static const double xs = 4.0;

  /// Small radius (8px) - Buttons, small cards
  static const double sm = 8.0;

  /// Medium radius (12px) - Cards, inputs, containers
  static const double md = 12.0;

  /// Large radius (16px) - Large cards, modals
  static const double lg = 16.0;

  /// Extra large radius (24px) - Hero elements, major containers
  static const double xl = 24.0;

  /// Pill radius (999px) - Fully rounded elements
  static const double pill = 999.0;

  /// Get responsive radius based on context
  static double getResponsiveRadius(BuildContext context, double baseRadius) {
    // For now, return base radius - responsive scaling will be handled by the responsive system
    return baseRadius;
  }

  /// Get radius for different component types
  static double getButtonRadius(BuildContext context) => 
      getResponsiveRadius(context, sm);
  
  static double getCardRadius(BuildContext context) => 
      getResponsiveRadius(context, md);
  
  static double getInputRadius(BuildContext context) => 
      getResponsiveRadius(context, md);
  
  static double getModalRadius(BuildContext context) => 
      getResponsiveRadius(context, lg);
  
  static double getPillRadius(BuildContext context) => 
      getResponsiveRadius(context, pill);
}
