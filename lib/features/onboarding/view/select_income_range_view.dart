import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/core/component/selectable_card.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/features/onboarding/data/onboarding_data.dart';

import '../../../config/provider/onboarding_state.dart';

class IncomeRangeSelectionView extends ConsumerWidget {
  const IncomeRangeSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final onboardingState = ref.watch(onboardingStateProvider);
    final selected = onboardingState.incomeRange;
    final selectedCurrency = onboardingState.selectedCurrency;
    IconData icon() {
      if (selectedCurrency == '৳ BDT') return Icons.attach_money;
      if (selectedCurrency == '\$ USD') return Icons.monetization_on_outlined;
      if (selectedCurrency == '€ EUR') return Icons.monetization_on_sharp;
      if (selectedCurrency == '₹ INR') return Icons.money_sharp;
      if (selectedCurrency == '¥ JPY') return Icons.attach_money;
      return Icons.attach_money;
    }

    final incomeRanges = getIncomeRanges(context, icon());

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: ResponsiveUtilities.horizontalPadding(context),
              itemCount: incomeRanges.length,
              itemBuilder: (context, index) {
                final range = incomeRanges[index];
                final icon = range.icon;
                return SelectableCard(
                  label: range.label,
                  icon: icon,
                  isSelected: selected == range.label,
                  onTap: () {
                    ref
                        .read(onboardingStateProvider.notifier)
                        .setIncomeRange(range.label);
                  },
                  isGrid: false,
                  iconSize: 24,
                  fontSize: 18,
                  color: AppColors.primary,
                );
              },
              separatorBuilder:
                  (BuildContext context, int index) =>
                      ResponsiveUtilities.spacing(context),
            ),
          ),
        ],
      ),
    );
  }
}
