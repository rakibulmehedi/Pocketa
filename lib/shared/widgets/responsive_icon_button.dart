import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

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
    
    final buttonSize = size ?? layout.responsiveSize(
      phone: 40,
      tablet: 44,
      desktop: 48,
    );

    final iconSize = buttonSize * 0.6;

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor ?? 
               (isSelected ? theme.colorScheme.primary : Colors.transparent),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: padding ?? EdgeInsets.all(layout.spaceS),
            child: Icon(
              icon,
              size: iconSize,
              color: color ?? 
                     (isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}

/// Responsive icon button with text
class ResponsiveIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? iconSize;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final bool isSelected;

  const ResponsiveIconTextButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.iconSize,
    this.textSize,
    this.padding,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    final effectiveIconSize = iconSize ?? layout.responsiveSize(
      phone: 16,
      tablet: 18,
      desktop: 20,
    );

    final effectiveTextSize = textSize ?? layout.responsiveSize(
      phone: 12,
      tablet: 14,
      desktop: 16,
    );

    return Material(
      color: backgroundColor ?? 
             (isSelected ? theme.colorScheme.primary : Colors.transparent),
      borderRadius: BorderRadius.circular(layout.spaceM),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(layout.spaceM),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: layout.spaceM,
            vertical: layout.spaceS,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: effectiveIconSize,
                color: color ?? 
                       (isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
              ),
              SizedBox(width: layout.spaceS),
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: effectiveTextSize,
                  color: color ?? 
                         (isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
