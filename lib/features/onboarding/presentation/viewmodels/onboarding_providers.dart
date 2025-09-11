import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/onboarding/data/onboarding_repo_impl.dart';
import 'package:pocketa/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:pocketa/features/onboarding/domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl();
});

final onboardingStateProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repository);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingNotifier(this._repository) : super(const OnboardingState()) {
    _loadOnboardingData();
  }

  Future<void> _loadOnboardingData() async {
    try {
      state = state.copyWith(isLoading: true);
      final data = await _repository.getOnboardingData();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void updateLanguage(String language) {
    state = state.copyWith(
      data: state.data.copyWith(language: language),
    );
  }

  void updateIncomeType(IncomeType incomeType) {
    state = state.copyWith(
      data: state.data.copyWith(incomeType: incomeType),
    );
  }

  void updateCurrency(String currency) {
    state = state.copyWith(
      data: state.data.copyWith(currency: currency),
    );
  }

  void updateDailyReminder(bool enabled) {
    state = state.copyWith(
      data: state.data.copyWith(dailyReminder: enabled),
    );
  }

  void nextStep() {
    final currentStep = state.data.currentStep;
    if (currentStep.index < OnboardingStep.values.length - 1) {
      final nextStep = OnboardingStep.values[currentStep.index + 1];
      state = state.copyWith(
        data: state.data.copyWith(currentStep: nextStep),
      );
      // Save progress without blocking UI
      saveProgress().catchError((error) {
        state = state.copyWith(error: 'Failed to save progress: $error');
      });
    }
  }

  void previousStep() {
    final currentStep = state.data.currentStep;
    if (currentStep.index > 0) {
      final previousStep = OnboardingStep.values[currentStep.index - 1];
      state = state.copyWith(
        data: state.data.copyWith(currentStep: previousStep),
      );
      // Save progress without blocking UI
      saveProgress().catchError((error) {
        state = state.copyWith(error: 'Failed to save progress: $error');
      });
    }
  }

  void goToStep(OnboardingStep step) {
    state = state.copyWith(
      data: state.data.copyWith(currentStep: step),
    );
  }

  Future<void> saveProgress() async {
    try {
      state = state.copyWith(isLoading: true);
      await _repository.saveOnboardingData(state.data);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      state = state.copyWith(isLoading: true);
      await _repository.completeOnboarding();
      state = state.copyWith(
        data: state.data.copyWith(onboardingCompleted: true),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
