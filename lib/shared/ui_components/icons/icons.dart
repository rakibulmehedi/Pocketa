import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// A reusable circular icon widget with responsive sizing
class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? size;
  final Color? backgroundColor;

  const CircularIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    final iconSize = size ?? layout.responsiveIconSize(
      phone: 22,
      tablet: 28,
      desktop: 32,
    );
    
    final containerSize = layout.responsiveSize(
      phone: 4.5,
      tablet: 5.5,
      desktop: 6,
    );
    
    return SizedBox.square(
      dimension: containerSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? color.withValues(alpha: 0.12),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
