import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/forms/base_form_notifier.dart';
import 'package:pocketa/core/forms/base_form_state.dart';
import 'package:pocketa/features/onboarding/data/onboarding_repo_impl.dart';
import 'package:pocketa/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:pocketa/features/onboarding/domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl();
});

/// Onboarding form state extending BaseFormState
class OnboardingFormState extends BaseFormState {
  final OnboardingData data;

  const OnboardingFormState({
    super.isLoading,
    super.isValid,
    super.error,
    super.fieldErrors,
    this.data = const OnboardingData(),
  });

  factory OnboardingFormState.initial() => const OnboardingFormState();

  @override
  OnboardingFormState copyWith({
    bool? isLoading,
    bool? isValid,
    String? error,
    Map<String, String>? fieldErrors,
    OnboardingData? data,
  }) {
    return OnboardingFormState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      data: data ?? this.data,
    );
  }

  List<Object?> get props => [isLoading, isValid, error, fieldErrors, data];
}

/// Onboarding form notifier extending BaseFormNotifier
class OnboardingFormNotifier extends BaseFormNotifier<OnboardingFormState> {
  final OnboardingRepository _repository;

  OnboardingFormNotifier(this._repository) : super(OnboardingFormState.initial()) {
    _loadOnboardingData();
  }

  @override
  OnboardingFormState updateLoadingState(OnboardingFormState state, bool loading) {
    return state.copyWith(isLoading: loading);
  }

  @override
  OnboardingFormState updateErrorState(OnboardingFormState state, String? error) {
    return state.copyWith(error: error);
  }

  @override
  OnboardingFormState updateFieldErrorState(OnboardingFormState state, String fieldName, String? error) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    if (error == null) {
      newFieldErrors.remove(fieldName);
    } else {
      newFieldErrors[fieldName] = error;
    }
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  OnboardingFormState clearErrorState(OnboardingFormState state) {
    return state.copyWith(error: null, fieldErrors: {});
  }

  @override
  OnboardingFormState clearFieldErrorState(OnboardingFormState state, String fieldName) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    newFieldErrors.remove(fieldName);
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  OnboardingFormState updateValidationState(OnboardingFormState state, bool isValid, Map<String, String> fieldErrors) {
    return state.copyWith(isValid: isValid, fieldErrors: fieldErrors);
  }

  Future<void> _loadOnboardingData() async {
    try {
      setLoading(true);
      clearErrors();
      
      final data = await _repository.getOnboardingData();
      state = state.copyWith(data: data);
      
      setLoading(false);
    } catch (e) {
      setError('Failed to load onboarding data: ${e.toString()}');
      setLoading(false);
    }
  }

  void updateLanguage(String language) {
    state = state.copyWith(
      data: state.data.copyWith(language: language),
    );
    saveProgress();
  }

  void updateIncomeType(IncomeType incomeType) {
    state = state.copyWith(
      data: state.data.copyWith(incomeType: incomeType),
    );
    saveProgress();
  }

  void updateCurrency(String currency) {
    state = state.copyWith(
      data: state.data.copyWith(currency: currency),
    );
    saveProgress();
  }

  void updateDailyReminder(bool enabled) {
    state = state.copyWith(
      data: state.data.copyWith(dailyReminder: enabled),
    );
    saveProgress();
  }

  void nextStep() {
    final currentStep = state.data.currentStep;
    if (currentStep.index < OnboardingStep.values.length - 1) {
      final nextStep = OnboardingStep.values[currentStep.index + 1];
      state = state.copyWith(
        data: state.data.copyWith(currentStep: nextStep),
      );
      saveProgress();
    }
  }

  void previousStep() {
    final currentStep = state.data.currentStep;
    if (currentStep.index > 0) {
      final previousStep = OnboardingStep.values[currentStep.index - 1];
      state = state.copyWith(
        data: state.data.copyWith(currentStep: previousStep),
      );
      saveProgress();
    }
  }

  void goToStep(OnboardingStep step) {
    state = state.copyWith(
      data: state.data.copyWith(currentStep: step),
    );
    saveProgress();
  }

  Future<void> saveProgress() async {
    try {
      await _repository.saveOnboardingData(state.data);
    } catch (e) {
      setError('Failed to save progress: ${e.toString()}');
    }
  }

  Future<void> completeOnboarding() async {
    try {
      setLoading(true);
      clearErrors();
      
      await _repository.completeOnboarding();
      state = state.copyWith(
        data: state.data.copyWith(onboardingCompleted: true),
      );
      
      setLoading(false);
    } catch (e) {
      setError('Failed to complete onboarding: ${e.toString()}');
      setLoading(false);
    }
  }
}

/// Provider for onboarding form notifier
final onboardingFormNotifierProvider = StateNotifierProvider<OnboardingFormNotifier, OnboardingFormState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingFormNotifier(repository);
});

/// Legacy provider for backward compatibility
final onboardingStateProvider = onboardingFormNotifierProvider;
