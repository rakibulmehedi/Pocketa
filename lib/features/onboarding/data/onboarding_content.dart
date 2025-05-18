import 'package:flutter/material.dart';
import 'package:pocketa/features/onboarding/view/budget_categories_selection_view.dart';
import 'package:pocketa/features/onboarding/view/currency_selection_view.dart';
import 'package:pocketa/features/onboarding/view/income_source_selection_view.dart';
import 'package:pocketa/features/onboarding/view/select_income_range_view.dart';

final List<Widget> onboardingContent = [
  const IncomeSourceSelectionScreen(),
  const CurrencySelectionView(),
  const IncomeRangeSelectionView(),
  const BudgetCategoriesSelectionView(),
];
