import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';

class _Sink implements AnalyticsService {
  final events = <Map<String, dynamic>>[];
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    events.add({'name': name, 'params': params ?? {}});
  }
}

void main() {
  test('BatchingAnalyticsService flushes by size', () async {
    final sink = _Sink();
    final batched = BatchingAnalyticsService(sink, maxItems: 3);

    await batched.logEvent('a');
    await batched.logEvent('b');
    expect(sink.events, isEmpty);
    await batched.logEvent('c'); // triggers flush

    // give microtask queue a moment
    await Future<void>.delayed(Duration(milliseconds: 10));
    expect(sink.events.map((e) => e['name']).toList(), ['a', 'b', 'c']);
  });

  test('BatchingAnalyticsService flushes by time', () async {
    final sink = _Sink();
    final batched =
        BatchingAnalyticsService(sink, maxItems: 10, maxDelay: Duration(milliseconds: 50));

    await batched.logEvent('x');
    await batched.logEvent('y');
    // wait for timer
    await Future<void>.delayed(Duration(milliseconds: 80));
    expect(sink.events.map((e) => e['name']).toList(), ['x', 'y']);
  });
}

