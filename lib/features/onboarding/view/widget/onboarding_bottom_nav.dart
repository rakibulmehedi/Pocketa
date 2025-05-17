import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../../core/component/app_button.dart';
import '../../../../core/component/skip_button.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingBottomNav extends ConsumerWidget {
  final isLast;
  final isValid;
  final selectedData;
  final currentIndex;

  const OnboardingBottomNav(
    this.isLast,
    this.isValid,
    this.selectedData,
    this.currentIndex, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final controller = ref.watch(pageControllerProvider);
    final viewModel = ref.watch(onboardingViewModelProvider);

    void _handleOnboardingNext(
      BuildContext context,
      WidgetRef ref,
      PageController controller,
      OnboardingViewModel viewModel,
      int currentIndex,
      bool isLast,
    ) {
      if (isLast) {
        viewModel.completeOnboarding(context);
      } else {
        controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }

      ref.read(onboardingControllerProvider.notifier).nextStep();
      Navigator.pushNamed(context, '/onboarding/next-screen');
    }

    return Padding(
      padding: ResponsiveUtils.symmetricPadding(
        context,
        horizontal: 0.06,
        vertical: 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔸 CTA Button (Next/Get Started)
          AppButton(
            label: isLast ? context.l10n.getStarted : context.l10n.next,
            onPressed:
                (isValid || isLast)
                    ? () => _handleOnboardingNext(
                      context,
                      ref,
                      controller,
                      viewModel,
                      currentIndex,
                      isLast,
                    )
                    : null,
            isPrimary: isValid || isLast,
          ),
          const SizedBox(height: 12),

          /// 🔸 Optional skip button
          if (!isLast)
            SkipButton(
              isDark: isDark,
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).skipToEnd();
                ref.read(currentPageProvider.notifier).state = 2;
                controller.jumpToPage(2);
                // Navigator.pushNamed(context, '/onboarding/next-screen');
              },
            ),
        ],
      ),
    );
  }
}
