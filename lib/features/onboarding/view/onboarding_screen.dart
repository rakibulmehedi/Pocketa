import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/onboarding/model/onboarding_state.dart';
import 'package:pocketa/features/onboarding/view/widget/onboarding_bottom_nav.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../config/provider/theme_provider.dart';
import '../../../core/component/app_header.dart';
import '../../../core/component/skip_button.dart';
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

    final onboardingState = ref.watch(onboardingStateProvider);
    final selectedIncomeSource = onboardingState.incomeSource;
    final currentStep = ref.watch(onboardingControllerProvider);

    final isLast = currentIndex == onboardingContent.length - 1;
    final isStepValid = onboardingState.isStepValid(currentIndex);

    Map<String, String> _getHeaderText(BuildContext context, int index) {
      final l10n = context.l10n;
      return switch (index) {
        0 => {
          'title': l10n.onboardingStep1,
          'subtitle': l10n.whatIsYourMainIncomeSource,
        },
        1 => {'title': l10n.onboardingStep2, 'subtitle': l10n.selectCurrency},
        2 => {
          'title': l10n.onboardingStep2,
          'subtitle': l10n.selectMonthlyIncome,
        },
        3 => {
          'title': l10n.onboardingStep3,
          'subtitle': l10n.setupYourBudgetCategories,
        },
        _ => {'title': '', 'subtitle': ''},
      };
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      /// ✅ Custom AppBar
      appBar: AppAppBar(
        centerTitle: true,
        title: _getHeaderText(context, currentIndex)['title']!,
        showBackButton: true,
        actions: [
          /// 🔸 Optional skip button
          if (!isLast)
            AnimatedOpacity(
              opacity: isLast ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: SkipButton(
                isDark: isDark,
                onPressed: () {
                  ref.read(onboardingControllerProvider.notifier).skipToEnd();
                  ref.read(currentPageProvider.notifier).state = 2;
                  controller.jumpToPage(2);
                  // Navigator.pushNamed(context, '/onboarding/next-screen');
                },
              ),
            ),
        ],
        onBack: () {
          final current = ref.read(currentPageProvider);
          if (current > 0) {
            ref.read(currentPageProvider.notifier).state = current - 1;
            controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
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
        isStepValid,
        selectedIncomeSource,
        currentIndex,
      ),

      /// ✅ Main Content: PageView + Dots + CTA Button
      body: Column(
        children: [
          Padding(
            padding: ResponsiveUtils.symmetricPadding(context),
            child: OnboardingHeader(
              title: _getHeaderText(context, currentIndex)['subtitle']!,
              step: currentStep + 1,
              totalSteps: 4,
              isDark: isDark,
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
