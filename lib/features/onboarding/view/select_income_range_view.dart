import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/core/component/selectable_card.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

import '../../../config/provider/onboarding_state.dart';
import '../data/income_range_data.dart';

/// Income range selection view
class IncomeRangeSelectionView extends ConsumerWidget {
  const IncomeRangeSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// get income ranges
    final isDark = ref.watch(isDarkModeProvider);
    final onboardingState = ref.watch(onboardingStateProvider);
    final selectedIncomeRange = onboardingState.incomeRange;

    /// get selected currency
    final selectedCurrency = onboardingState.selectedCurrency;

    final incomeRanges = getIncomeRanges(context);

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
                return SelectableCard(
                  label: range.label,
                  iconOrWidget: CurrencyToSymbolWidget(
                    textStyle: TextStyle(
                      fontSize: ResponsiveUtilities.font(context, 18),
                      fontWeight: FontWeight.w500,
                    ),
                    currencyCode: selectedCurrency ?? 'USD',
                  ),
                  isSelected: selectedIncomeRange == range.label,
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
