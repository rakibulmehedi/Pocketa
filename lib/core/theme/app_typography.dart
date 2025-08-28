import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static const _fallback = ['Noto Sans Bengali', 'sans-serif'];
  static TextTheme build(Brightness brightness) {
    final base = GoogleFonts.robotoTextTheme(
      brightness == Brightness.dark
          ? ThemeData(brightness: Brightness.dark).textTheme
          : ThemeData(brightness: Brightness.light).textTheme,
    );

    TextStyle? t(
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
        letterSpacing: letterSpace ?? 0,
        fontFamilyFallback: _fallback,
      );
    }

    return base.copyWith(
      displayLarge: t(base.displayLarge, height: 1.12, letterSpace: 0),
      displayMedium: t(base.displayMedium, height: 1.14),
      displaySmall: t(base.displaySmall, height: 1.16),

      headlineLarge: t(base.headlineLarge, height: 1.18),
      headlineMedium: t(base.headlineMedium, height: 1.20, w: FontWeight.w700),
      headlineSmall: t(base.headlineSmall, height: 1.22, w: FontWeight.w700),

      titleLarge: t(base.titleLarge, height: 1.24, w: FontWeight.w700),
      titleMedium: t(base.titleMedium, height: 1.26, w: FontWeight.w600),
      titleSmall: t(base.titleSmall, height: 1.28, w: FontWeight.w600),

      labelLarge: t(
        base.labelLarge,
        height: 1.20,
        w: FontWeight.w600,
        letterSpace: 0,
      ),
      labelMedium: t(
        base.labelMedium,
        height: 1.18,
        w: FontWeight.w600,
        letterSpace: 0,
      ),
      labelSmall: t(
        base.labelSmall,
        height: 1.16,
        w: FontWeight.w600,
        letterSpace: 0,
      ),

      bodyLarge: t(base.bodyLarge, height: 1.34),
      bodyMedium: t(base.bodyMedium, height: 1.34),
      bodySmall: t(base.bodySmall, height: 1.34),
    );
  }

  /// Optional monospace for numbers if needed (e.g., finance screens)
  static TextStyle tabularNums(TextStyle base) =>
      base.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
