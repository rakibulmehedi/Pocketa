import 'package:intl/intl.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';

/// Format currency with symbol (default ৳)
String formatAmount(double value, {String currency = '৳'}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs().toStringAsFixed(2);
  return '$sign$currency$abs';
}

/// Pretty print category name
String prettyCategory(Category c) {
  switch (c) {
    case Category.groceries:
      return 'Groceries';
    case Category.transport:
      return 'Transport';
    case Category.rent:
      return 'Rent';
    case Category.utilities:
      return 'Utilities';
    case Category.entertainment:
      return 'Entertainment';
    case Category.eatingOut:
      return 'Eating out';
    case Category.shopping:
      return 'Shopping';
    case Category.health:
      return 'Health';
    case Category.salary:
      return 'Salary';
    case Category.freelance:
      return 'Freelance';
    case Category.investment:
      return 'Investment';
    case Category.business:
      return 'Business';
    case Category.others:
      return 'Others';
  }
}

/// Format DateTime → nice string
String formatDate(DateTime dt) {
  return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt.toLocal());
}
