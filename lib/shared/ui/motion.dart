import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Central motion configuration and utilities
class Motion {
  // Duration constants
  static const Duration d060 = Duration(milliseconds: 60);
  static const Duration d100 = Duration(milliseconds: 100);
  static const Duration d120 = Duration(milliseconds: 120);
  static const Duration d160 = Duration(milliseconds: 160);
  static const Duration d220 = Duration(milliseconds: 220);
  static const Duration d300 = Duration(milliseconds: 300);
  static const Duration d450 = Duration(milliseconds: 450);
  static const Duration d600 = Duration(milliseconds: 600);
  static const Duration d900 = Duration(milliseconds: 900);

  // Curve constants
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elasticOut = Curves.elasticOut;

  /// Check if animations should be reduced/disabled
  static bool isReduced(BuildContext context) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  /// Get responsive duration based on context
  static Duration getResponsiveDuration(BuildContext context, {
    Duration fast = const Duration(milliseconds: 150),
    Duration normal = const Duration(milliseconds: 220),
    Duration slow = const Duration(milliseconds: 320),
  }) {
    final layout = context.layout;
    if (layout.isCompact) return fast;
    if (layout.isMobile) return normal;
    return slow;
  }

  /// Get fast duration for context
  static Duration fast(BuildContext context) {
    return getResponsiveDuration(context, 
      fast: const Duration(milliseconds: 120),
      normal: const Duration(milliseconds: 150),
      slow: const Duration(milliseconds: 180),
    );
  }

  /// Get normal duration for context
  static Duration normal(BuildContext context) {
    return getResponsiveDuration(context, 
      fast: const Duration(milliseconds: 180),
      normal: const Duration(milliseconds: 220),
      slow: const Duration(milliseconds: 260),
    );
  }

  /// Get slow duration for context
  static Duration slow(BuildContext context) {
    return getResponsiveDuration(context, 
      fast: const Duration(milliseconds: 260),
      normal: const Duration(milliseconds: 320),
      slow: const Duration(milliseconds: 380),
    );
  }
}

/// Fade and slide animation widget
class FadeSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Duration? delay;

  const FadeSlide({
    super.key,
    required this.child,
    this.duration = Motion.d300,
    this.curve = Motion.easeOut,
    this.begin = const Offset(0, 0.06),
    this.delay,
  });

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation with optional delay
    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
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
    // Respect reduced motion preference
    if (Motion.isReduced(context)) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Scale animation on tap
class ScaleTap extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Duration reverseDuration;
  final VoidCallback? onTap;
  final HapticFeedbackType? hapticType;

  const ScaleTap({
    super.key,
    required this.child,
    this.scale = 0.98,
    this.duration = Motion.d100,
    this.reverseDuration = Motion.d100,
    this.onTap,
    this.hapticType,
  });

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Motion.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (Motion.isReduced(context)) return;
    
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (Motion.isReduced(context)) {
      widget.onTap?.call();
      return;
    }

    _controller.reverse().then((_) {
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: Motion.isReduced(context) ? 1.0 : _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Haptic feedback types for celebrations
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}
