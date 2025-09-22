import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';

/// Enhanced responsive grid with performance optimizations
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;
    
    // Calculate responsive cross axis count
    final responsiveCrossAxisCount = crossAxisCount ?? _getResponsiveCrossAxisCount(device, layout);
    
    return GridView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: context.vh * 1.5,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveCrossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: _getChildAspectRatio(device),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: children[index],
        );
      },
    );
  }

  int _getResponsiveCrossAxisCount(DeviceSize device, AppSize layout) {
    switch (device) {
      case DeviceSize.phone:
        return 1;
      case DeviceSize.tablet:
        return 2;
      case DeviceSize.desktop:
        return 3;
    }
  }

  double _getChildAspectRatio(DeviceSize device) {
    switch (device) {
      case DeviceSize.phone:
        return 1.2;
      case DeviceSize.tablet:
        return 1.0;
      case DeviceSize.desktop:
        return 0.9;
    }
  }
}
