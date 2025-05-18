import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../../core/component/app_button.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../config/provider/onboarding_controller_provider.dart';

class OnboardingBottomNav extends ConsumerWidget {
  final bool isLast;
  final bool isValid;
  final String? selectedData;
  final int currentIndex;

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

    void _handleOnboardingNext() {
      if (isLast) {
        viewModel.completeOnboarding(context);
      } else {
        controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
      ref.read(onboardingControllerProvider.notifier).nextStep();
    }

    return Padding(
      padding: ResponsiveUtilities.symmetricPadding(
        context,
        horizontal: 0.06,
        vertical: 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (currentIndex > 0)
                Expanded(
                  child: AppButton(
                    label: context.l10n.back,
                    onPressed: () {
                      controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .previousStep();
                    },
                    isEnabled: true,
                    type: AppButtonType.secondary,
                  ),
                ),
              if (currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: isLast
                      ? context.l10n.getStarted
                      : context.l10n.next,
                  onPressed: (isValid || isLast) ? _handleOnboardingNext : null,
                  isEnabled: isValid || isLast,
                ),
              ),
            ],
          ),
          ResponsiveUtilities.spacing(context),
        ],
      ),
    );
  }
}
