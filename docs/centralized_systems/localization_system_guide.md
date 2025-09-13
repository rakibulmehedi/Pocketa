# Localization System Implementation Guide
## PocketA - Comprehensive Internationalization System

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [ARB File Structure](#arb-file-structure)
4. [Localization Provider](#localization-provider)
5. [Implementation Examples](#implementation-examples)
6. [Advanced Features](#advanced-features)
7. [RTL Support](#rtl-support)
8. [Performance Optimization](#performance-optimization)
9. [Testing Localization](#testing-localization)
10. [Migration Guide](#migration-guide)
11. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA Localization System provides comprehensive internationalization support for multiple languages, with a focus on English and Bengali. It uses Flutter's built-in localization system with ARB (Application Resource Bundle) files for easy translation management.

### Key Features
- **Multi-language Support**: English and Bengali with easy extension to other languages
- **ARB-based Translation**: Industry-standard format for translation management
- **Pluralization Support**: Proper handling of singular/plural forms
- **Parameterized Strings**: Dynamic content with placeholders
- **RTL Support**: Right-to-left language support for Arabic, Hebrew, etc.
- **State Management**: Riverpod-based locale state management with persistence
- **Performance Optimized**: Efficient loading and caching of translations

---

## 🏗️ System Architecture

### Core Components

```dart
// lib/l10n/app_localizations.dart
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());
  
  final String localeName;
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];
}
```

### Locale Provider

```dart
// lib/core/locale/local_notifier.dart
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }
  
  static const String _kLocaleKey = 'app_locale_key_code';
  
  Future<void> _loadLocale() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString(_kLocaleKey) ?? 'en';
    state = Locale(code);
  }
  
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocaleKey, locale.languageCode);
  }
  
  Future<void> toggle() async {
    final next = state.languageCode == 'en'
        ? const Locale('bn')
        : const Locale('en');
    await setLocale(next);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
```

---

## 📝 ARB File Structure

### English ARB File

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  
  "appTitle": "Pocketa",
  "tagline": "Own your money. Own your future.",
  
  "ok": "OK",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete",
  "edit": "Edit",
  "back": "Back",
  "next": "Next",
  "skip": "Skip",
  "finish": "Finish",
  
  "welcomeTitle": "Welcome to Pocketa",
  "welcomeSubtitle": "Clarity with every taka you spend.",
  "getStarted": "Let's begin",
  
  "homeGreeting": "Hi, {name}!",
  "@homeGreeting": {
    "description": "Greets the user by name on the home screen",
    "placeholders": { "name": {} }
  },
  
  "countTransactions": "{count, plural, =0 {No transactions} one {1 transaction} other {{count} transactions}}",
  "@countTransactions": {
    "description": "Pluralized count of transactions",
    "placeholders": { "count": {} }
  },
  
  "budgetLeft": "{amount} left",
  "@budgetLeft": {
    "description": "Shows remaining budget amount",
    "placeholders": { "amount": {} }
  },
  
  "errorRequired": "{field} is required",
  "@errorRequired": {
    "description": "Shown when a required field is empty",
    "placeholders": { "field": {} }
  }
}
```

### Bengali ARB File

```json
// lib/l10n/app_bn.arb
{
  "@@locale": "bn",
  
  "appTitle": "পকেটা",
  "tagline": "আপনার টাকা আপনার। আপনার ভবিষ্যত আপনার।",
  
  "ok": "ঠিক আছে",
  "cancel": "বাতিল",
  "save": "সংরক্ষণ",
  "delete": "মুছে ফেলুন",
  "edit": "সম্পাদনা",
  "back": "ফিরে যান",
  "next": "পরবর্তী",
  "skip": "এড়িয়ে যান",
  "finish": "শেষ",
  
  "welcomeTitle": "পকেটায় স্বাগতম",
  "welcomeSubtitle": "আপনার খরচ করা প্রতিটি টাকার জন্য স্পষ্টতা।",
  "getStarted": "শুরু করি",
  
  "homeGreeting": "হাই, {name}!",
  "@homeGreeting": {
    "description": "হোম স্ক্রিনে ব্যবহারকারীকে নাম দিয়ে অভিবাদন",
    "placeholders": { "name": {} }
  },
  
  "countTransactions": "{count, plural, =0 {কোন লেনদেন নেই} one {১টি লেনদেন} other {{count}টি লেনদেন}}",
  "@countTransactions": {
    "description": "লেনদেনের সংখ্যার বহুবচন",
    "placeholders": { "count": {} }
  },
  
  "budgetLeft": "{amount} বাকি",
  "@budgetLeft": {
    "description": "বাকি বাজেটের পরিমাণ দেখায়",
    "placeholders": { "amount": {} }
  },
  
  "errorRequired": "{field} প্রয়োজন",
  "@errorRequired": {
    "description": "যখন একটি প্রয়োজনীয় ক্ষেত্র খালি থাকে তখন দেখানো হয়",
    "placeholders": { "field": {} }
  }
}
```

### ARB File Best Practices

```json
{
  "@@locale": "en",
  
  // Use descriptive keys
  "onb_welcome_title": "Starting today, money is in your control.",
  "onb_welcome_subtitle": "Small expenses create big gaps—now they'll be easy to track.",
  
  // Group related keys with prefixes
  "onb_cta_continue": "Continue →",
  "onb_cta_finish": "Finish",
  "onb_cta_start": "Start →",
  
  // Use placeholders for dynamic content
  "version": "Version {version}",
  "@version": {
    "description": "App version label with version value",
    "placeholders": { "version": {} }
  },
  
  // Support pluralization
  "daysStreak": "On budget for {days, plural, one {# day} other {# days}} 🎉",
  "@daysStreak": {
    "description": "Shows user's consecutive days staying within budget",
    "placeholders": { "days": {} }
  },
  
  // Use semantic labels for accessibility
  "accessibility_welcome_illustration": "Welcome illustration",
  "@accessibility_welcome_illustration": {
    "description": "Semantic label for the welcome screen illustration used by screen readers."
  }
}
```

---

## 🔄 Localization Provider

### Provider Implementation

```dart
// lib/core/locale/local_notifier.dart
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }
  
  static const String _kLocaleKey = 'app_locale_key_code';
  
  Future<void> _loadLocale() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString(_kLocaleKey) ?? 'en';
    state = Locale(code);
  }
  
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocaleKey, locale.languageCode);
  }
  
  Future<void> toggle() async {
    final next = state.languageCode == 'en'
        ? const Locale('bn')
        : const Locale('en');
    await setLocale(next);
  }
  
  // Get current locale name for display
  String get localeName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা';
      default:
        return 'English';
    }
  }
  
  // Check if current locale is RTL
  bool get isRTL {
    return state.languageCode == 'ar' || 
           state.languageCode == 'he' || 
           state.languageCode == 'fa';
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
```

### Provider Usage

```dart
// In your main app
class PocketaApp extends ConsumerWidget {
  const PocketaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      // ... other configuration
    );
  }
}
```

---

## 🚀 Implementation Examples

### Basic String Usage

```dart
// Simple string access
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Text(l10n.welcomeTitle);
}

