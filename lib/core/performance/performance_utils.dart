import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance utilities for optimizing widget rebuilds and caching
class PerformanceUtils {
  /// Debounce function to limit function calls
  static void debounce(
    String key,
    Duration delay,
    VoidCallback callback,
  ) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  /// Throttle function to limit function calls
  static void throttle(
    String key,
    Duration delay,
    VoidCallback callback,
  ) {
    if (_throttleTimers.containsKey(key)) return;
    
    callback();
    _throttleTimers[key] = Timer(delay, () {
      _throttleTimers.remove(key);
    });
  }

  /// Cache for expensive computations
  static final Map<String, dynamic> _cache = {};
  static final Map<String, Timer> _debounceTimers = {};
  static final Map<String, Timer> _throttleTimers = {};

  /// Get cached value or compute and cache
  static T getCached<T>(
    String key,
    T Function() compute, {
    Duration? ttl,
  }) {
    final cached = _cache[key];
    if (cached != null) {
      if (ttl == null || DateTime.now().difference(cached.timestamp) < ttl) {
        return cached.value as T;
      }
      _cache.remove(key);
    }

    final value = compute();
    _cache[key] = _CachedValue(value, DateTime.now());
    return value;
  }

  /// Clear cache
  static void clearCache([String? key]) {
    if (key != null) {
      _cache.remove(key);
    } else {
      _cache.clear();
    }
  }

  /// Clear all timers
  static void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    for (final timer in _throttleTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    _throttleTimers.clear();
    _cache.clear();
  }
}

/// Cached value wrapper
class _CachedValue {
  final dynamic value;
  final DateTime timestamp;

  _CachedValue(this.value, this.timestamp);
}

/// Performance-optimized widget that prevents unnecessary rebuilds
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final String? key;

  const OptimizedWidget({
    super.key,
    required this.child,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: key != null ? ValueKey(key) : null,
      child: child,
    );
  }
}

/// Memoized widget that caches expensive computations
class MemoizedWidget extends StatefulWidget {
  final Widget Function() builder;
  final String cacheKey;
  final Duration? ttl;

  const MemoizedWidget({
    super.key,
    required this.builder,
    required this.cacheKey,
    this.ttl,
  });

  @override
  State<MemoizedWidget> createState() => _MemoizedWidgetState();
}

class _MemoizedWidgetState extends State<MemoizedWidget> {
  Widget? _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedWidget = PerformanceUtils.getCached(
      widget.cacheKey,
      widget.builder,
      ttl: widget.ttl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _cachedWidget ?? widget.builder();
  }
}

/// Lazy loading widget for large lists
class LazyLoadingWidget extends StatefulWidget {
  final Widget Function(int index) itemBuilder;
  final int itemCount;
  final int initialLoadCount;
  final int loadMoreCount;
  final Widget? loadingWidget;
  final VoidCallback? onLoadMore;

  const LazyLoadingWidget({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.initialLoadCount = 10,
    this.loadMoreCount = 10,
    this.loadingWidget,
    this.onLoadMore,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  int _loadedCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadedCount = widget.initialLoadCount;
  }

  void _loadMore() {
    if (_isLoading || _loadedCount >= widget.itemCount) return;

    setState(() {
      _isLoading = true;
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loadedCount = (_loadedCount + widget.loadMoreCount).clamp(0, widget.itemCount);
        _isLoading = false;
      });
      widget.onLoadMore?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _loadedCount,
            itemBuilder: (context, index) => widget.itemBuilder(index),
          ),
        ),
        if (_loadedCount < widget.itemCount)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? (widget.loadingWidget ?? const CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _loadMore,
                    child: const Text('Load More'),
                  ),
          ),
      ],
    );
  }
}

/// Image caching utility
class ImageCacheUtils {
  static final Map<String, ImageProvider> _cache = {};

  static ImageProvider getCachedImage(String url) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }

    final provider = NetworkImage(url);
    _cache[url] = provider;
    return provider;
  }

  static void clearImageCache() {
    _cache.clear();
  }
}

/// Animation performance utilities
class AnimationPerformanceUtils {
  /// Create a high-performance animation controller
  static AnimationController createOptimizedController(
    TickerProvider vsync,
    Duration duration,
  ) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  /// Create a curved animation with performance optimization
  static Animation<double> createCurvedAnimation(
    AnimationController controller,
    Curve curve,
  ) {
    return CurvedAnimation(
      parent: controller,
      curve: curve,
    );
  }

  /// Pre-cache images for smooth animations
  static Future<void> precacheImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(ImageCacheUtils.getCachedImage(url), context);
      } catch (e) {
        // Ignore precache errors
      }
    }
  }
}
