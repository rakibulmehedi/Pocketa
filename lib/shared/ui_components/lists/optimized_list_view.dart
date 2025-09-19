import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Optimized list view with performance enhancements
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const OptimizedListView({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return ListView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: context.vh * 1.5,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: children[index],
        );
      },
    );
  }
}
