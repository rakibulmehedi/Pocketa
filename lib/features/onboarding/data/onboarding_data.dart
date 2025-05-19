import 'package:flutter/material.dart';

import '../../../l10n/app_localization.dart';

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
