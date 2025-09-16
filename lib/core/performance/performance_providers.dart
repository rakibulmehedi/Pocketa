import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/performance/performance_utils.dart';

/// Performance monitoring providers
class PerformanceProviders {
  /// Cache provider for managing application cache
  static final cacheProvider = StateNotifierProvider<CacheNotifier, Map<String, dynamic>>(
    (ref) => CacheNotifier(),
  );

  /// Performance metrics provider
  static final metricsProvider = StateNotifierProvider<PerformanceMetricsNotifier, PerformanceMetrics>(
    (ref) => PerformanceMetricsNotifier(),
  );

  /// Widget rebuild counter provider
  static final rebuildCounterProvider = StateNotifierProvider<RebuildCounterNotifier, Map<String, int>>(
    (ref) => RebuildCounterNotifier(),
  );

  /// Memory usage provider
  static final memoryUsageProvider = StateNotifierProvider<MemoryUsageNotifier, MemoryUsage>(
    (ref) => MemoryUsageNotifier(),
  );
}

/// Cache management notifier
class CacheNotifier extends StateNotifier<Map<String, dynamic>> {
  CacheNotifier() : super({});

  void setCache(String key, dynamic value) {
    state = {...state, key: value};
  }

  T? getCache<T>(String key) {
    return state[key] as T?;
  }

  void clearCache([String? key]) {
    if (key != null) {
      final newState = Map<String, dynamic>.from(state);
      newState.remove(key);
      state = newState;
    } else {
      state = {};
    }
  }

  void clearExpiredCache(Duration ttl) {
    final now = DateTime.now();
    final newState = Map<String, dynamic>.from(state);
    
    newState.removeWhere((key, value) {
      if (value is _CachedValue) {
        return now.difference(value.timestamp) > ttl;
      }
      return false;
    });
    
    state = newState;
  }
}

/// Performance metrics notifier
class PerformanceMetricsNotifier extends StateNotifier<PerformanceMetrics> {
  PerformanceMetricsNotifier() : super(PerformanceMetrics.initial());

  void recordFrameTime(Duration frameTime) {
    state = state.copyWith(
      frameTime: frameTime,
      averageFrameTime: _calculateAverageFrameTime(frameTime),
    );
  }

  void recordMemoryUsage(int bytes) {
    state = state.copyWith(
      memoryUsage: bytes,
      peakMemoryUsage: bytes > state.peakMemoryUsage ? bytes : state.peakMemoryUsage,
    );
  }

  void recordWidgetRebuild(String widgetName) {
    state = state.copyWith(
      widgetRebuilds: state.widgetRebuilds + 1,
      widgetRebuildHistory: [
        ...state.widgetRebuildHistory,
        WidgetRebuildEvent(widgetName, DateTime.now()),
      ],
    );
  }

  Duration _calculateAverageFrameTime(Duration newFrameTime) {
    if (state.frameTimeHistory.isEmpty) {
      return newFrameTime;
    }

    final totalMicroseconds = state.frameTimeHistory
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b);
    
    return Duration(
      microseconds: totalMicroseconds ~/ state.frameTimeHistory.length,
    );
  }
}

/// Performance metrics data class
class PerformanceMetrics {
  final Duration frameTime;
  final Duration averageFrameTime;
  final int memoryUsage;
  final int peakMemoryUsage;
  final int widgetRebuilds;
  final List<Duration> frameTimeHistory;
  final List<WidgetRebuildEvent> widgetRebuildHistory;

  const PerformanceMetrics({
    required this.frameTime,
    required this.averageFrameTime,
    required this.memoryUsage,
    required this.peakMemoryUsage,
    required this.widgetRebuilds,
    required this.frameTimeHistory,
    required this.widgetRebuildHistory,
  });

  factory PerformanceMetrics.initial() {
    return const PerformanceMetrics(
      frameTime: Duration.zero,
      averageFrameTime: Duration.zero,
      memoryUsage: 0,
      peakMemoryUsage: 0,
      widgetRebuilds: 0,
      frameTimeHistory: [],
      widgetRebuildHistory: [],
    );
  }

