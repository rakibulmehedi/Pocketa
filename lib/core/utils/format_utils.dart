import 'package:intl/intl.dart';

/// Centralized formatting utilities for PocketA
/// Consolidates all formatting functions from various utility files
class FormatUtils {
  FormatUtils._();

  // Currency formatting
  static final Map<String, NumberFormat> _currencyFormatters = {};

  /// Format currency with proper symbol and locale
  static String formatCurrency(
    double amount, {
    String currencyCode = 'BDT',
    String? locale,
  }) {
    final key = '${currencyCode}_${locale ?? 'en_US'}';
    
    if (!_currencyFormatters.containsKey(key)) {
      _currencyFormatters[key] = NumberFormat.currency(
        locale: locale ?? _getLocaleForCurrency(currencyCode),
        symbol: _getSymbolForCurrency(currencyCode),
        decimalDigits: 2,
      );
    }

    return _currencyFormatters[key]!.format(amount);
  }

  /// Format amount with BDT symbol (legacy support)
  static String formatAmount(double value, {String currency = '৳'}) {
    final sign = value < 0 ? '-' : '';
    final abs = value.abs().toStringAsFixed(2);
    return '$sign$currency$abs';
  }

  /// Get currency symbol for currency code
  static String _getSymbolForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'BDT':
        return '৳';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'INR':
        return '₹';
      case 'AUD':
        return 'A\$';
      case 'JPY':
        return '¥';
      default:
        return currencyCode;
    }
  }

  /// Get list of supported currency codes
  static const List<String> supportedCurrencies = ['BDT', 'USD', 'EUR', 'INR', 'GBP', 'AUD'];

  /// Get currency symbol (for backward compatibility)
  static String getCurrencySymbol(String currencyCode) {
    return _getSymbolForCurrency(currencyCode);
  }

  /// Get locale for currency code
  static String _getLocaleForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'BDT':
        return 'bn_BD';
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'en_GB';
      case 'GBP':
        return 'en_GB';
      case 'JPY':
        return 'ja_JP';
      default:
        return 'en_US';
    }
  }

  // Date formatting
  static final Map<String, DateFormat> _dateFormatters = {};

  /// Format date with custom pattern
  static String formatDate(
    DateTime date, {
    String pattern = 'EEE, dd MMM yyyy • hh:mm a',
    String? locale,
  }) {
    final key = '${pattern}_${locale ?? 'en_US'}';
    
    if (!_dateFormatters.containsKey(key)) {
      _dateFormatters[key] = DateFormat(pattern, locale);
    }

    return _dateFormatters[key]!.format(date.toLocal());
  }

  /// Format date for display (legacy support)
  static String formatDateDisplay(DateTime dt) {
    return formatDate(dt);
  }

  /// Format date for short display
  static String formatDateShort(DateTime date) {
    return formatDate(date, pattern: 'dd MMM yyyy');
  }

  /// Format date for time only
  static String formatTime(DateTime date) {
    return formatDate(date, pattern: 'hh:mm a');
  }

  /// Format date for relative time (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDateShort(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Number formatting
  static final Map<String, NumberFormat> _numberFormatters = {};

  /// Format number with custom pattern
  static String formatNumber(
    double number, {
    int decimalDigits = 2,
    String? locale,
  }) {
    final key = '${decimalDigits}_${locale ?? 'en_US'}';
    
    if (!_numberFormatters.containsKey(key)) {
      _numberFormatters[key] = NumberFormat.decimalPattern(locale)
        ..minimumFractionDigits = decimalDigits
        ..maximumFractionDigits = decimalDigits;
    }

    return _numberFormatters[key]!.format(number);
  }

  /// Format percentage
  static String formatPercentage(
    double value, {
    int decimalDigits = 1,
  }) {
    final formatter = NumberFormat.percentPattern()
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    
    return formatter.format(value / 100);
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactNumber(double number) {
    if (number.abs() >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number.abs() >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number.abs() >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  // Text formatting
  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length == 11 && digits.startsWith('01')) {
      // Bangladeshi mobile number format: +880 1XXX-XXXXXX
      return '+880 ${digits.substring(1, 5)}-${digits.substring(5)}';
    } else if (digits.length == 10) {
      // US format: (XXX) XXX-XXXX
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    
    return phoneNumber; // Return original if format not recognized
  }

  // Validation helpers
  /// Check if string is valid email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Check if string is valid phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 && digits.length <= 15;
  }

  /// Check if string is valid currency amount
  static bool isValidCurrencyAmount(String amount) {
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    return regex.hasMatch(amount);
  }

  // Clear all cached formatters (useful for testing)
  static void clearCache() {
    _currencyFormatters.clear();
    _dateFormatters.clear();
    _numberFormatters.clear();
  }
}
