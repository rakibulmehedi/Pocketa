// ──────────────────────────────────────────────────────────────────────────────
// Pocketa Responsive Animations — Device-aware animation utilities
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/core/theme/app_colors.dart';

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

  /// Create a responsive staggered fade-in animation for a list of widgets
  static Widget staggeredFadeIn({
    required BuildContext context,
    required List<Widget> children,
    Duration? duration,
    Duration? staggerDelay,
    Curve? curve,
  }) {
    return _StaggeredFadeIn(
      context: context,
      children: children,
      duration: duration ?? getDuration(context, normal: const Duration(milliseconds: 600)),
      staggerDelay: staggerDelay ?? const Duration(milliseconds: 100),
      curve: curve ?? getCurve(context),
    );
  }

  /// Create a responsive slide-in animation from the specified direction
  static Widget slideIn({
    required BuildContext context,
    required Widget child,
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
    Duration? duration,
    Curve? curve,
    bool delay = false,
  }) {
    return _SlideIn(
      context: context,
      begin: begin,
      end: end,
      duration: duration ?? getDuration(context, normal: const Duration(milliseconds: 600)),
      curve: curve ?? getCurve(context),
      delay: delay,
      child: child,
    );
  }

  /// Create a responsive scale-in animation with bounce effect
  static Widget scaleIn({
    required BuildContext context,
    required Widget child,
    double begin = 0.8,
    double end = 1.0,
    Duration? duration,
    Curve? curve,
    bool delay = false,
  }) {
    return _ScaleIn(
      context: context,
      begin: begin,
      end: end,
      duration: duration ?? getDuration(context, normal: const Duration(milliseconds: 500)),
      curve: curve ?? Curves.elasticOut,
      delay: delay,
      child: child,
    );
  }

  /// Create a responsive pulse animation for emphasis
  static Widget pulse({
    required BuildContext context,
    required Widget child,
    double minScale = 0.95,
    double maxScale = 1.05,
    Duration? duration,
    bool repeat = true,
  }) {
    return _Pulse(
      context: context,
      minScale: minScale,
      maxScale: maxScale,
      duration: duration ?? getDuration(context, normal: const Duration(milliseconds: 1000)),
      repeat: repeat,
      child: child,
    );
  }

  /// Create a responsive shimmer effect for loading states
  static Widget shimmer({
    required BuildContext context,
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration? duration,
  }) {
    return _Shimmer(
      context: context,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration ?? getDuration(context, normal: const Duration(milliseconds: 1500)),
      child: child,
    );
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

// Private widget implementations for advanced animations

class _StaggeredFadeIn extends StatefulWidget {
  final BuildContext context;
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;

  const _StaggeredFadeIn({
    required this.context,
    required this.children,
    required this.duration,
    required this.staggerDelay,
    required this.curve,
  });

  @override
  State<_StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<_StaggeredFadeIn>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );
    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: controller, curve: widget.curve)))
        .toList();

    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[index].value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _animations[index].value)),
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}

class _SlideIn extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Curve curve;
  final bool delay;

  const _SlideIn({
    required this.context,
    required this.child,
    required this.begin,
    required this.end,
    required this.duration,
    required this.curve,
    required this.delay,
  });

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<Offset>(begin: widget.begin, end: widget.end)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class _ScaleIn extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  final Curve curve;
  final bool delay;

  const _ScaleIn({
    required this.context,
    required this.child,
    required this.begin,
    required this.end,
    required this.duration,
    required this.curve,
    required this.delay,
  });

  @override
  State<_ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<_ScaleIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.begin, end: widget.end)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class _Pulse extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;
  final bool repeat;

  const _Pulse({
    required this.context,
    required this.child,
    required this.minScale,
    required this.maxScale,
    required this.duration,
    required this.repeat,
  });

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _Shimmer extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const _Shimmer({
    required this.context,
    required this.child,
    this.baseColor,
    this.highlightColor,
    required this.duration,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.outline(context).withValues(alpha: 0.3);
    final highlightColor = widget.highlightColor ?? AppColors.outline(context).withValues(alpha: 0.6);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
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
