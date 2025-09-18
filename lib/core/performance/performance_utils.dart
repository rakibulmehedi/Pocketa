import 'dart:async';
import 'package:flutter/material.dart';

/// Consolidated performance utilities for optimizing widget rebuilds and caching
class PerformanceUtils {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, Timer> _debounceTimers = {};
  static final Map<String, Timer> _throttleTimers = {};

  /// Debounce function to limit function calls
  static void debounce(String key, Duration delay, VoidCallback callback) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  /// Throttle function to limit function calls
  static void throttle(String key, Duration delay, VoidCallback callback) {
    if (_throttleTimers.containsKey(key)) return;
    
    callback();
    _throttleTimers[key] = Timer(delay, () {
      _throttleTimers.remove(key);
    });
  }

  /// Get cached value or compute and cache
  static T getCached<T>(String key, T Function() compute, {Duration? ttl}) {
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

  /// Clear all timers and cache
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
    return AnimationController(duration: duration, vsync: vsync);
  }

  /// Create a curved animation with performance optimization
  static Animation<double> createCurvedAnimation(
    AnimationController controller,
    Curve curve,
  ) {
    return CurvedAnimation(parent: controller, curve: curve);
  }

  /// Pre-cache images for smooth animations
  static Future<void> precacheImages(BuildContext context, List<String> imageUrls) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(ImageCacheUtils.getCachedImage(url), context);
      } catch (e) {
        // Ignore precache errors
      }
    }
  }
}