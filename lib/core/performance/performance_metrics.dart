/// Simple performance metrics tracking
class PerformanceMetrics {
  static final Map<String, List<Duration>> _metrics = {};

  /// Record a performance metric
  static void recordMetric(String name, Duration duration) {
    _metrics.putIfAbsent(name, () => []).add(duration);
  }

  /// Get average duration for a metric
  static Duration? getAverageDuration(String name) {
    final durations = _metrics[name];
    if (durations == null || durations.isEmpty) return null;
    
    final total = durations.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );
    
    return Duration(
      microseconds: total.inMicroseconds ~/ durations.length,
    );
  }

  /// Get all recorded metrics
  static Map<String, List<Duration>> getAllMetrics() => Map.unmodifiable(_metrics);

  /// Clear all metrics
  static void clear() => _metrics.clear();
}
