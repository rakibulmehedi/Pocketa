import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/app_grid.dart';

import '../../../config/provider/onboarding_state.dart';
import '../data/budget_category_data.dart';

class BudgetCategoriesSelectionView extends ConsumerWidget {
  const BudgetCategoriesSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final onboardingState = ref.watch(onboardingStateProvider);
    final selected = onboardingState.selectedCategories;
    final categories = budgetCategoryItems;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Padding(
        padding: ResponsiveUtilities.horizontalPadding(context),
        child: AppGrid(
          isMultiSelect: true,
          items: categories,
          selectedLabels: selected,
          onSelect: (label) {
            final current = List<String>.from(selected);
            if (current.contains(label)) {
              current.remove(label);
            } else {
              current.add(label);
            }
            ref.read(onboardingStateProvider.notifier).setCategories(current);
          },
        ),
      ),
    );
  }
}