  PerformanceMetrics copyWith({
    Duration? frameTime,
    Duration? averageFrameTime,
    int? memoryUsage,
    int? peakMemoryUsage,
    int? widgetRebuilds,
    List<Duration>? frameTimeHistory,
    List<WidgetRebuildEvent>? widgetRebuildHistory,
  }) {
    return PerformanceMetrics(
      frameTime: frameTime ?? this.frameTime,
      averageFrameTime: averageFrameTime ?? this.averageFrameTime,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      peakMemoryUsage: peakMemoryUsage ?? this.peakMemoryUsage,
      widgetRebuilds: widgetRebuilds ?? this.widgetRebuilds,
      frameTimeHistory: frameTimeHistory ?? this.frameTimeHistory,
      widgetRebuildHistory: widgetRebuildHistory ?? this.widgetRebuildHistory,
    );
  }
}

/// Widget rebuild event
class WidgetRebuildEvent {
  final String widgetName;
  final DateTime timestamp;

  const WidgetRebuildEvent(this.widgetName, this.timestamp);
}

/// Memory usage notifier
class MemoryUsageNotifier extends StateNotifier<MemoryUsage> {
  MemoryUsageNotifier() : super(MemoryUsage.initial());

  void updateMemoryUsage(int bytes) {
    state = state.copyWith(
      currentUsage: bytes,
      peakUsage: bytes > state.peakUsage ? bytes : state.peakUsage,
      lastUpdated: DateTime.now(),
    );
  }

  void recordMemoryAllocation(int bytes) {
    state = state.copyWith(
      totalAllocations: state.totalAllocations + bytes,
      allocationCount: state.allocationCount + 1,
    );
  }
}

/// Memory usage data class
class MemoryUsage {
  final int currentUsage;
  final int peakUsage;
  final int totalAllocations;
  final int allocationCount;
  final DateTime lastUpdated;

  const MemoryUsage({
    required this.currentUsage,
    required this.peakUsage,
    required this.totalAllocations,
    required this.allocationCount,
    required this.lastUpdated,
  });

  factory MemoryUsage.initial() {
    return MemoryUsage(
      currentUsage: 0,
      peakUsage: 0,
      totalAllocations: 0,
      allocationCount: 0,
      lastUpdated: DateTime.now(),
    );
  }

  MemoryUsage copyWith({
    int? currentUsage,
    int? peakUsage,
    int? totalAllocations,
    int? allocationCount,
    DateTime? lastUpdated,
  }) {
    return MemoryUsage(
      currentUsage: currentUsage ?? this.currentUsage,
      peakUsage: peakUsage ?? this.peakUsage,
      totalAllocations: totalAllocations ?? this.totalAllocations,
      allocationCount: allocationCount ?? this.allocationCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Rebuild counter notifier
class RebuildCounterNotifier extends StateNotifier<Map<String, int>> {
  RebuildCounterNotifier() : super({});

  void incrementRebuild(String widgetName) {
    state = {
      ...state,
      widgetName: (state[widgetName] ?? 0) + 1,
    };
  }

  void resetCounter([String? widgetName]) {
    if (widgetName != null) {
      state = {...state, widgetName: 0};
    } else {
      state = {};
    }
  }

  int getRebuildCount(String widgetName) {
    return state[widgetName] ?? 0;
  }
}

/// Performance monitoring widget
class PerformanceMonitor extends ConsumerWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return child;

    return _PerformanceMonitorWidget(
      child: child,
      onRebuild: (widgetName) {
        ref.read(PerformanceProviders.rebuildCounterProvider.notifier)
            .incrementRebuild(widgetName);
        ref.read(PerformanceProviders.metricsProvider.notifier)
            .recordWidgetRebuild(widgetName);
      },
    );
  }
}

class _PerformanceMonitorWidget extends StatefulWidget {
  final Widget child;
  final void Function(String) onRebuild;

  const _PerformanceMonitorWidget({
    required this.child,
    required this.onRebuild,
  });

  @override
  State<_PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<_PerformanceMonitorWidget> {
  @override
  void didUpdateWidget(_PerformanceMonitorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onRebuild('PerformanceMonitor');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