// With Consumer for reactive updates
class LocalizedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Text(l10n.welcomeTitle);
  }
}
```

### Parameterized Strings

```dart
// Using placeholders
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Text(l10n.homeGreeting('John'));
}

// Multiple parameters
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Text(l10n.budgetLeft('৳500'));
}
```

### Pluralization

```dart
// Pluralized strings
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final transactionCount = 5;
  
  return Text(l10n.countTransactions(transactionCount));
  // Output: "5 transactions" (EN) or "৫টি লেনদেন" (BN)
}

// Complex pluralization
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final days = 7;
  
  return Text(l10n.daysStreak(days));
  // Output: "On budget for 7 days 🎉"
}
```

### Language Toggle Widget

```dart
class LanguageToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final l10n = AppLocalizations.of(context);
    
    return PopupMenuButton<Locale>(
      onSelected: localeNotifier.setLocale,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Text('🇺🇸'),
              const SizedBox(width: 8),
              Text('English'),
              if (locale.languageCode == 'en') 
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('bn'),
          child: Row(
            children: [
              Text('🇧🇩'),
              const SizedBox(width: 8),
              Text('বাংলা'),
              if (locale.languageCode == 'bn') 
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(localeNotifier.localeName),
          const SizedBox(width: 4),
          Icon(Icons.language),
        ],
      ),
    );
  }
}
```

### Localized Form Fields

```dart
class LocalizedFormField extends StatelessWidget {
  final String fieldKey;
  final TextEditingController controller;
  final String? errorText;
  
