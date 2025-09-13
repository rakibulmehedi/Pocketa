import 'package:flutter/material.dart';

/// Custom page transitions for consistent navigation experience
class PageTransitions {
  /// Slide transition from right to left
  static Widget slideFromRight({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  /// Slide transition from left to right
  static Widget slideFromLeft({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  /// Slide transition from bottom to top
  static Widget slideFromBottom({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  /// Fade transition
  static Widget fade({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  /// Scale transition
  static Widget scale({
    required Widget child,
    required Animation<double> animation,
    double beginScale = 0.8,
    double endScale = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: beginScale,
        end: endScale,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  /// Combined fade and slide transition
  static Widget fadeSlide({
    required Widget child,
    required Animation<double> animation,
    Offset slideOffset = const Offset(0.0, 0.3),
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }

  /// Combined fade, slide, and scale transition
  static Widget fadeSlideScale({
    required Widget child,
    required Animation<double> animation,
    Offset slideOffset = const Offset(0.0, 0.3),
    double beginScale = 0.9,
    double endScale = 1.0,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
        )),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: beginScale,
            end: endScale,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          )),
          child: child,
        ),
      ),
    );
  }
}

/// Custom page route with enhanced transitions
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.transitionType = PageTransitionType.slideFromRight,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (transitionType) {
              case PageTransitionType.slideFromRight:
                return PageTransitions.slideFromRight(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.slideFromLeft:
                return PageTransitions.slideFromLeft(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.slideFromBottom:
                return PageTransitions.slideFromBottom(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.fade:
                return PageTransitions.fade(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.scale:
                return PageTransitions.scale(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.fadeSlide:
                return PageTransitions.fadeSlide(
                  child: child,
                  animation: animation,
                );
              case PageTransitionType.fadeSlideScale:
                return PageTransitions.fadeSlideScale(
                  child: child,
                  animation: animation,
                );
            }
          },
        );
}

/// Page transition types
enum PageTransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fade,
  scale,
  fadeSlide,
  fadeSlideScale,
}

/// Hero transition with enhanced styling
class CustomHero extends StatelessWidget {
  final String tag;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const CustomHero({
    super.key,
    required this.tag,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}

/// Shared transition widget for consistent animations
class SharedTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableFade;
  final bool enableSlide;
  final bool enableScale;
  final Offset slideOffset;

  const SharedTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.enableFade = true,
    this.enableSlide = true,
    this.enableScale = false,
    this.slideOffset = const Offset(0.0, 0.3),
  });

  @override
  State<SharedTransition> createState() => _SharedTransitionState();
}

class _SharedTransitionState extends State<SharedTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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
        curve: widget.enableFade ? widget.curve : Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.enableSlide ? widget.curve : Curves.linear,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.enableScale ? widget.curve : Curves.linear,
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
        Widget result = widget.child;

        if (widget.enableFade) {
          result = FadeTransition(
            opacity: _fadeAnimation,
            child: result,
          );
        }

        if (widget.enableSlide) {
          result = SlideTransition(
            position: _slideAnimation,
            child: result,
          );
        }

        if (widget.enableScale) {
          result = ScaleTransition(
            scale: _scaleAnimation,
            child: result,
          );
        }

        return result;
      },
    );
  }
}
