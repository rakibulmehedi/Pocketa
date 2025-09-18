import 'package:flutter/material.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// Enhanced animation utilities for onboarding screens
class OnboardingAnimations {
  /// Creates a staggered fade-in animation for a list of widgets
  static Widget staggeredFadeIn({
    required List<Widget> children,
    Duration duration = const Duration(milliseconds: 600),
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = Curves.easeOut,
  }) {
    return _StaggeredFadeIn(
      duration: duration,
      staggerDelay: staggerDelay,
      curve: curve,
      children: children,
    );
  }

  /// Creates a slide-in animation from the specified direction
  static Widget slideIn({
    required Widget child,
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOut,
    bool delay = false,
  }) {
    return _SlideIn(
      begin: begin,
      end: end,
      duration: duration,
      curve: curve,
      delay: delay,
      child: child,
    );
  }

  /// Creates a scale-in animation with bounce effect
  static Widget scaleIn({
    required Widget child,
    double begin = 0.8,
    double end = 1.0,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.elasticOut,
    bool delay = false,
  }) {
    return _ScaleIn(
      begin: begin,
      end: end,
      duration: duration,
      curve: curve,
      delay: delay,
      child: child,
    );
  }

  /// Creates a pulse animation for emphasis
  static Widget pulse({
    required Widget child,
    double minScale = 0.95,
    double maxScale = 1.05,
    Duration duration = const Duration(milliseconds: 1000),
    bool repeat = true,
  }) {
    return _Pulse(
      minScale: minScale,
      maxScale: maxScale,
      duration: duration,
      repeat: repeat,
      child: child,
    );
  }

  /// Creates a shimmer effect for loading states
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _Shimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      child: child,
    );
  }
}

class _StaggeredFadeIn extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;

  const _StaggeredFadeIn({
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
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Curve curve;
  final bool delay;

  const _SlideIn({
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
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  final Curve curve;
  final bool delay;

  const _ScaleIn({
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
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;
  final bool repeat;

  const _Pulse({
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
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const _Shimmer({
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
