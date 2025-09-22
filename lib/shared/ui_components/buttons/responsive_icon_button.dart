import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui_components/performance/interactive_wrapper.dart';

/// Responsive icon button that adapts to screen size
class ResponsiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool isSelected;

  const ResponsiveIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size,
    this.padding,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    final iconSize = size ?? layout.responsiveIconSize(
      phone: 20,
      tablet: 24,
      desktop: 28,
    );
    
    final buttonPadding = padding ?? EdgeInsets.all(
      layout.responsiveSize(
        phone: 8,
        tablet: 12,
        desktop: 16,
      ),
    );

    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: color ?? (isSelected 
          ? theme.colorScheme.onPrimary 
          : theme.colorScheme.onSurface),
      ),
      tooltip: tooltip,
      padding: buttonPadding,
    );

    if (backgroundColor != null || isSelected) {
      button = Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? (isSelected 
            ? theme.colorScheme.primary 
            : theme.colorScheme.surfaceContainer),
          borderRadius: BorderRadius.circular(layout.radiusM),
          border: isSelected ? Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ) : null,
        ),
        child: button,
      );
    }

    return RepaintBoundary(
      child: InteractiveWrapper(
        onTap: onPressed,
        enableHaptic: true,
        child: button,
      ),
    );
  }
}