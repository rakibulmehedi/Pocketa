import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/onboarding/view/income_source_selection_screen.dart';
import 'package:pocketa/features/onboarding/view/widget/onboarding_bottom_nav.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../config/provider/theme_provider.dart';
import '../../../core/component/app_header.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/app_bar.dart';
import '../controller/onboarding_controller.dart';
import '../data/onboarding_content.dart';
import '../view_model/onboarding_view_model.dart';

/// ✅ PageView + Dots + CTA Button
/// ✅ Skip Button
/// ✅ Controller Provider
/// ✅ ViewModel Provider
/// ✅ StateProvider
/// ✅ ConsumerWidget

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ✅ Providers
    final controller = ref.watch(pageControllerProvider);
    final viewModel = ref.watch(onboardingViewModelProvider);
    final currentIndex = ref.watch(currentPageProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final selectedIncomeSource = ref.watch(selectedIncomeSourceProvider);
    final currentStep = ref.watch(onboardingControllerProvider);

    final isLast = currentIndex == onboardingContent.length - 1;
    final isValid = selectedIncomeSource != null;

    Map<String, String> headerText() {
      switch (currentIndex) {
        case 0:
          return {
            'title': context.l10n.onboardingStep1,
            'subtitle': context.l10n.whatIsYourMainIncomeSource,
          };
        case 1:
          return {
            'title': context.l10n.onboardingStep2,
            'subtitle': context.l10n.selectMonthlyIncome,
          };
        case 2:
          return {
            'title': context.l10n.onboardingStep3,
            'subtitle': context.l10n.setupYourBudgetCategories,
          };
        default:
          return {'title': '', 'subtitle': ''};
      }
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      /// ✅ Custom AppBar
      appBar: AppAppBar(
        showBackButton: true,
        onBack: () {
          if (currentIndex > 0) {
            controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            ref.read(onboardingControllerProvider.notifier).previousStep();
          } else {
            Navigator.pop(context);
          }
        },
      ),

      /// ✅ Bottom Navigation Bar
      bottomNavigationBar: OnboardingBottomNav(
        isLast,
        isValid,
        selectedIncomeSource,
        currentIndex,
      ),

      /// ✅ Main Content: PageView + Dots + CTA Button
      body: Column(
        children: [
          Padding(
            padding: ResponsiveUtils.horizontalPadding(context),
            child: AppHeader(
              title: headerText()['title']!,
              subtitle: headerText()['subtitle']!,
              step: currentStep + 1,
              totalSteps: 3,
            ),
          ),
          Expanded(child: _buildPageView(controller, viewModel, ref)),

          /// 🔹 Dot Indicator: কোন পেজে আছো তা দেখায়
          _buildDotIndicatorRow(currentIndex),
        ],
      ),
    );
  }

  Row _buildDotIndicatorRow(int currentIndex) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            onboardingContent.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(4),
              height: 8,
              width: currentIndex == index ? 24 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? AppColors.primary : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
  }

  PageView _buildPageView(
    PageController controller,
    OnboardingViewModel viewModel,
    WidgetRef ref,
  ) {
    return PageView.builder(
      controller: controller,
      itemCount: onboardingContent.length,
      onPageChanged: (index) {
        viewModel.onPageChanged(index);
        ref.read(onboardingControllerProvider.notifier).setStep(index);
      },
      itemBuilder: (_, index) => onboardingContent[index],
    );
  }
}
