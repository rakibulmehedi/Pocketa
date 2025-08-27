class AppCurrencies {
  static const List<String> list = ['BDT', 'USD', 'EUR', 'INR', 'GBP', 'AUD'];
  static String symbol(String code) {
    switch (code) {
      case 'BDT':
        return '৳';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'INR':
        return '₹';
      case 'GBP':
        return '£';
      case 'AUD':
        return 'A\$';
      default:
        return code;
    }
  }
}
