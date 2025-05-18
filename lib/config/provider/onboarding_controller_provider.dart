import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingControllerProvider =
    StateNotifierProvider.autoDispose<OnboardingController, int>((ref) {
      return OnboardingController();
    });

class OnboardingController extends StateNotifier<int> {
  OnboardingController() : super(0); // initial page index 0 (step 1)

  void nextStep() {
    if (state < 3) state++;
  }

  void setStep(int step) {
    state = step;
  }

  void previousStep() {
    if (state > 0) state--;
  }

  void skipToEnd() {
    state = 3;
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 3) state = step;
  }
}