  const LocalizedFormField({
    super.key,
    required this.fieldKey,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: _getFieldLabel(l10n, fieldKey),
        errorText: errorText != null 
            ? l10n.errorRequired(_getFieldLabel(l10n, fieldKey))
            : null,
      ),
    );
  }
  
  String _getFieldLabel(AppLocalizations l10n, String fieldKey) {
    switch (fieldKey) {
      case 'name':
        return l10n.name;
      case 'email':
        return l10n.email;
      case 'password':
        return l10n.password;
      case 'amount':
        return l10n.amount;
      case 'category':
        return l10n.category;
      default:
        return fieldKey;
    }
  }
}
```

---

## 🎨 Advanced Features

### Custom Localization Extensions

```dart
// lib/core/locale/localization_extensions.dart
extension LocalizationExtensions on AppLocalizations {
  // Get localized currency symbol
  String get currencySymbol {
    switch (localeName) {
      case 'bn':
        return '৳';
      case 'en':
      default:
        return '\$';
    }
  }
  
  // Get localized date format
  String get dateFormat {
    switch (localeName) {
      case 'bn':
        return 'dd/MM/yyyy';
      case 'en':
      default:
        return 'MM/dd/yyyy';
    }
  }
  
  // Get localized number format
  NumberFormat get numberFormat {
    switch (localeName) {
      case 'bn':
        return NumberFormat('#,##0.00', 'bn_BD');
      case 'en':
      default:
        return NumberFormat('#,##0.00', 'en_US');
    }
  }
  
  // Format currency amount
  String formatCurrency(double amount) {
    return '${currencySymbol}${numberFormat.format(amount)}';
  }
  
  // Format date
  String formatDate(DateTime date) {
    return DateFormat(dateFormat).format(date);
  }
}

// Usage
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Column(
    children: [
      Text(l10n.formatCurrency(1500.50)), // ৳1,500.50 or $1,500.50
      Text(l10n.formatDate(DateTime.now())), // 15/12/2023 or 12/15/2023
    ],
  );
}
```

### Dynamic Content Loading

```dart
// lib/core/locale/dynamic_localization.dart
class DynamicLocalization {
  static Future<Map<String, String>> loadTranslations(String locale) async {
    // Load translations from remote source
    final response = await http.get(
      Uri.parse('https://api.pocketa.com/translations/$locale.json'),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Map<String, String>.from(data);
    }
    
    // Fallback to local translations
    return _getLocalTranslations(locale);
  }
  
  static Map<String, String> _getLocalTranslations(String locale) {
    switch (locale) {
      case 'bn':
        return {
          'welcome': 'স্বাগতম',
          'dashboard': 'ড্যাশবোর্ড',
          // ... other translations
        };
      case 'en':
      default:
        return {
          'welcome': 'Welcome',
          'dashboard': 'Dashboard',
          // ... other translations
        };
    }
  }
}
```

### Context-Aware Localization

```dart
// lib/core/locale/context_localization.dart
class ContextLocalization {
  static String getGreeting(AppLocalizations l10n, DateTime now) {
    final hour = now.hour;
    
    switch (l10n.localeName) {
      case 'bn':
        if (hour < 12) return 'সুপ্রভাত';
        if (hour < 18) return 'শুভ বিকাল';
        return 'শুভ সন্ধ্যা';
      case 'en':
      default:
        if (hour < 12) return 'Good morning';
        if (hour < 18) return 'Good afternoon';
        return 'Good evening';
    }
  }
  
