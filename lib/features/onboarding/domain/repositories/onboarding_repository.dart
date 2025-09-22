import 'package:flow/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<OnboardingData> getOnboardingData();
  Future<void> saveOnboardingData(OnboardingData data);
  Future<void> completeOnboarding();
  Future<bool> isOnboardingCompleted();
}
