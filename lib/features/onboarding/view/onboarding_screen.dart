import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/onboarding_state.dart';
import 'package:pocketa/features/onboarding/data/onboarding_data.dart';
import 'package:pocketa/features/onboarding/view/widgets/onboarding_bottom_nav.dart';

import '../../../config/provider/theme_provider.dart';
import '../../../core/component/app_header.dart';
import '../../../core/component/skip_button.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../config/provider/onboarding_controller_provider.dart';
import '../data/onboarding_content.dart';
import '../view_model/onboarding_view_model.dart';

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
    final onboardingHeaderText = getOnboardingHeaderText(context, currentIndex);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      /// ✅ Custom AppBar
      appBar: _buildAppAppBar(isLast, isDark, ref, controller, context),

      /// ✅ Bottom Navigation Bar
      bottomNavigationBar: _buildOnboardingBottomNav(
        isLast,
        isStepValid,
        selectedIncomeSource,
        currentIndex,
      ),

      /// ✅ Main Content: PageView + Dots + CTA Button
      body: Column(
        children: [
          Padding(
            padding: ResponsiveUtilities.symmetricPadding(context),
            child: OnboardingHeader(
              title: onboardingHeaderText['subtitle']!,
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

  OnboardingBottomNav _buildOnboardingBottomNav(
    bool isLast,
    bool isStepValid,
    String? selectedIncomeSource,
    int currentIndex,
  ) {
    return OnboardingBottomNav(
      isLast,
      isStepValid,
      selectedIncomeSource,
      currentIndex,
    );
  }

  AppAppBar _buildAppAppBar(
    bool isLast,
    bool isDark,
    WidgetRef ref,
    PageController controller,
    BuildContext context,
  ) {
    return AppAppBar(
      centerTitle: true,
      title: '',
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
                ref.read(currentPageProvider.notifier).state = 3;
                controller.jumpToPage(3);
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
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        viewModel.onPageChanged(index);
        ref.read(onboardingControllerProvider.notifier).setStep(index);
      },
      itemBuilder: (_, index) => onboardingContent[index],
    );
  }
}
