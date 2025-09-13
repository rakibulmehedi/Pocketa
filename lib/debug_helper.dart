import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';

/// Debug helper to clear onboarding flag
class DebugHelper {
  static void clearOnboardingFlag() {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    prefs.put('onboarding_done', false);
    print('✅ Onboarding flag cleared. Restart the app to see onboarding flow.');
  }
  
  static void setOnboardingFlag() {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    prefs.put('onboarding_done', true);
    print('✅ Onboarding flag set. App will go to dashboard.');
  }
  
  static bool isOnboardingDone() {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    return prefs.get('onboarding_done') == true;
  }
}
