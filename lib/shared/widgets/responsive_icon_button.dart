import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// Responsive icon button that adapts to different screen sizes
class ResponsiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const ResponsiveIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    final iconSize = size ?? layout.responsiveIconSize(
      phone: 20,
      tablet: 22,
      desktop: 24,
    );

    final buttonPadding = padding ?? EdgeInsets.all(
      layout.responsiveSize(
        phone: 8,
        tablet: 10,
        desktop: 12,
      ),
    );

    return IconButton(
      icon: Icon(
        icon,
        size: iconSize,
        color: color ?? AppColors.textPrimary(context),
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: buttonPadding,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: color ?? AppColors.textPrimary(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radiusM),
        ),
      ),
    );
  }
}