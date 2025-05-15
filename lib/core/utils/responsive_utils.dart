// lib/core/utils/responsive_utils.dart
import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Returns a scaled font size based on screen width
  static double font(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 320) return size - 2; // small phones
    if (width <= 375) return size;     // medium phones
    if (width <= 414) return size + 1; // large phones
    return size + 2;                   // tablets / desktop
  }

  /// Returns proportional width
  static double width(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.width * fraction;
  }

  /// Returns proportional height
  static double height(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.height * fraction;
  }

  /// Returns horizontal padding based on screen width
  static EdgeInsets horizontalPadding(BuildContext context, {double percent = 0.06}) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.symmetric(horizontal: width * percent);
  }

  /// Returns vertical padding based on screen height
  static EdgeInsets verticalPadding(BuildContext context, {double percent = 0.02}) {
    final height = MediaQuery.of(context).size.height;
    return EdgeInsets.symmetric(vertical: height * percent);
  }

  /// Returns EdgeInsets.all() with proportional spacing
  static EdgeInsets uniformPadding(BuildContext context, double percent) {
    final width = MediaQuery.of(context).size.width;
    return EdgeInsets.all(width * percent);
  }

  /// Returns dynamic spacing (SizedBox height)
  static SizedBox spacing(BuildContext context, {double percent = 0.02}) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(height: height * percent);
  }
}
