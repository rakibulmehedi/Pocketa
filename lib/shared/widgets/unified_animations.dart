import 'package:flutter/material.dart';

/// Unified animation system for consistent animations across the app
class UnifiedAnimations {
  UnifiedAnimations._();

  // Duration constants
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);

  // Easing curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;

  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    bool maintainState = true,
  }) {
    return _AnimatedFadeIn(
      duration: duration,
      curve: curve,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Fade out animation
  static Widget fadeOut({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeIn,
    bool maintainState = true,
  }) {
    return _AnimatedFadeOut(
      duration: duration,
      curve: curve,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Slide in animation
  static Widget slideIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
    bool maintainState = true,
  }) {
    return _AnimatedSlideIn(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Slide out animation
  static Widget slideOut({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeIn,
    Offset begin = Offset.zero,
    Offset end = const Offset(0, 0.1),
    bool maintainState = true,
  }) {
    return _AnimatedSlideOut(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Scale in animation
  static Widget scaleIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double begin = 0.8,
    double end = 1.0,
    bool maintainState = true,
  }) {
    return _AnimatedScaleIn(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Scale out animation
  static Widget scaleOut({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeIn,
    double begin = 1.0,
    double end = 0.8,
    bool maintainState = true,
  }) {
    return _AnimatedScaleOut(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Combined fade and slide in animation
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
    bool maintainState = true,
  }) {
    return _AnimatedFadeSlideIn(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Combined fade and slide out animation
  static Widget fadeSlideOut({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeIn,
    Offset begin = Offset.zero,
    Offset end = const Offset(0, 0.1),
    bool maintainState = true,
  }) {
    return _AnimatedFadeSlideOut(
      duration: duration,
      curve: curve,
      begin: begin,
      end: end,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Stagger animation for lists
  static Widget stagger({
    required List<Widget> children,
    Duration duration = normal,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = easeOut,
    bool maintainState = true,
  }) {
    return _AnimatedStagger(
      duration: duration,
      staggerDelay: staggerDelay,
      curve: curve,
      maintainState: maintainState,
      children: children,
    );
  }

  /// Pulse animation
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
    double minScale = 0.95,
    double maxScale = 1.05,
    bool maintainState = true,
  }) {
    return _AnimatedPulse(
      duration: duration,
      curve: curve,
      minScale: minScale,
      maxScale: maxScale,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Shimmer animation for loading states
  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    Curve curve = Curves.easeInOut,
    Color? baseColor,
    Color? highlightColor,
    bool maintainState = true,
  }) {
    return _AnimatedShimmer(
      duration: duration,
      curve: curve,
      baseColor: baseColor,
      highlightColor: highlightColor,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Bounce animation
  static Widget bounce({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.elasticOut,
    double intensity = 0.1,
    bool maintainState = true,
  }) {
    return _AnimatedBounce(
      duration: duration,
      curve: curve,
      intensity: intensity,
      maintainState: maintainState,
      child: child,
    );
  }
}

// Private animation widget implementations

class _AnimatedFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool maintainState;

  const _AnimatedFadeIn({
    required this.child,
    required this.duration,
    required this.curve,
    required this.maintainState,
  });

  @override
  State<_AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<_AnimatedFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class _AnimatedFadeOut extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool maintainState;

  const _AnimatedFadeOut({
    required this.child,
    required this.duration,
    required this.curve,
    required this.maintainState,
  });

  @override
  State<_AnimatedFadeOut> createState() => _AnimatedFadeOutState();
}

class _AnimatedFadeOutState extends State<_AnimatedFadeOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class _AnimatedSlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool maintainState;

  const _AnimatedSlideIn({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedSlideIn> createState() => _AnimatedSlideInState();
}

class _AnimatedSlideInState extends State<_AnimatedSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
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

class _AnimatedSlideOut extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool maintainState;

  const _AnimatedSlideOut({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedSlideOut> createState() => _AnimatedSlideOutState();
}

class _AnimatedSlideOutState extends State<_AnimatedSlideOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
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

class _AnimatedScaleIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;
  final bool maintainState;

  const _AnimatedScaleIn({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedScaleIn> createState() => _AnimatedScaleInState();
}

class _AnimatedScaleInState extends State<_AnimatedScaleIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
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

class _AnimatedScaleOut extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;
  final bool maintainState;

  const _AnimatedScaleOut({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedScaleOut> createState() => _AnimatedScaleOutState();
}

class _AnimatedScaleOutState extends State<_AnimatedScaleOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
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

class _AnimatedFadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool maintainState;

  const _AnimatedFadeSlideIn({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedFadeSlideIn> createState() => _AnimatedFadeSlideInState();
}

class _AnimatedFadeSlideInState extends State<_AnimatedFadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _slideAnimation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class _AnimatedFadeSlideOut extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool maintainState;

  const _AnimatedFadeSlideOut({
    required this.child,
    required this.duration,
    required this.curve,
    required this.begin,
    required this.end,
    required this.maintainState,
  });

  @override
  State<_AnimatedFadeSlideOut> createState() => _AnimatedFadeSlideOutState();
}

class _AnimatedFadeSlideOutState extends State<_AnimatedFadeSlideOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _slideAnimation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class _AnimatedStagger extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;
  final bool maintainState;

  const _AnimatedStagger({
    required this.children,
    required this.duration,
    required this.staggerDelay,
    required this.curve,
    required this.maintainState,
  });

  @override
  State<_AnimatedStagger> createState() => _AnimatedStaggerState();
}

class _AnimatedStaggerState extends State<_AnimatedStagger>
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
    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
    }).toList();

    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
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
        return FadeTransition(
          opacity: _animations[index],
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(_animations[index]),
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}

class _AnimatedPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double minScale;
  final double maxScale;
  final bool maintainState;

  const _AnimatedPulse({
    required this.child,
    required this.duration,
    required this.curve,
    required this.minScale,
    required this.maxScale,
    required this.maintainState,
  });

  @override
  State<_AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<_AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.repeat(reverse: true);
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

class _AnimatedShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color? baseColor;
  final Color? highlightColor;
  final bool maintainState;

  const _AnimatedShimmer({
    required this.child,
    required this.duration,
    required this.curve,
    this.baseColor,
    this.highlightColor,
    required this.maintainState,
  });

  @override
  State<_AnimatedShimmer> createState() => _AnimatedShimmerState();
}

class _AnimatedShimmerState extends State<_AnimatedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? Colors.grey[300]!,
                widget.highlightColor ?? Colors.grey[100]!,
                widget.baseColor ?? Colors.grey[300]!,
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

class _AnimatedBounce extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double intensity;
  final bool maintainState;

  const _AnimatedBounce({
    required this.child,
    required this.duration,
    required this.curve,
    required this.intensity,
    required this.maintainState,
  });

  @override
  State<_AnimatedBounce> createState() => _AnimatedBounceState();
}

class _AnimatedBounceState extends State<_AnimatedBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.0 + widget.intensity,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.forward();
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