  static String getRelativeTime(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.thisWeek;
    } else if (difference.inDays < 30) {
      return l10n.thisMonth;
    } else {
      return l10n.lastMonth;
    }
  }
}
```

---

## 🌍 RTL Support

### RTL Configuration

```dart
// lib/core/locale/rtl_support.dart
class RTLSupport {
  static bool isRTL(Locale locale) {
    const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ku'];
    return rtlLanguages.contains(locale.languageCode);
  }
  
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }
  
  static Alignment getAlignment(Locale locale) {
    return isRTL(locale) ? Alignment.centerRight : Alignment.centerLeft;
  }
}

// RTL-aware widget
class RTLWidget extends StatelessWidget {
  final Widget child;
  
  const RTLWidget({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = RTLSupport.isRTL(locale);
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
```

### RTL Layout Examples

```dart
// RTL-aware layout
class RTLResponsiveLayout extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  
  const RTLResponsiveLayout({
    super.key,
    required this.leading,
    required this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = RTLSupport.isRTL(locale);
    
    return Row(
      children: isRTL 
          ? [trailing, leading]
          : [leading, trailing],
    );
  }
}

// RTL-aware padding
class RTLPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  
  const RTLPadding({
    super.key,
    required this.child,
    required this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = RTLSupport.isRTL(locale);
    
    return Padding(
      padding: isRTL 
          ? padding.copyWith(
              left: padding.right,
              right: padding.left,
            )
          : padding,
      child: child,
    );
  }
}
```

---

## ⚡ Performance Optimization

### Lazy Loading

```dart
// lib/core/locale/lazy_localization.dart
class LazyLocalization {
  static final Map<String, Map<String, String>> _cache = {};
  
  static Future<String> getTranslation(String key, String locale) async {
    if (!_cache.containsKey(locale)) {
      _cache[locale] = await _loadTranslations(locale);
    }
    
    return _cache[locale]![key] ?? key;
  }
  
  static Future<Map<String, String>> _loadTranslations(String locale) async {
    // Load translations asynchronously
    final translations = await rootBundle.loadString('assets/l10n/$locale.json');
    return Map<String, String>.from(json.decode(translations));
  }
  
  static void clearCache() {
    _cache.clear();
  }
}
```

### Caching Strategy

```dart
// lib/core/locale/localization_cache.dart
class LocalizationCache {
  static final Map<String, AppLocalizations> _cache = {};
  
  static AppLocalizations getLocalizations(Locale locale) {
    final key = locale.languageCode;
    
    if (!_cache.containsKey(key)) {
      _cache[key] = _createLocalizations(locale);
    }
    
    return _cache[key]!;
  }
  
  static AppLocalizations _createLocalizations(Locale locale) {
    switch (locale.languageCode) {
      case 'bn':
        return AppLocalizationsBn();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }
  
  static void preloadLocales(List<Locale> locales) {
    for (final locale in locales) {
      getLocalizations(locale);
    }
  }
}
```

---

## 🧪 Testing Localization

### Localization Test Utilities

```dart
// test/localization_test_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class LocalizationTestUtils {
  static Widget createLocalizedWidget({
    required Widget child,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
  
  static void expectLocalizedText(WidgetTester tester, String expectedText) {
    expect(find.text(expectedText), findsOneWidget);
  }
  
  static void expectLocalizedTextWithLocale(
    WidgetTester tester, 
    String expectedText, 
    Locale locale,
  ) {
    final widget = createLocalizedWidget(
      child: Text(expectedText),
      locale: locale,
    );
    
    tester.pumpWidget(widget);
    expect(find.text(expectedText), findsOneWidget);
  }
}
```

### Unit Tests

```dart
// test/localization_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/l10n/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    test('English localization loads correctly', () {
      final l10n = AppLocalizationsEn();
      
      expect(l10n.appTitle, 'Pocketa');
      expect(l10n.welcomeTitle, 'Welcome to Pocketa');
      expect(l10n.ok, 'OK');
    });
    
    test('Bengali localization loads correctly', () {
      final l10n = AppLocalizationsBn();
      
      expect(l10n.appTitle, 'পকেটা');
      expect(l10n.welcomeTitle, 'পকেটায় স্বাগতম');
      expect(l10n.ok, 'ঠিক আছে');
    });
    
    test('Parameterized strings work correctly', () {
      final l10n = AppLocalizationsEn();
      
      expect(l10n.homeGreeting('John'), 'Hi, John!');
      expect(l10n.budgetLeft('৳500'), '৳500 left');
    });
    
    test('Pluralization works correctly', () {
      final l10n = AppLocalizationsEn();
      
      expect(l10n.countTransactions(0), 'No transactions');
      expect(l10n.countTransactions(1), '1 transaction');
      expect(l10n.countTransactions(5), '5 transactions');
    });
  });
}
```

### Widget Tests

```dart
// test/localized_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/l10n/app_localizations.dart';

