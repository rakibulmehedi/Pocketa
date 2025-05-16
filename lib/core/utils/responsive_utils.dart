// lib/core/utils/responsive_utils.dart
import 'package:flutter/material.dart';

/// A responsive utility class for scaling UI elements based on screen size.
class ResponsiveUtils {
  /// Returns a responsive font size based on screen width.
  static double font(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 320) return baseSize * 0.85; // small phones
    if (width <= 375) return baseSize; // standard phones
    if (width <= 414) return baseSize * 1.05; // large phones
    return baseSize * 1.15; // tablets / larger screens
  }

  /// Returns a proportional width based on screen width.
  static double width(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.width * fraction;
  }

  /// Returns a proportional height based on screen height.
  static double height(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.height * fraction;
  }

  /// Returns horizontal padding with default or custom percentage.
  static EdgeInsets horizontalPadding(
    BuildContext context, {
    double percent = 0.06,
  }) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.symmetric(horizontal: width * percent);
  }

  /// Returns vertical padding with default or custom percentage.
  static EdgeInsets verticalPadding(
    BuildContext context, {
    double percent = 0.02,
  }) {
    final height = MediaQuery.of(context).size.height;
    return EdgeInsets.symmetric(vertical: height * percent);
  }

  /// Returns symmetric padding with individual horizontal and vertical percentages.
  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0.06,
    double vertical = 0.02,
  }) {
    final size = MediaQuery.of(context).size;
    return EdgeInsets.symmetric(
      horizontal: size.width * horizontal,
      vertical: size.height * vertical,
    );
  }

  /// Returns uniform padding (EdgeInsets.all) based on screen width.
  static EdgeInsets uniformPadding(BuildContext context, double percent) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.all(width * percent);
  }

  /// Returns uniform padding with max limit to avoid overflow on large screens.
  static EdgeInsets maxPadding(
    BuildContext context, {
    double fraction = 0.06,
    double max = 32,
  }) {
    final calculated = MediaQuery.of(context).size.width * fraction;
    return EdgeInsets.all(calculated.clamp(0.0, max));
  }

  /// Returns vertical spacing SizedBox with customizable percentage.
  static SizedBox spacing(
    BuildContext context, {
    double multiplier = 1.0,
    double percent = 0.02,
  }) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(height: height * percent * multiplier);
  }

  /// Responsive divider height
  static double dividerHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height * 0.0015; // 0.15% of screen height
  }

  /// Returns adaptive radius based on width
  static double borderRadius(BuildContext context, {double base = 12.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 320) return base * 0.8;
    if (width <= 414) return base;
    return base * 1.2;
  }

  /// Returns adaptive grid cross axis count based on width
  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 320) return 1;
    if (width < 512) return 2;
    if (width < 900) return 3;
    return 2;
  }

  static double icon(BuildContext context, double base) {
    double width = MediaQuery.of(context).size.width;
    return base * (width / 375); // assuming 375px base screen
  }

}
