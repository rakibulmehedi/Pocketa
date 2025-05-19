import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  /// Key for onboarding complete
  static const String _onboardingKey = 'onboarding_complete';

  /// Set onboarding complete
  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  /// Check if onboarding is complete
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
