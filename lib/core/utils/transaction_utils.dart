import 'package:intl/intl.dart';

/// Format currency with symbol (default ৳)
String formatAmount(double value, {String currency = '৳'}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs().toStringAsFixed(2);
  return '$sign$currency$abs';
}

/// Format DateTime → nice string
String formatDate(DateTime dt) {
  return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt.toLocal());
}
