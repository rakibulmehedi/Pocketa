// ──────────────────────────────────────────────────────────────────────────────
// Pocketa Responsive Animations — Device-aware animation utilities
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Responsive animation utilities that adapt to device size
class ResponsiveAnimations {
  /// Get responsive animation duration based on device size
  static Duration getDuration(BuildContext context, {
    Duration? fast,
    Duration? normal,
    Duration? slow,
  }) {
    final device = context.device;
    
    switch (device) {
      case DeviceSize.phone:
        return fast ?? const Duration(milliseconds: 200);
      case DeviceSize.tablet:
        return normal ?? const Duration(milliseconds: 300);
      case DeviceSize.desktop:
        return slow ?? const Duration(milliseconds: 400);
    }
  }

  /// Get responsive curve based on device size
  static Curve getCurve(BuildContext context, {
    Curve? phone,
    Curve? tablet,
    Curve? desktop,
  }) {
    final device = context.device;
    
    switch (device) {
      case DeviceSize.phone:
        return phone ?? Curves.easeInOut;
      case DeviceSize.tablet:
        return tablet ?? Curves.easeInOutCubic;
      case DeviceSize.desktop:
        return desktop ?? Curves.easeInOutCubic;
    }
  }

  /// Get responsive animation scale based on device size
  static double getScale(BuildContext context, {
    double? phone,
    double? tablet,
    double? desktop,
  }) {
    final device = context.device;
    
    switch (device) {
      case DeviceSize.phone:
        return phone ?? 1.0;
      case DeviceSize.tablet:
        return tablet ?? 1.1;
      case DeviceSize.desktop:
        return desktop ?? 1.2;
    }
  }

  /// Create a responsive fade transition
  static Widget fadeTransition({
    required BuildContext context,
    required Widget child,
    required Animation<double> animation,
    Duration? duration,
    Curve? curve,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Create a responsive scale transition
  static Widget scaleTransition({
    required BuildContext context,
    required Widget child,
    required Animation<double> animation,
    Duration? duration,
    Curve? curve,
  }) {
    final scale = getScale(context);
    
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: scale,
      ).animate(animation),
      child: child,
    );
  }

  /// Create a responsive slide transition
  static Widget slideTransition({
    required BuildContext context,
    required Widget child,
    required Animation<Offset> animation,
    Duration? duration,
    Curve? curve,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }

  /// Create a responsive rotation transition
  static Widget rotationTransition({
    required BuildContext context,
    required Widget child,
    required Animation<double> animation,
    Duration? duration,
    Curve? curve,
  }) {
    return RotationTransition(
      turns: animation,
      child: child,
    );
  }

  /// Create a responsive size transition
  static Widget sizeTransition({
    required BuildContext context,
    required Widget child,
    required Animation<double> animation,
    Duration? duration,
    Curve? curve,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      child: child,
    );
  }

  /// Create a responsive animated container
  static Widget animatedContainer({
    required BuildContext context,
    required Widget child,
    Duration? duration,
    Curve? curve,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxDecoration? decoration,
  }) {
    return AnimatedContainer(
      duration: getDuration(context, normal: duration),
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }

  /// Create a responsive animated opacity
  static Widget animatedOpacity({
    required BuildContext context,
    required Widget child,
    required double opacity,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: getDuration(context, normal: duration),
      child: child,
    );
  }

  /// Create a responsive animated position
  static Widget animatedPositioned({
    required BuildContext context,
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return AnimatedPositioned(
      duration: getDuration(context, normal: duration),
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Create a responsive staggered animation
  static List<AnimationController> createStaggeredControllers({
    required TickerProvider vsync,
    required int count,
    Duration? baseDuration,
  }) {
    final controllers = <AnimationController>[];
    final base = baseDuration ?? const Duration(milliseconds: 300);
    
    for (int i = 0; i < count; i++) {
      controllers.add(
        AnimationController(
          duration: Duration(
            milliseconds: base.inMilliseconds + (i * 100),
          ),
          vsync: vsync,
        ),
      );
    }
    
    return controllers;
  }

  /// Create a responsive hero animation
  static Widget hero({
    required BuildContext context,
    required String tag,
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return Hero(
      tag: tag,
      child: child,
      flightShuttleBuilder: (context, animation, direction, fromContext, toContext) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Create a responsive page route transition
  static PageRouteBuilder createPageRoute({
    required BuildContext context,
    required Widget page,
    Duration? duration,
    Curve? curve,
    String? routeName,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: getDuration(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        
        return FadeTransition(
          opacity: tween,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          ),
        );
      },
    );
  }
}

/// Extension on BuildContext for easy access to responsive animations
extension ResponsiveAnimationsExtension on BuildContext {
  /// Get responsive animation duration
  Duration responsiveDuration({
    Duration? fast,
    Duration? normal,
    Duration? slow,
  }) => ResponsiveAnimations.getDuration(this, fast: fast, normal: normal, slow: slow);

  /// Get responsive animation curve
  Curve responsiveCurve({
    Curve? phone,
    Curve? tablet,
    Curve? desktop,
  }) => ResponsiveAnimations.getCurve(this, phone: phone, tablet: tablet, desktop: desktop);

  /// Get responsive animation scale
  double responsiveScale({
    double? phone,
    double? tablet,
    double? desktop,
  }) => ResponsiveAnimations.getScale(this, phone: phone, tablet: tablet, desktop: desktop);
}
