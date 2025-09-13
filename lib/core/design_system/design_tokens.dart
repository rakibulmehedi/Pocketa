import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Centralized design tokens for consistent UI implementation
/// This class provides all design tokens used throughout the app
class DesignTokens {
  DesignTokens._();

  // ── Spacing Tokens ─────────────────────────────────────────────────────────
  static const double spaceXs = 4.0;   // 0.5rem - Micro spacing
  static const double spaceS = 8.0;    // 1rem   - Small spacing
  static const double spaceM = 12.0;   // 1.5rem - Medium spacing
  static const double spaceL = 16.0;   // 2rem   - Large spacing
  static const double spaceXl = 24.0;  // 3rem   - Extra large spacing
  static const double space2xl = 32.0; // 4rem   - 2X large spacing
  static const double space3xl = 48.0; // 6rem   - 3X large spacing

  // ── Border Radius Tokens ──────────────────────────────────────────────────
  static const double radiusXs = 4.0;   // Small elements, tags
  static const double radiusS = 8.0;    // Buttons, small cards
  static const double radiusM = 12.0;   // Cards, inputs, containers
  static const double radiusL = 16.0;   // Large cards, modals
  static const double radiusXl = 24.0;  // Hero elements, major containers
  static const double radiusPill = 999.0; // Fully rounded elements

  // ── Elevation Tokens ──────────────────────────────────────────────────────
  static const double elevation0 = 0.0;   // Flat surfaces
  static const double elevation1 = 1.0;   // Cards, buttons
  static const double elevation2 = 3.0;   // Modals, dropdowns
  static const double elevation3 = 6.0;   // Dialogs, overlays
  static const double elevation4 = 8.0;   // Tooltips, floating elements

  // ── Icon Size Tokens ──────────────────────────────────────────────────────
  static const double iconXs = 12.0;  // Micro icons
  static const double iconS = 16.0;   // Small icons
  static const double iconM = 20.0;   // Medium icons
  static const double iconL = 24.0;   // Large icons
  static const double iconXl = 32.0;  // Extra large icons
  static const double icon2xl = 40.0; // 2X large icons

  // ── Typography Scale Tokens ───────────────────────────────────────────────
  static const double fontSizeXs = 10.0;   // Micro text
  static const double fontSizeS = 12.0;    // Small text
  static const double fontSizeM = 14.0;    // Medium text
  static const double fontSizeL = 16.0;    // Large text
  static const double fontSizeXl = 18.0;   // Extra large text
  static const double fontSize2xl = 20.0;  // 2X large text
  static const double fontSize3xl = 24.0;  // 3X large text
  static const double fontSize4xl = 28.0;  // 4X large text
  static const double fontSize5xl = 32.0;  // 5X large text

  // ── Font Weight Tokens ────────────────────────────────────────────────────
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // ── Line Height Tokens ────────────────────────────────────────────────────
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.25;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.75;

  // ── Letter Spacing Tokens ─────────────────────────────────────────────────
  static const double letterSpacingTight = -0.2;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.3;

  // ── Opacity Tokens ────────────────────────────────────────────────────────
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.7;
  static const double opacityVeryHigh = 0.8;
  static const double opacityAlmostFull = 0.9;

  // ── Animation Duration Tokens ─────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 120);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 320);
  static const Duration animationVerySlow = Duration(milliseconds: 500);

  // ── Shadow Tokens ─────────────────────────────────────────────────────────
  static List<BoxShadow> getShadowLight(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> getShadowMedium(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> getShadowStrong(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> getShadowPrimary(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: 2,
    ),
  ];

  // ── Responsive Helpers ────────────────────────────────────────────────────
  
  /// Get responsive spacing based on device type
  static double getResponsiveSpacing(BuildContext context, {
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    final layout = context.layout;
    return layout.responsiveSize(phone: phone, tablet: tablet, desktop: desktop);
  }

  /// Get responsive icon size based on device type
  static double getResponsiveIconSize(BuildContext context, {
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    final layout = context.layout;
    return layout.responsiveIconSize(phone: phone, tablet: tablet, desktop: desktop);
  }

  /// Get responsive font size based on device type
  static double getResponsiveFontSize(BuildContext context, {
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    final layout = context.layout;
    return layout.responsiveTextSize(phone: phone, tablet: tablet, desktop: desktop);
  }

  /// Get responsive padding based on device type
  static EdgeInsets getResponsivePadding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
      left: left ?? horizontal ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
    );
  }

  /// Get responsive border radius based on device type
  static double getResponsiveRadius(BuildContext context, {
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    final layout = context.layout;
    return layout.responsiveSize(phone: phone, tablet: tablet, desktop: desktop);
  }

  // ── Component-Specific Tokens ────────────────────────────────────────────
  
  /// Button height tokens
  static double getButtonHeight(BuildContext context) {
    return getResponsiveSpacing(context, phone: 48, tablet: 52, desktop: 56);
  }

  /// Button padding tokens
  static EdgeInsets getButtonPadding(BuildContext context) {
    return getResponsivePadding(
      context,
      horizontal: getResponsiveSpacing(context, phone: 20, tablet: 24, desktop: 28),
      vertical: getResponsiveSpacing(context, phone: 12, tablet: 14, desktop: 16),
    );
  }

  /// Card padding tokens
  static EdgeInsets getCardPadding(BuildContext context) {
    return getResponsivePadding(
      context,
      all: getResponsiveSpacing(context, phone: 16, tablet: 20, desktop: 24),
    );
  }

  /// Input padding tokens
  static EdgeInsets getInputPadding(BuildContext context) {
    return getResponsivePadding(
      context,
      horizontal: getResponsiveSpacing(context, phone: 12, tablet: 14, desktop: 16),
      vertical: getResponsiveSpacing(context, phone: 12, tablet: 14, desktop: 16),
    );
  }

  /// Section spacing tokens
  static double getSectionSpacing(BuildContext context) {
    return getResponsiveSpacing(context, phone: 24, tablet: 32, desktop: 40);
  }

  /// Page gutter tokens
  static EdgeInsets getPageGutter(BuildContext context) {
    return getResponsivePadding(
      context,
      horizontal: getResponsiveSpacing(context, phone: 16, tablet: 24, desktop: 32),
      vertical: getResponsiveSpacing(context, phone: 8, tablet: 12, desktop: 16),
    );
  }

  // ── Touch Target Tokens ───────────────────────────────────────────────────
  
  /// Minimum touch target size (accessibility)
  static double getMinTouchTarget(BuildContext context) {
    final layout = context.layout;
    return layout.minTapTarget;
  }

  /// Recommended touch target size
  static double getRecommendedTouchTarget(BuildContext context) {
    return getResponsiveSpacing(context, phone: 44, tablet: 48, desktop: 48);
  }

  // ── Breakpoint Helpers ────────────────────────────────────────────────────
  
  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return context.layout.isMobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    return context.layout.isTablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return context.layout.isDesktop;
  }

  /// Check if current device is compact
  static bool isCompact(BuildContext context) {
    return context.layout.isCompact;
  }
}
