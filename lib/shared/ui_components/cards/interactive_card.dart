import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flow/core/responsive/responsive.dart';

/// A reusable interactive card widget with micro-interactions
class InteractiveCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? selectedColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final bool enableHapticFeedback;
  final bool enableSound;

  const InteractiveCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.selectedColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.enableHapticFeedback = true,
    this.enableSound = false,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize color animation here instead of initState
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      end: widget.selectedColor ?? Theme.of(context).colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(InteractiveCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _handleTap() {
    if (widget.onTap != null) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: widget.animationCurve,
              padding: widget.padding ?? EdgeInsets.all(layout.spaceL),
              margin: widget.margin ?? EdgeInsets.all(layout.spaceS),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: widget.borderRadius ?? 
                    BorderRadius.circular(layout.radiusL),
                border: widget.border ?? Border.all(
                  color: widget.isSelected
                      ? (widget.selectedColor ?? theme.colorScheme.primary)
                      : theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: widget.boxShadow ?? [
                  BoxShadow(
                    color: widget.isSelected
                        ? (widget.selectedColor ?? theme.colorScheme.primary)
                            .withValues(alpha: 0.3)
                        : theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: widget.isSelected ? 12 : 6,
                    offset: Offset(0, widget.isSelected ? 6 : 3),
                  ),
                  if (widget.isSelected)
                    BoxShadow(
                      color: (widget.selectedColor ?? theme.colorScheme.primary)
                          .withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    SizedBox(height: layout.spaceS),
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: widget.isSelected
                            ? theme.colorScheme.onPrimary.withValues(alpha: 0.8)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                  SizedBox(height: layout.spaceM),
                  widget.child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