void main() {
  group('Localized Widget Tests', () {
    testWidgets('renders English text correctly', (tester) async {
      await tester.pumpWidget(
        LocalizationTestUtils.createLocalizedWidget(
          locale: const Locale('en'),
          child: const LocalizedWidget(),
        ),
      );
      
      expect(find.text('Welcome to Pocketa'), findsOneWidget);
    });
    
    testWidgets('renders Bengali text correctly', (tester) async {
      await tester.pumpWidget(
        LocalizationTestUtils.createLocalizedWidget(
          locale: const Locale('bn'),
          child: const LocalizedWidget(),
        ),
      );
      
      expect(find.text('পকেটায় স্বাগতম'), findsOneWidget);
    });
    
    testWidgets('language toggle works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LanguageToggleButton(),
        ),
      );
      
      // Test language toggle
      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      
      expect(find.text('English'), findsOneWidget);
      expect(find.text('বাংলা'), findsOneWidget);
    });
  });
}
```

---

## 🔄 Migration Guide

### From Hardcoded Strings to Localization

```dart
// Before - Hardcoded strings
Widget build(BuildContext context) {
  return Text('Welcome to Pocketa');
}

// After - Localized strings
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return Text(l10n.welcomeTitle);
}
```

### From Custom Localization to ARB System

```dart
// Before - Custom localization
class CustomLocalization {
  static String getString(String key, String locale) {
    final translations = {
      'en': {'welcome': 'Welcome'},
      'bn': {'welcome': 'স্বাগতম'},
    };
    return translations[locale]?[key] ?? key;
  }
}

// After - ARB system
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return Text(l10n.welcomeTitle);
}
```

### From Static to Dynamic Localization

```dart
// Before - Static locale
MaterialApp(
  locale: const Locale('en'),
  // ...
)

// After - Dynamic locale with provider
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      locale: locale,
      // ...
    );
  }
}
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_localization/
├── lib/
│   ├── localization.dart           # Main export
│   ├── app_localizations.dart     # Generated localizations
│   ├── providers/
│   │   └── locale_provider.dart   # Locale state management
│   ├── extensions/
│   │   └── localization_extensions.dart
│   └── utils/
│       ├── rtl_support.dart
│       └── localization_cache.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_bn.arb
│   └── app_ar.arb
├── test/
│   ├── localization_test.dart
│   └── localization_test_utils.dart
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_localization
description: Comprehensive localization system for Flutter applications
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  shared_preferences: ^2.2.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  generate: true
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_localization:
    git:
      url: https://github.com/your-org/pocketa_localization.git
      ref: main

// In your app
import 'package:pocketa_localization/localization.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: MyHomePage(),
    );
  }
}

