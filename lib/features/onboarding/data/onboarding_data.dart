import 'package:flutter/material.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/features/onboarding/model/grid_item_model.dart';

import '../../../l10n/app_localization.dart';
import '../model/budget_category_model.dart';

final Color _primaryColor = AppColors.primary;

List<GridItemModel> getIncomeOptions(BuildContext context) {
  return [
    GridItemModel(
      label: context.l10n.freelance,
      icon: Icons.laptop_mac,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.job,
      icon: Icons.work,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.familySupport,
      icon: Icons.group,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.other,
      icon: Icons.more_horiz,
      color: _primaryColor,
    ),
  ];
}

List<GridItemModel> getIncomeRanges(BuildContext context, IconData icon) {
  return [
    GridItemModel(
      label: context.l10n.zeroToFiveThousand,
      icon: icon,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.fiveThousandToTenThousand,
      icon: icon,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.tenThousandToTwentyThousand,
      icon: icon,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.twentyThousandToFiftyThousand,
      icon: icon,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.fiftyThousandPlus,
      icon: icon,
      color: _primaryColor,
    ),
  ];
}

final List<BudgetCategory> defaultBudgetCategories = [
  BudgetCategory(
    id: 'food',
    name: 'Food',
    icon: Icons.fastfood,
    color: Colors.red,
    limit: 0,
  ),
  BudgetCategory(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car,
    color: Colors.blue,
    limit: 0,
  ),
  BudgetCategory(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.purple,
    limit: 0,
  ),
  BudgetCategory(
    id: 'entertainment',
    name: 'Entertainment',
    icon: Icons.movie,
    color: Colors.green,
    limit: 0,
  ),
  BudgetCategory(
    id: 'bills',
    name: 'Bills',
    icon: Icons.receipt,
    color: Colors.orange,
    limit: 0,
  ),
];

final List<GridItemModel> budgetCategoryItems =
    defaultBudgetCategories
        .map((e) => GridItemModel(label: e.name, icon: e.icon, color: e.color))
        .toList();

Map<String, String> getOnboardingHeaderText(BuildContext context, int index) {
  final l10n = context.l10n;
  return switch (index) {
    0 => {
      'title': l10n.onboardingStep1,
      'subtitle': l10n.whatIsYourMainIncomeSource,
    },
    1 => {'title': l10n.onboardingStep2, 'subtitle': l10n.selectCurrency},
    2 => {'title': l10n.onboardingStep3, 'subtitle': l10n.selectMonthlyIncome},
    3 => {
      'title': l10n.onboardingStep3,
      'subtitle': l10n.setupYourBudgetCategories,
    },
    _ => {'title': '', 'subtitle': ''},
  };
}
