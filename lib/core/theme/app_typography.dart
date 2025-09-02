import 'dart:ui';
import 'package:flutter/material.dart';

/// Pocketa Typography — local assets only
/// Primary: Inter (EN + numbers), Fallback: HindSiliguri (bn), NotoSans (universal)
class AppTypography {
  static const String _primary = 'Inter';
  static const List<String> _fallback = ['HindSiliguri', 'NotoSans'];

  /// Base sizes & heights tuned for finance UI (dense but readable)
  static TextTheme build(Brightness brightness) {
    final base = ThemeData(brightness: brightness).textTheme;

    TextStyle t(
      TextStyle? s, {
      FontWeight? w,
      double? size,
      double? height,
      double? letterSpace,
    }) {
      final x = (s ?? const TextStyle());
      return x.copyWith(
        fontFamily: _primary,
        fontFamilyFallback: _fallback,
        fontWeight: w ?? x.fontWeight,
        fontSize: size ?? x.fontSize,
        height: height ?? x.height ?? 1.25,
        letterSpacing: letterSpace ?? 0,
      );
    }

    return TextTheme(
      // Display / Headlines
      displayLarge: t(base.displayLarge,
          height: 1.12, letterSpace: 0, w: FontWeight.w700),
      displayMedium: t(base.displayMedium, height: 1.14, letterSpace: 0),
      displaySmall: t(base.displaySmall, height: 1.16, letterSpace: 0),

      headlineLarge: t(base.headlineLarge, height: 1.18, w: FontWeight.w700),
      headlineMedium: t(base.headlineMedium, height: 1.20, w: FontWeight.w700),
      headlineSmall: t(base.headlineSmall, height: 1.22, w: FontWeight.w700),

      // Titles
      titleLarge: t(base.titleLarge, height: 1.24, w: FontWeight.w700),
      titleMedium: t(base.titleMedium, height: 1.26, w: FontWeight.w600),
      titleSmall: t(base.titleSmall, height: 1.28, w: FontWeight.w600),

      // Labels (buttons, chips)
      labelLarge:
          t(base.labelLarge, height: 1.20, w: FontWeight.w600, letterSpace: 0),
      labelMedium:
          t(base.labelMedium, height: 1.18, w: FontWeight.w600, letterSpace: 0),
      labelSmall:
          t(base.labelSmall, height: 1.16, w: FontWeight.w600, letterSpace: 0),

      // Body
      bodyLarge: t(base.bodyLarge, height: 1.36),
      bodyMedium: t(base.bodyMedium, height: 1.36),
      bodySmall: t(base.bodySmall, height: 1.36),
    );
  }

  /// Tabular figures for amounts/balances.
  static TextStyle tabular(TextStyle base) =>
      base.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
