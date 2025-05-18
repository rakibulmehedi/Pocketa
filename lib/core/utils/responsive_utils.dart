// lib/core/utils/responsive_utils.dart
import 'package:flutter/material.dart';

/// A responsive utility class for scaling UI elements based on screen size
/// across phones, tablets, laptops, and desktops using Material Design
/// breakpoints and principles.
class ResponsiveUtils {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Responsive font size based on width
  static double font(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < 360) return baseSize * 0.85;
    if (width < 480) return baseSize;
    if (width < 720) return baseSize * 1.1;
    if (width < 1024) return baseSize * 1.2;
    return baseSize * 1.3;
  }

  static double width(BuildContext context, double fraction) =>
      screenWidth(context) * fraction;

  static double height(BuildContext context, double fraction) =>
      screenHeight(context) * fraction;

  static EdgeInsets horizontalPadding(
    BuildContext context, {
    double percent = 0.06,
  }) {
    return EdgeInsets.symmetric(horizontal: width(context, percent));
  }

  static EdgeInsets verticalPadding(
    BuildContext context, {
    double percent = 0.02,
  }) {
    return EdgeInsets.symmetric(vertical: height(context, percent));
  }

  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0.06,
    double vertical = 0.02,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(context, horizontal),
      vertical: height(context, vertical),
    );
  }

  static EdgeInsets uniformPadding(BuildContext context, double percent) {
    return EdgeInsets.all(width(context, percent));
  }

  static EdgeInsets maxPadding(
    BuildContext context, {
    double fraction = 0.06,
    double max = 32,
  }) {
    final calculated = width(context, fraction);
    return EdgeInsets.all(calculated.clamp(0.0, max));
  }

  static SizedBox spacing(
    BuildContext context, {
    double multiplier = 1.0,
    double percent = 0.02,
  }) {
    return SizedBox(height: height(context, percent * multiplier));
  }

  static double dividerHeight(BuildContext context) => height(context, 0.0015);

  static double borderRadius(BuildContext context, {double base = 12.0}) {
    final width = screenWidth(context);
    if (width < 360) return base * 0.8;
    if (width < 720) return base;
    if (width < 1024) return base * 1.2;
    return base * 1.4;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final width = screenWidth(context);
    if (width < 320) return 1; // phones
    if (width < 720) return 2; // tablets portrait
    if (width < 1024) return 3; // tablets landscape
    if (width < 1440) return 4; // laptops
    return 5; // desktops
  }

  static double gridAxisSpacing(BuildContext context) {
    final width = screenWidth(context);
    if (width < 480) return 12;
    if (width < 720) return 16;
    if (width < 1024) return 24;
    if (width < 1440) return 32;
    return 40;
  }

  static double gridChildAspectRatio(BuildContext context) {
    final width = screenWidth(context);
    if (width < 320) return 1.3;
    if (width < 420) return 1.1;
    if (width < 720) return 1.2;
    if (width < 1024) return 1.0;
    if (width < 1440) return 0.85;
    return 0.75;
  }

  static double icon(BuildContext context, double base) {
    return base * (screenWidth(context) / 375);
  }
}
