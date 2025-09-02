import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/db/hive_helpers.dart';

void main() {
  test('shouldCompact true when length >= threshold', () {
    expect(shouldCompact(1000, threshold: 1000), true);
    expect(shouldCompact(1001, threshold: 1000), true);
  });

  test('shouldCompact false when length < threshold', () {
    expect(shouldCompact(999, threshold: 1000), false);
  });
}

