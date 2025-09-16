import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Shared animation utilities for consistent animations across the app
class AnimationUtils {
  AnimationUtils._();

  /// Standard animation durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  /// Standard animation curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  /// Fade animation builder
  static Widget fadeIn({
    required Widget child,
    required Animation<double> animation,
    Duration delay = Duration.zero,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide animation builder
  static Widget slideIn({
    required Widget child,
    required Animation<Offset> animation,
    Duration delay = Duration.zero,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }

  /// Scale animation builder
  static Widget scaleIn({
    required Widget child,
    required Animation<double> animation,
    Duration delay = Duration.zero,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Combined fade and slide animation
  static Widget fadeSlideIn({
    required Widget child,
    required Animation<double> fadeAnimation,
    required Animation<Offset> slideAnimation,
    Duration delay = Duration.zero,
  }) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }

  /// Staggered animation for lists
  static List<AnimationController> createStaggeredControllers(
    TickerProvider vsync,
    int count, {
    Duration duration = normal,
    Duration staggerDelay = const Duration(milliseconds: 100),
  }) {
    return List.generate(count, (index) {
      return AnimationController(
        duration: duration,
        vsync: vsync,
      );
    });
  }

  /// Start staggered animations
  static Future<void> startStaggeredAnimations(
    List<AnimationController> controllers, {
    Duration staggerDelay = const Duration(milliseconds: 100),
  }) async {
    for (int i = 0; i < controllers.length; i++) {
      if (i > 0) {
        await Future.delayed(staggerDelay);
      }
      controllers[i].forward();
    }
  }
}

/// Pre-built animation widgets for common use cases
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final Curve curve;
  final double scaleValue;
  final bool enableHapticFeedback;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.duration = AnimationUtils.fast,
    this.curve = AnimationUtils.easeInOut,
    this.scaleValue = 0.95,
    this.enableHapticFeedback = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHapticFeedback) {
      // HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Animated container with smooth transitions
class AnimatedContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;

  const AnimatedContainer({
    super.key,
    required this.child,
    this.duration = AnimationUtils.normal,
    this.curve = AnimationUtils.easeInOut,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
  });

  @override
  State<AnimatedContainer> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer>
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: widget.padding,
              margin: widget.margin,
              decoration: widget.decoration,
              width: widget.width,
              height: widget.height,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Responsive animation utilities
class ResponsiveAnimationUtils {
  ResponsiveAnimationUtils._();

  /// Get responsive animation duration based on device type
  static Duration getResponsiveDuration(BuildContext context, {
    Duration phone = AnimationUtils.fast,
    Duration tablet = AnimationUtils.normal,
    Duration desktop = AnimationUtils.slow,
  }) {
    final layout = context.layout;
    if (layout.isDesktop) return desktop;
    if (layout.isTablet) return tablet;
    return phone;
  }

  /// Get responsive animation curve based on device type
  static Curve getResponsiveCurve(BuildContext context, {
    Curve phone = AnimationUtils.easeOut,
    Curve tablet = AnimationUtils.easeInOut,
    Curve desktop = AnimationUtils.easeInOut,
  }) {
    final layout = context.layout;
    if (layout.isDesktop) return desktop;
    if (layout.isTablet) return tablet;
    return phone;
  }

  /// Create responsive animation controller
  static AnimationController createResponsiveController(
    BuildContext context,
    TickerProvider vsync, {
    Duration? phone,
    Duration? tablet,
    Duration? desktop,
  }) {
    final duration = getResponsiveDuration(
      context,
      phone: phone ?? AnimationUtils.fast,
      tablet: tablet ?? AnimationUtils.normal,
      desktop: desktop ?? AnimationUtils.slow,
    );

    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }
}

/// Loading animation utilities
class LoadingAnimations {
  LoadingAnimations._();

  /// Pulsing animation for loading states
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minOpacity = 0.5,
    double maxOpacity = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: minOpacity, end: maxOpacity),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      onEnd: () {
        // Restart animation
      },
    );
  }

  /// Shimmer effect for loading states
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor ?? Colors.grey[300]!,
            highlightColor ?? Colors.grey[100]!,
            baseColor ?? Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