// In your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Text(l10n.welcomeTitle);
  }
}
```

---

## 🎨 Advanced Usage Patterns

### Localized Date and Time

```dart
// lib/core/locale/date_time_localization.dart
class DateTimeLocalization {
  static String formatDate(DateTime date, String locale) {
    switch (locale) {
      case 'bn':
        return DateFormat('dd/MM/yyyy', 'bn_BD').format(date);
      case 'ar':
        return DateFormat('dd/MM/yyyy', 'ar_SA').format(date);
      case 'en':
      default:
        return DateFormat('MM/dd/yyyy', 'en_US').format(date);
    }
  }
  
  static String formatTime(DateTime time, String locale) {
    switch (locale) {
      case 'bn':
        return DateFormat('h:mm a', 'bn_BD').format(time);
      case 'ar':
        return DateFormat('h:mm a', 'ar_SA').format(time);
      case 'en':
      default:
        return DateFormat('h:mm a', 'en_US').format(time);
    }
  }
  
  static String getRelativeTime(DateTime date, String locale) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return _getTodayText(locale);
    } else if (difference.inDays == 1) {
      return _getYesterdayText(locale);
    } else if (difference.inDays < 7) {
      return _getThisWeekText(locale);
    } else {
      return formatDate(date, locale);
    }
  }
  
  static String _getTodayText(String locale) {
    switch (locale) {
      case 'bn': return 'আজ';
      case 'ar': return 'اليوم';
      case 'en': default: return 'Today';
    }
  }
  
  static String _getYesterdayText(String locale) {
    switch (locale) {
      case 'bn': return 'গতকাল';
      case 'ar': return 'أمس';
      case 'en': default: return 'Yesterday';
    }
  }
  
  static String _getThisWeekText(String locale) {
    switch (locale) {
      case 'bn': return 'এই সপ্তাহ';
      case 'ar': return 'هذا الأسبوع';
      case 'en': default: return 'This week';
    }
  }
}
```

### Localized Number Formatting

```dart
// lib/core/locale/number_localization.dart
class NumberLocalization {
  static NumberFormat getNumberFormat(String locale) {
    switch (locale) {
      case 'bn':
        return NumberFormat('#,##0.00', 'bn_BD');
      case 'ar':
        return NumberFormat('#,##0.00', 'ar_SA');
      case 'en':
      default:
        return NumberFormat('#,##0.00', 'en_US');
    }
  }
  
  static String formatCurrency(double amount, String locale) {
    final formatter = getNumberFormat(locale);
    final symbol = _getCurrencySymbol(locale);
    return '$symbol${formatter.format(amount)}';
  }
  
  static String _getCurrencySymbol(String locale) {
    switch (locale) {
      case 'bn': return '৳';
      case 'ar': return 'ر.س';
      case 'en': default: return '\$';
    }
  }
  
  static String formatPercentage(double value, String locale) {
    final formatter = NumberFormat.percentPattern(locale);
    return formatter.format(value);
  }
}
```

### Localized Validation Messages

```dart
// lib/core/locale/validation_localization.dart
class ValidationLocalization {
  static String getRequiredMessage(String field, String locale) {
    switch (locale) {
      case 'bn':
        return '$field প্রয়োজন';
      case 'ar':
        return '$field مطلوب';
      case 'en':
      default:
        return '$field is required';
    }
  }
  
  static String getMinLengthMessage(String field, int min, String locale) {
    switch (locale) {
      case 'bn':
        return '$field কমপক্ষে $min অক্ষর হতে হবে';
      case 'ar':
        return '$field يجب أن يكون $min أحرف على الأقل';
      case 'en':
      default:
        return '$field must be at least $min characters';
    }
  }
  
  static String getEmailMessage(String locale) {
    switch (locale) {
      case 'bn':
        return 'সঠিক ইমেইল ঠিকানা দিন';
      case 'ar':
        return 'أدخل عنوان بريد إلكتروني صحيح';
      case 'en':
      default:
        return 'Enter a valid email address';
    }
  }
}
```

---

This comprehensive localization system guide provides everything needed to implement, maintain, and extend internationalization across multiple projects. The system is designed to be scalable, performant, and easy to use while providing powerful localization capabilities.
