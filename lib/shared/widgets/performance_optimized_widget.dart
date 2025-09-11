import 'package:flutter/material.dart';

/// A base widget that provides performance optimizations and proper disposal patterns
/// for complex widgets that manage resources like controllers, animations, etc.
abstract class PerformanceOptimizedWidget extends StatefulWidget {
  const PerformanceOptimizedWidget({super.key});
}

/// Mixin that provides common performance optimizations and disposal patterns
mixin PerformanceOptimizedMixin<W extends StatefulWidget> on State<W> {
  final List<Disposable> _disposables = [];

  /// Register a disposable resource that will be automatically disposed
  void registerDisposable(Disposable disposable) {
    _disposables.add(disposable);
  }

  /// Register multiple disposables at once
  void registerDisposables(List<Disposable> disposables) {
    _disposables.addAll(disposables);
  }

  @override
  void dispose() {
    // Dispose all registered resources
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
    super.dispose();
  }

  /// Helper method to create a memoized value that's disposed automatically
  T createMemoized<T extends Disposable>(T Function() factory) {
    final value = factory();
    registerDisposable(value);
    return value;
  }
}

/// Interface for resources that need to be disposed
abstract class Disposable {
  void dispose();
}

/// A controller that implements Disposable for automatic cleanup
abstract class DisposableController extends Disposable {
  bool _isDisposed = false;
  
  bool get isDisposed => _isDisposed;
  
  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      onDispose();
    }
  }
  
  /// Override this method to perform cleanup
  void onDispose();
  
  /// Throws if the controller is disposed
  void throwIfDisposed() {
    if (_isDisposed) {
      throw StateError('Controller has been disposed');
    }
  }
}

/// A widget that automatically disposes its child when removed from the tree
class AutoDisposeWidget extends StatefulWidget {
  final Widget child;
  final List<Disposable>? disposables;

  const AutoDisposeWidget({
    super.key,
    required this.child,
    this.disposables,
  });

  @override
  State<AutoDisposeWidget> createState() => _AutoDisposeWidgetState();
}

class _AutoDisposeWidgetState extends State<AutoDisposeWidget> {
  @override
  void dispose() {
    widget.disposables?.forEach((disposable) => disposable.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A widget that provides performance optimizations for lists
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A widget that provides performance optimizations for grids
class OptimizedGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const OptimizedGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
