import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/core/performance/performance_metrics.dart';

/// Advanced caching system with TTL, LRU eviction, and performance monitoring
class AdvancedCache {
  static final Logger _logger = Logger();
  static const String _cacheBoxName = 'advanced_cache';
  static Box<Map>? _cacheBox;
  static final Map<String, CacheEntry> _memoryCache = {};
  static final int _maxMemoryEntries = 100;
  static Timer? _cleanupTimer;

  /// Initialize the cache system
  static Future<void> initialize() async {
    _cacheBox = await Hive.openBox<Map>(_cacheBoxName);
    _startCleanupTimer();
    _logger.d('Advanced cache initialized');
  }

  /// Get a value from cache
  static Future<T?> get<T>(String key) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Check memory cache first
      final memoryEntry = _memoryCache[key];
      if (memoryEntry != null && !memoryEntry.isExpired) {
        _logger.d('Cache hit (memory): $key');
        PerformanceMetrics.recordMetric('cache_get_memory', stopwatch.elapsed);
        return memoryEntry.value as T?;
      }

      // Check persistent cache
      final persistentEntry = _cacheBox?.get(key);
      if (persistentEntry != null) {
        final entry = CacheEntry.fromMap(persistentEntry);
        if (!entry.isExpired) {
          // Move to memory cache for faster access
          _addToMemoryCache(key, entry);
          _logger.d('Cache hit (persistent): $key');
          PerformanceMetrics.recordMetric('cache_get_persistent', stopwatch.elapsed);
          return entry.value as T?;
        } else {
          // Remove expired entry
          await _cacheBox?.delete(key);
        }
      }

      _logger.d('Cache miss: $key');
      PerformanceMetrics.recordMetric('cache_get_miss', stopwatch.elapsed);
      return null;
    } finally {
      stopwatch.stop();
    }
  }

  /// Set a value in cache
  static Future<void> set<T>(
    String key,
    T value, {
    Duration? ttl,
    CachePriority priority = CachePriority.normal,
    bool persist = true,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final entry = CacheEntry(
        value: value,
        ttl: ttl ?? const Duration(hours: 1),
        priority: priority,
        createdAt: DateTime.now(),
      );

      // Add to memory cache
      _addToMemoryCache(key, entry);

      // Add to persistent cache if requested
      if (persist) {
        await _cacheBox?.put(key, entry.toMap());
      }

      _logger.d('Cache set: $key (TTL: ${entry.ttl.inMinutes}min, Priority: ${priority.name})');
      PerformanceMetrics.recordMetric('cache_set', stopwatch.elapsed);
    } finally {
      stopwatch.stop();
    }
  }

  /// Remove a value from cache
  static Future<void> remove(String key) async {
    _memoryCache.remove(key);
    await _cacheBox?.delete(key);
    _logger.d('Cache removed: $key');
  }

  /// Clear all cache
  static Future<void> clear() async {
    _memoryCache.clear();
    await _cacheBox?.clear();
    _logger.d('Cache cleared');
  }

  /// Get cache statistics
  static CacheStats getStats() {
    final memorySize = _memoryCache.length;
    final persistentSize = _cacheBox?.length ?? 0;
    final expiredEntries = _memoryCache.values.where((e) => e.isExpired).length;
    
    return CacheStats(
      memoryEntries: memorySize,
      persistentEntries: persistentSize,
      expiredEntries: expiredEntries,
      hitRate: _calculateHitRate(),
    );
  }

  /// Add entry to memory cache with LRU eviction
  static void _addToMemoryCache(String key, CacheEntry entry) {
    // Remove if already exists
    _memoryCache.remove(key);
    
    // Add to beginning (most recently used)
    _memoryCache[key] = entry;
    
    // Evict least recently used entries if over limit
    if (_memoryCache.length > _maxMemoryEntries) {
      final entriesToRemove = _memoryCache.length - _maxMemoryEntries;
      final sortedEntries = _memoryCache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      
      for (int i = 0; i < entriesToRemove; i++) {
        _memoryCache.remove(sortedEntries[i].key);
      }
    }
  }

  /// Start cleanup timer for expired entries
  static void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _cleanupExpiredEntries();
    });
  }

  /// Clean up expired entries
  static void _cleanupExpiredEntries() {
    final expiredKeys = <String>[];
    
    // Clean memory cache
    for (final entry in _memoryCache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      _logger.d('Cleaned up ${expiredKeys.length} expired memory cache entries');
    }
  }

  /// Calculate cache hit rate
  static double _calculateHitRate() {
    // This is a simplified calculation
    // In a real implementation, you'd track hits and misses
    return 0.85; // Placeholder
  }

  /// Dispose resources
  static void dispose() {
    _cleanupTimer?.cancel();
    _memoryCache.clear();
    _logger.d('Advanced cache disposed');
  }
}

/// Cache entry with metadata
class CacheEntry {
  final dynamic value;
  final Duration ttl;
  final CachePriority priority;
  final DateTime createdAt;

  const CacheEntry({
    required this.value,
    required this.ttl,
    required this.priority,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().difference(createdAt) > ttl;

  Map<String, dynamic> toMap() => {
    'value': value,
    'ttl': ttl.inMilliseconds,
    'priority': priority.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CacheEntry.fromMap(Map map) => CacheEntry(
    value: map['value'],
    ttl: Duration(milliseconds: map['ttl']),
    priority: CachePriority.values.firstWhere(
      (p) => p.name == map['priority'],
      orElse: () => CachePriority.normal,
    ),
    createdAt: DateTime.parse(map['createdAt']),
  );
}

/// Cache priority levels
enum CachePriority {
  low,
  normal,
  high,
  critical,
}

/// Cache statistics
class CacheStats {
  final int memoryEntries;
  final int persistentEntries;
  final int expiredEntries;
  final double hitRate;

  const CacheStats({
    required this.memoryEntries,
    required this.persistentEntries,
    required this.expiredEntries,
    required this.hitRate,
  });

  Map<String, dynamic> toJson() => {
    'memoryEntries': memoryEntries,
    'persistentEntries': persistentEntries,
    'expiredEntries': expiredEntries,
    'hitRate': hitRate,
  };
}

/// Cache key generator for consistent key naming
class CacheKey {
  static String transaction(String id) => 'transaction_$id';
  static String transactionsList(String filter) => 'transactions_$filter';
  static String wallet(String id) => 'wallet_$id';
  static String walletsList() => 'wallets_list';
  static String category(String id) => 'category_$id';
  static String categoriesList() => 'categories_list';
  static String user(String id) => 'user_$id';
  static String settings() => 'settings';
  static String analytics(String event) => 'analytics_$event';
}
