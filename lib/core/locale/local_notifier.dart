import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale_key_code';

/// Riverpod provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  /// Load saved locale (or fallback to 'en')
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
