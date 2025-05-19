import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/local_storage/shared_pref_service.dart';

final pageControllerProvider = Provider.autoDispose<PageController>((ref) {
  return PageController();
});

final currentPageProvider = StateProvider.autoDispose<int>((ref) => 0);

final onboardingViewModelProvider = Provider<OnboardingViewModel>((ref) {
  return OnboardingViewModel(ref);
});

class OnboardingViewModel {
  final Ref ref;

  OnboardingViewModel(this.ref);

  void onPageChanged(int index) {
    ref.read(currentPageProvider.notifier).state = index;
  }

  Future<void> completeOnboarding(BuildContext context) async {
    await SharedPrefServices.setOnboardingComplete();
    Navigator.pushReplacementNamed(context, '/home');
  }

  int get pageIndex => ref.read(currentPageProvider);
}
