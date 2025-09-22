import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/analytics/analytics_service.dart';

class _FakeAnalytics implements AnalyticsService {
  final List<Map<String, dynamic>> events = [];
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    events.add({'name': name, 'params': params ?? {}});
  }
}

void main() {
  test('logs analytics events via provider', () async {
    final fake = _FakeAnalytics();
    final container = ProviderContainer(overrides: [
      analyticsProvider.overrideWithValue(fake),
    ]);

    await container.read(analyticsProvider).logEvent('dashboard_viewed');
    await container.read(analyticsProvider).logEvent('txn_added', params: {
      'amount': 123.45,
    });

    expect(fake.events.length, 2);
    expect(fake.events.first['name'], 'dashboard_viewed');
    expect(fake.events.last['name'], 'txn_added');
    expect(fake.events.last['params'], containsPair('amount', 123.45));
  });
}

