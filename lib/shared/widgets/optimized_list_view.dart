import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Optimized ListView with performance enhancements
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
      cacheExtent: MediaQuery.of(context).size.height * 1.5, // Cache 1.5 screens ahead
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

/// Optimized GridView with performance enhancements
class OptimizedGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const OptimizedGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
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
    
    return GridView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: MediaQuery.of(context).size.height * 1.5, // Cache 1.5 screens ahead
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 1.0,
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
}

/// Lazy loading widget that only builds when visible
class LazyLoadingWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Widget? placeholder;

  const LazyLoadingWidget({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 100),
    this.placeholder,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return widget.placeholder ?? const SizedBox.shrink();
    }
    return widget.child;
  }
}

/// Memoized widget that caches expensive computations
class MemoizedWidget extends StatefulWidget {
  final Widget Function() builder;
  final List<dynamic> dependencies;

  const MemoizedWidget({
    super.key,
    required this.builder,
    required this.dependencies,
  });

  @override
  State<MemoizedWidget> createState() => _MemoizedWidgetState();
}

class _MemoizedWidgetState extends State<MemoizedWidget> {
  Widget? _cachedWidget;
  List<dynamic>? _lastDependencies;

  @override
  Widget build(BuildContext context) {
    if (_lastDependencies == null || 
        !_listsEqual(_lastDependencies!, widget.dependencies)) {
      _cachedWidget = widget.builder();
      _lastDependencies = List.from(widget.dependencies);
    }
    return _cachedWidget!;
  }

  bool _listsEqual(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
