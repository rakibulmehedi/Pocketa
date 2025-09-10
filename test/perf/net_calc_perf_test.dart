import 'package:flutter_test/flutter_test.dart';

class _Tx {
  final double amount;
  final int type; // 0 income, 1 expense
  final DateTime date;
  _Tx(this.amount, this.type, this.date);
}

double _netForMonth(List<_Tx> all, int year, int month) {
  final from = DateTime.utc(year, month, 1);
  final to = month == 12 ? DateTime.utc(year + 1, 1, 1) : DateTime.utc(year, month + 1, 1);
  double inc = 0, exp = 0;
  for (final t in all) {
    if (t.date.isBefore(from) || !t.date.isBefore(to)) {
      continue;
    }
    if (t.type == 0) {
      inc += t.amount;
    } else {
      exp += t.amount;
    }
  }
  return inc - exp;
}

void main() {
  test('net calculation perf baseline (10k)', () {
    final list = <_Tx>[];
    for (var i = 0; i < 10000; i++) {
      list.add(_Tx(100, i % 2, DateTime.utc(2024, (i % 12) + 1, (i % 28) + 1)));
    }

    final sw = Stopwatch()..start();
    final net = _netForMonth(list, 2024, 7);
    sw.stop();
    expect(net, isA<double>());
    // Aim for < 50ms on typical dev machines; adjust if needed.
    expect(sw.elapsedMilliseconds < 200, true);
  });
}
