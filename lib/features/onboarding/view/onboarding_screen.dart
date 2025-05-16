import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/onboarding/view/income_source_selection_screen.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../config/provider/theme_provider.dart';
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
    /// ✅ Provider 들
    final controller = ref.watch(pageControllerProvider);
    final viewModel = ref.watch(onboardingViewModelProvider);
    final currentIndex = ref.watch(currentPageProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final selectedIncomeSource = ref.watch(selectedIncomeSourceProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      /// ✅ Custom AppBar
      appBar: const AppAppBar(showBackButton: true),

      /// ✅ Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: ResponsiveUtils.symmetricPadding(
          context,
          horizontal: 0.06,
          vertical: 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔸 CTA Button (Next/Get Started)
            ElevatedButton(
              onPressed:
                  selectedIncomeSource != null
                      ? () {
                        if (currentIndex == onboardingContent.length - 1) {
                          viewModel.completeOnboarding(context);
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }

                        /// ✅ Step update ও Navigate করা
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .nextStep();
                        Navigator.pushNamed(context, '/onboarding/next-screen');
                      }
                      : null,

              child: Text(
                currentIndex == onboardingContent.length - 1
                    ? context.l10n.getStarted
                    : context.l10n.next,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔸 Optional skip button
            SkipButton(
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).skipToEnd();
                Navigator.pushNamed(context, '/onboarding/next-screen');
              },
            ),
          ],
        ),
      ),

      /// ✅ Main Content: PageView + Dots + CTA Button
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: onboardingContent.length,
              onPageChanged: viewModel.onPageChanged,
              itemBuilder: (_, index) {
                switch (index) {
                  case 0:
                    return const IncomeSourceSelectionScreen();
                  case 1:
                    return const IncomeSourceSelectionScreen();
                  case 2:
                    return const IncomeSourceSelectionScreen();
                }
              },
            ),
          ),

          /// 🔹 Dot Indicator: কোন পেজে আছো তা দেখায়
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingContent.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                height: 8,
                width: currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
