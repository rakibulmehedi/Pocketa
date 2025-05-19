import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingStateProvider =
    StateNotifierProvider.autoDispose<OnboardingStateNotifier, OnboardingState>((ref) {
      return OnboardingStateNotifier();
    });

class OnboardingState {
  final String? incomeSource;
  final String? incomeRange;
  final List<String> selectedCategories;
  final String? selectedCurrency;
  final String? selectedCurrencyIso;

  OnboardingState({
    this.incomeSource,
    this.incomeRange,
    this.selectedCategories = const [],
    this.selectedCurrency = 'BDT',
    this.selectedCurrencyIso = 'BD',
  });

  OnboardingState copyWith({
    String? incomeSource,
    String? incomeRange,
    List<String>? selectedCategories,
    String? selectedCurrency,
    String? selectedCurrencyIso,
  }) {
    return OnboardingState(
      incomeSource: incomeSource ?? this.incomeSource,
      incomeRange: incomeRange ?? this.incomeRange,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedCurrencyIso: selectedCurrencyIso ?? this.selectedCurrencyIso,
    );
  }

  bool get isIncomeSourceValid => incomeSource != null;

  bool get isIncomeRangeValid => incomeRange != null;

  bool get isCategoriesValid => selectedCategories.isNotEmpty;

  bool get isCurrencyValid => selectedCurrency != null;
}

extension OnboardingValidation on OnboardingState {
  bool isStepValid(int step) {
    return switch (step) {
      0 => isIncomeSourceValid,
      1 => isCurrencyValid,
      2 => isIncomeRangeValid,
      3 => isCategoriesValid,
      _ => false,
    };
  }
}

class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  OnboardingStateNotifier() : super(OnboardingState());

  void setIncomeSource(String? source) {
    state = state.copyWith(incomeSource: source);
  }

  void setIncomeRange(String? range) {
    state = state.copyWith(incomeRange: range);
  }

  void setCategories(List<String> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  void setCurrency(String? currency) {
    state = state.copyWith(selectedCurrency: currency);
  }
  void setCurrencyIsoCode(String isoCode) {
    state = state.copyWith(selectedCurrencyIso: isoCode);
  }


  void reset() {
    state = OnboardingState();
  }
}
