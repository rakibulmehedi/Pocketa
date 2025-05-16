import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/local_storage/shared_pref_service.dart';

/// ✅ PageController Provider: যেটা PageView কে নিয়ন্ত্রণ করে
final pageControllerProvider = Provider<PageController>((ref) {
  return PageController();
});

/// ✅ current page index ট্র্যাক করার জন্য StateProvider
final currentPageProvider = StateProvider<int>((ref) => 0);

/// ✅ ViewModel Provider: logic management
final onboardingViewModelProvider = Provider<OnboardingViewModel>((ref) {
  return OnboardingViewModel(ref);
});

/// ✅ ViewModel ক্লাস
class OnboardingViewModel {
  final Ref ref;
  final SharedPrefServices _storage = SharedPrefServices();

  OnboardingViewModel(this.ref);

  /// ✅ PageView যখন scroll হয় তখন এই মেথড কল হয়
  void onPageChanged(int index) {
    ref.read(currentPageProvider.notifier).state = index;
  }

  /// ✅ onboarding শেষ হলে এই method call করে:
  /// - local storage এ save করে
  /// - home screen এ নিয়ে যায়
  Future<void> completeOnboarding(BuildContext context) async {
    await SharedPrefServices.setOnboardingComplete();
    Navigator.pushReplacementNamed(context, '/home');
  }

  /// ✅ current page index getter
  int get pageIndex => ref.read(currentPageProvider);
}
