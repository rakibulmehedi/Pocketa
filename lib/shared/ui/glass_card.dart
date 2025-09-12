import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui/motion.dart';

class GlassCard extends StatelessWidget {
  final Widget child; 
  final EdgeInsetsGeometry? padding; 
  final EdgeInsetsGeometry? margin; 
  final double? radius;
  const GlassCard({super.key, required this.child, this.padding, this.margin, this.radius});
  
  @override
  Widget build(BuildContext context) {
    final L = context.layout; 
    final cs = Theme.of(context).colorScheme;
    final cardRadius = radius ?? L.radiusL;
    
    return Container(
      margin: margin ?? EdgeInsets.all(L.spaceS),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: Motion.d220, 
            curve: Motion.easeOut,
            padding: padding ?? EdgeInsets.all(L.spaceM),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(cardRadius),
              border: Border.all(
                color: cs.onSurface.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
