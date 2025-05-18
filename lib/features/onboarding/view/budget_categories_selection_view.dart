import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/core/component/selectable_card.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/features/onboarding/data/onboarding_data.dart';

import '../model/onboarding_state.dart';

class BudgetCategoriesSelectionView extends ConsumerWidget {
  const BudgetCategoriesSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final onboardingState = ref.watch(onboardingStateProvider);
    final selected = onboardingState.selectedCategories;
    final categories = getCategories(context, Icons.attach_money_outlined);

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          padding: ResponsiveUtils.horizontalPadding(context),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final range = categories[index];
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
              isGrid: true,
              iconSize: 38,
              fontSize: 18,
            );
          },
          separatorBuilder:
              (BuildContext context, int index) =>
              ResponsiveUtils.spacing(context),
        ),
      ),
    );
  }
}
