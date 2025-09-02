import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final analyticsProvider = Provider<AnalyticsService>((ref) {
  // Wrap debug sink with batching to reduce chatty logs / vendor writes
  final sink = DebugAnalyticsService();
  final batched = BatchingAnalyticsService(sink);
  ref.onDispose(batched.dispose);
  return batched;
});

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? params});
}

class DebugAnalyticsService implements AnalyticsService {
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    if (kDebugMode) {
      _logger.i('[ANALYTICS] $name ${params ?? {}}');
    }
  }
}

class BatchingAnalyticsService implements AnalyticsService {
  final AnalyticsService _sink;
  final int maxItems;
  final Duration maxDelay;
  final List<Map<String, dynamic>> _buffer = [];
  Timer? _timer;

  BatchingAnalyticsService(
    this._sink, {
    this.maxItems = 10,
    Duration? maxDelay,
  }) : maxDelay = maxDelay ?? const Duration(seconds: 2);

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    _buffer.add({'name': name, 'params': params ?? <String, dynamic>{}});
    if (_buffer.length >= maxItems) {
      await _flush();
      return;
    }
    _timer ??= Timer(maxDelay, () {
      _flush();
    });
  }

  Future<void> _flush() async {
    _timer?.cancel();
    _timer = null;
    if (_buffer.isEmpty) return;
    final batch = List<Map<String, dynamic>>.from(_buffer);
    _buffer.clear();
    for (final e in batch) {
      await _sink.logEvent(e['name'] as String,
          params: (e['params'] as Map<String, dynamic>));
    }
  }

  void dispose() {
    _flush();
  }
}
