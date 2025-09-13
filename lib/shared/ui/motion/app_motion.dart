import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui/motion.dart';

/// Consolidated motion utilities for consistent animations
/// Reduces code duplication and provides reusable animation components
class AppMotion {
  /// Create a fade slide animation with consistent timing
  static Widget fadeSlide({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 220),
    Offset offset = const Offset(0, 20),
    Curve curve = Curves.fastOutSlowIn,
  }) {
    return FadeSlide(
      child: child,
      delay: delay,
      duration: duration,
    );
  }

  /// Create a scale tap animation with consistent timing
  static Widget scaleTap({
    required Widget child,
    required VoidCallback onTap,
    Duration duration = const Duration(milliseconds: 120),
    double scale = 0.96,
    Curve curve = Curves.easeOut,
  }) {
    return ScaleTap(
      child: child,
      onTap: onTap,
      duration: duration,
    );
  }

  /// Create a staggered animation for a list of widgets
  static List<Widget> staggeredFadeSlide({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 80),
    Duration duration = const Duration(milliseconds: 220),
    Offset offset = const Offset(0, 20),
    Curve curve = Curves.fastOutSlowIn,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return fadeSlide(
        child: child,
        delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
        duration: duration,
        offset: offset,
        curve: curve,
      );
    }).toList();
  }

  /// Create a hero animation with consistent timing
  static Widget hero({
    required String tag,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.fastOutSlowIn,
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

  /// Create a page transition with consistent timing
  static Widget pageTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.fastOutSlowIn,
    Offset beginOffset = const Offset(1.0, 0.0),
    Offset endOffset = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: kAlwaysCompleteAnimation,
        curve: curve,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: kAlwaysCompleteAnimation,
          curve: curve,
        )),
        child: child,
      ),
    );
  }

  /// Create a loading animation with consistent styling
  static Widget loading({
    required BuildContext context,
    String? message,
    Color? color,
    double size = 24.0,
  }) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? theme.colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          SizedBox(height: layout.spaceM),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Create a success animation with confetti
  static Widget success({
    required BuildContext context,
    required String message,
    VoidCallback? onComplete,
  }) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: theme.colorScheme.onSecondary,
            size: 32,
          ),
        ),
        SizedBox(height: layout.spaceM),
        Text(
          message,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Create a shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return Shimmer(
      child: child,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
    );
  }

  /// Get responsive animation duration based on context
  static Duration getResponsiveDuration(BuildContext context, {
    Duration fast = const Duration(milliseconds: 150),
    Duration normal = const Duration(milliseconds: 220),
    Duration slow = const Duration(milliseconds: 320),
  }) {
    return Motion.getResponsiveDuration(context, fast: fast, normal: normal, slow: slow);
  }

  /// Check if animations should be reduced
  static bool isReduced(BuildContext context) {
    return Motion.isReduced(context);
  }
}

/// Shimmer loading effect widget
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
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
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
