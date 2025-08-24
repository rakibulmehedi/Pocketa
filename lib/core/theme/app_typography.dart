import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds a bilingual TextTheme: Roboto (primary) + Noto Sans Bengali (fallback).
class AppTypography {
  // Common fallback chain: Bengali glyphs + generic sans-serif backup.
  static const _fallback = ['Noto Sans Bengali', 'sans-serif'];

  /// Create base text theme with sensible sizes for fintech UI.
  static TextTheme build(Brightness brightness) {
    // Start from Roboto for Latin
    final base = GoogleFonts.robotoTextTheme(
      brightness == Brightness.dark
          ? ThemeData(brightness: Brightness.dark).textTheme
          : ThemeData(brightness: Brightness.light).textTheme,
    );

    // Helper to apply fallback + small tweaks for Bangla readability
    TextStyle? _t(
      TextStyle? s, {
      FontWeight? w,
      double? size,
      double? height,
      double? letterSpace,
    }) {
      if (s == null) return null;
      return s.copyWith(
        fontWeight: w ?? s.fontWeight,
        fontSize: size ?? s.fontSize,
        height: height ?? s.height ?? 1.25,
        // Bengali-তে letterSpacing বাড়ালে দেখতে খারাপ লাগে—কম/০ রাখি
        letterSpacing: letterSpace ?? 0,
        fontFamilyFallback: _fallback,
      );
    }

    return base.copyWith(
      displayLarge: _t(base.displayLarge, height: 1.12, letterSpace: 0),
      displayMedium: _t(base.displayMedium, height: 1.14),
      displaySmall: _t(base.displaySmall, height: 1.16),

      headlineLarge: _t(base.headlineLarge, height: 1.18),
      headlineMedium: _t(base.headlineMedium, height: 1.20, w: FontWeight.w700),
      headlineSmall: _t(base.headlineSmall, height: 1.22, w: FontWeight.w700),

      titleLarge: _t(base.titleLarge, height: 1.24, w: FontWeight.w700),
      titleMedium: _t(base.titleMedium, height: 1.26, w: FontWeight.w600),
      titleSmall: _t(base.titleSmall, height: 1.28, w: FontWeight.w600),

      labelLarge: _t(
        base.labelLarge,
        height: 1.20,
        w: FontWeight.w600,
        letterSpace: 0,
      ),
      labelMedium: _t(
        base.labelMedium,
        height: 1.18,
        w: FontWeight.w600,
        letterSpace: 0,
      ),
      labelSmall: _t(
        base.labelSmall,
        height: 1.16,
        w: FontWeight.w600,
        letterSpace: 0,
      ),

      bodyLarge: _t(base.bodyLarge, height: 1.34),
      bodyMedium: _t(base.bodyMedium, height: 1.34),
      bodySmall: _t(base.bodySmall, height: 1.34),
    );
  }

  /// Optional monospace for numbers if needed (e.g., finance screens)
  static TextStyle tabularNums(TextStyle base) =>
      base.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
