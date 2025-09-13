import 'package:flutter/material.dart';
import 'package:pocketa/core/design_system/design_tokens.dart';

/// Comprehensive typography system for consistent text styling
class TypographyTokens {
  TypographyTokens._();

  // ── Font Family Tokens ────────────────────────────────────────────────────
  static const String fontFamilyPrimary = 'Inter';
  static const List<String> fontFamilyFallback = ['HindSiliguri', 'NotoSans'];

  // ── Display Styles ────────────────────────────────────────────────────────
  
  /// Display Large - Hero text, major headings
  static TextStyle displayLarge(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSize5xl,
        tablet: DesignTokens.fontSize5xl + 4,
        desktop: DesignTokens.fontSize5xl + 8,
      ),
      fontWeight: DesignTokens.fontWeightExtraBold,
      height: DesignTokens.lineHeightTight,
      letterSpacing: DesignTokens.letterSpacingTight,
    );
  }

  /// Display Medium - Large headings
  static TextStyle displayMedium(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSize4xl,
        tablet: DesignTokens.fontSize4xl + 2,
        desktop: DesignTokens.fontSize4xl + 4,
      ),
      fontWeight: DesignTokens.fontWeightBold,
      height: DesignTokens.lineHeightTight,
      letterSpacing: DesignTokens.letterSpacingTight,
    );
  }

  /// Display Small - Medium headings
  static TextStyle displaySmall(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSize3xl,
        tablet: DesignTokens.fontSize3xl + 2,
        desktop: DesignTokens.fontSize3xl + 4,
      ),
      fontWeight: DesignTokens.fontWeightBold,
      height: DesignTokens.lineHeightTight,
      letterSpacing: DesignTokens.letterSpacingTight,
    );
  }

  // ── Headline Styles ───────────────────────────────────────────────────────
  
  /// Headline Large - Section headers
  static TextStyle headlineLarge(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSize2xl,
        tablet: DesignTokens.fontSize2xl + 2,
        desktop: DesignTokens.fontSize2xl + 4,
      ),
      fontWeight: DesignTokens.fontWeightBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  /// Headline Medium - Subsection headers
  static TextStyle headlineMedium(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeXl,
        tablet: DesignTokens.fontSizeXl + 2,
        desktop: DesignTokens.fontSizeXl + 4,
      ),
      fontWeight: DesignTokens.fontWeightBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  /// Headline Small - Card headers
  static TextStyle headlineSmall(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeL,
        tablet: DesignTokens.fontSizeL + 2,
        desktop: DesignTokens.fontSizeL + 4,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  // ── Title Styles ──────────────────────────────────────────────────────────
  
  /// Title Large - Card titles, form labels
  static TextStyle titleLarge(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeL,
        tablet: DesignTokens.fontSizeL + 2,
        desktop: DesignTokens.fontSizeL + 4,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  /// Title Medium - Button text, chip labels
  static TextStyle titleMedium(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeM,
        tablet: DesignTokens.fontSizeM + 1,
        desktop: DesignTokens.fontSizeM + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  /// Title Small - Small labels, metadata
  static TextStyle titleSmall(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeS,
        tablet: DesignTokens.fontSizeS + 1,
        desktop: DesignTokens.fontSizeS + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
    );
  }

  // ── Body Styles ───────────────────────────────────────────────────────────
  
  /// Body Large - Main content text
  static TextStyle bodyLarge(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeL,
        tablet: DesignTokens.fontSizeL + 1,
        desktop: DesignTokens.fontSizeL + 2,
      ),
      fontWeight: DesignTokens.fontWeightNormal,
      height: DesignTokens.lineHeightRelaxed,
    );
  }

  /// Body Medium - Secondary content text
  static TextStyle bodyMedium(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeM,
        tablet: DesignTokens.fontSizeM + 1,
        desktop: DesignTokens.fontSizeM + 2,
      ),
      fontWeight: DesignTokens.fontWeightNormal,
      height: DesignTokens.lineHeightRelaxed,
    );
  }

  /// Body Small - Captions, helper text
  static TextStyle bodySmall(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeS,
        tablet: DesignTokens.fontSizeS + 1,
        desktop: DesignTokens.fontSizeS + 2,
      ),
      fontWeight: DesignTokens.fontWeightNormal,
      height: DesignTokens.lineHeightRelaxed,
    );
  }

  // ── Label Styles ──────────────────────────────────────────────────────────
  
  /// Label Large - Button text, navigation labels
  static TextStyle labelLarge(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeM,
        tablet: DesignTokens.fontSizeM + 1,
        desktop: DesignTokens.fontSizeM + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
      letterSpacing: DesignTokens.letterSpacingWide,
    );
  }

  /// Label Medium - Chip labels, form labels
  static TextStyle labelMedium(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeS,
        tablet: DesignTokens.fontSizeS + 1,
        desktop: DesignTokens.fontSizeS + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
      letterSpacing: DesignTokens.letterSpacingWide,
    );
  }

  /// Label Small - Small UI labels, metadata
  static TextStyle labelSmall(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeXs,
        tablet: DesignTokens.fontSizeXs + 1,
        desktop: DesignTokens.fontSizeXs + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightNormal,
      letterSpacing: DesignTokens.letterSpacingWide,
    );
  }

  // ── Specialized Styles ────────────────────────────────────────────────────
  
  /// Button text style
  static TextStyle buttonText(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeM,
        tablet: DesignTokens.fontSizeM + 1,
        desktop: DesignTokens.fontSizeM + 2,
      ),
      fontWeight: DesignTokens.fontWeightBold,
      height: DesignTokens.lineHeightTight,
      letterSpacing: DesignTokens.letterSpacingWide,
    );
  }

  /// Caption text style
  static TextStyle caption(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeS,
        tablet: DesignTokens.fontSizeS + 1,
        desktop: DesignTokens.fontSizeS + 2,
      ),
      fontWeight: DesignTokens.fontWeightNormal,
      height: DesignTokens.lineHeightNormal,
    );
  }

  /// Overline text style
  static TextStyle overline(BuildContext context) {
    return _buildTextStyle(
      context,
      fontSize: DesignTokens.getResponsiveFontSize(
        context,
        phone: DesignTokens.fontSizeXs,
        tablet: DesignTokens.fontSizeXs + 1,
        desktop: DesignTokens.fontSizeXs + 2,
      ),
      fontWeight: DesignTokens.fontWeightSemiBold,
      height: DesignTokens.lineHeightTight,
      letterSpacing: DesignTokens.letterSpacingWide,
    );
  }

  /// Tabular figures for amounts/balances
  static TextStyle tabular(BuildContext context, TextStyle base) {
    return base.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  // ── Color Variations ──────────────────────────────────────────────────────
  
  /// Primary text color
  static TextStyle primary(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Secondary text color
  static TextStyle secondary(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }

  /// Tertiary text color
  static TextStyle tertiary(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  /// Disabled text color
  static TextStyle disabled(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
    );
  }

  /// Success text color
  static TextStyle success(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  /// Error text color
  static TextStyle error(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.error,
    );
  }

  /// Warning text color
  static TextStyle warning(BuildContext context, TextStyle base) {
    return base.copyWith(
      color: Theme.of(context).colorScheme.tertiary,
    );
  }

  // ── Helper Methods ────────────────────────────────────────────────────────
  
  /// Build text style with consistent properties
  static TextStyle _buildTextStyle(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontFamilyPrimary,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Get responsive text style based on device type
  static TextStyle responsive(BuildContext context, {
    required TextStyle phone,
    TextStyle? tablet,
    TextStyle? desktop,
  }) {
    if (DesignTokens.isDesktop(context) && desktop != null) return desktop;
    if (DesignTokens.isTablet(context) && tablet != null) return tablet;
    return phone;
  }

  /// Create text style with custom properties
  static TextStyle custom(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return _buildTextStyle(
      context,
      fontSize: fontSize ?? DesignTokens.fontSizeM,
      fontWeight: fontWeight ?? DesignTokens.fontWeightNormal,
      height: height ?? DesignTokens.lineHeightNormal,
      letterSpacing: letterSpacing,
    ).copyWith(color: color);
  }
}
