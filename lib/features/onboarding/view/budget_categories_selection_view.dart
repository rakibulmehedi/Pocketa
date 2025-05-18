import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/provider/theme_provider.dart';
import 'package:pocketa/core/component/selectable_card.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/features/onboarding/data/onboarding_data.dart';
import 'package:pocketa/features/onboarding/view/widget/app_grid.dart';

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
      body: AppGrid(
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
    );
  }
}
