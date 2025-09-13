import 'package:intl/intl.dart';

/// Format currency with symbol
String formatAmount(double value, {String currency = '৳'}) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs().toStringAsFixed(2);
  return '$sign$currency$abs';
}

/// Format DateTime → nice string
String formatDate(DateTime dt) {
  return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dt.toLocal());
}

/// Currency symbols mapping
class CurrencySymbols {
  static const Map<String, String> symbols = {
    'BDT': '৳',
    'USD': '\$',
    'EUR': '€',
    'INR': '₹',
    'GBP': '£',
    'AUD': 'A\$',
  };

  static String getSymbol(String code) {
    return symbols[code] ?? code;
  }

  static String symbol(String code) {
    return getSymbol(code);
  }

  static List<String> get list => symbols.keys.toList();
}

/// Category icon mapping
class CategoryIcons {
  static const Map<String, String> icons = {
    'food': '🍽️',
    'transport': '🚗',
    'shopping': '🛍️',
    'entertainment': '🎬',
    'health': '🏥',
    'education': '📚',
    'bills': '💳',
    'other': '📝',
  };

  static String getIcon(String category) {
    return icons[category.toLowerCase()] ?? '📝';
  }
}
