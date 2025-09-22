import 'package:hive_flutter/hive_flutter.dart';
import 'package:flow/core/db/hive_box.dart';
import 'package:flow/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:flow/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<OnboardingData> getOnboardingData() async {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    
    return OnboardingData(
      currentStep: OnboardingStep.values.firstWhere(
        (e) => e.name == prefs.get('onboarding_current_step', defaultValue: 'welcome'),
        orElse: () => OnboardingStep.welcome,
      ),
      language: prefs.get('onboarding_language', defaultValue: 'bn') as String,
      incomeType: IncomeType.values.firstWhere(
        (e) => e.name == prefs.get('onboarding_income_type', defaultValue: 'student'),
        orElse: () => IncomeType.student,
      ),
      currency: prefs.get('onboarding_currency', defaultValue: 'BDT') as String,
      dailyReminder: prefs.get('onboarding_daily_reminder', defaultValue: false) as bool,
      onboardingCompleted: prefs.get('onboarding_done', defaultValue: false) as bool,
    );
  }

  @override
  Future<void> saveOnboardingData(OnboardingData data) async {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    
    await prefs.putAll({
      'onboarding_current_step': data.currentStep.name,
      'onboarding_language': data.language,
      'onboarding_income_type': data.incomeType.name,
      'onboarding_currency': data.currency,
      'onboarding_daily_reminder': data.dailyReminder,
    });
  }

  @override
  Future<void> completeOnboarding() async {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    await prefs.put('onboarding_done', true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    return prefs.get('onboarding_done', defaultValue: false) as bool;
  }
}
