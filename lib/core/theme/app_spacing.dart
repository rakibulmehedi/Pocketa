import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Centralized spacing tokens that mirror responsive system
class AppSpacing {
  AppSpacing._();

  /// Extra small spacing (4px)
  static const double xs = 4.0;

  /// Small spacing (8px)
  static const double sm = 8.0;

  /// Medium spacing (12px)
  static const double md = 12.0;

  /// Large spacing (16px)
  static const double lg = 16.0;

  /// Extra large spacing (24px)
  static const double xl = 24.0;

  /// 2X large spacing (32px)
  static const double xxl = 32.0;

  /// 3X large spacing (48px)
  static const double xxxl = 48.0;

  /// Get responsive spacing based on context
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final layout = context.layout;
    return baseSpacing * layout.uiScale;
  }

  /// Get spacing for different component types
  static double getButtonPadding(BuildContext context) => 
      getResponsiveSpacing(context, lg);
  
  static double getCardPadding(BuildContext context) => 
      getResponsiveSpacing(context, lg);
  
  static double getInputPadding(BuildContext context) => 
      getResponsiveSpacing(context, md);
  
  static double getPageGutter(BuildContext context) => 
      getResponsiveSpacing(context, lg);
  
  static double getSectionSpacing(BuildContext context) => 
      getResponsiveSpacing(context, xl);

  /// Get EdgeInsets for common patterns
  static EdgeInsets getButtonPaddingInsets(BuildContext context) => 
      EdgeInsets.symmetric(
        horizontal: getButtonPadding(context),
        vertical: getResponsiveSpacing(context, md),
      );
  
  static EdgeInsets getCardPaddingInsets(BuildContext context) => 
      EdgeInsets.all(getCardPadding(context));
  
  static EdgeInsets getInputPaddingInsets(BuildContext context) => 
      EdgeInsets.symmetric(
        horizontal: getInputPadding(context),
        vertical: getResponsiveSpacing(context, md),
      );
}
