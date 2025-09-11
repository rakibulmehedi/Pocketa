import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_entity.freezed.dart';
part 'onboarding_entity.g.dart';

enum IncomeType { student, freelancer, family }

enum OnboardingStep { welcome, personalization, demo, trust, habit }

@freezed
class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    @Default(OnboardingStep.welcome) OnboardingStep currentStep,
    @Default('bn') String language,
    @Default(IncomeType.student) IncomeType incomeType,
    @Default('BDT') String currency,
    @Default(false) bool dailyReminder,
    @Default(false) bool onboardingCompleted,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);
}

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingData()) OnboardingData data,
    @Default(false) bool isLoading,
    String? error,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}
