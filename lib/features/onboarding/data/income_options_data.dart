import 'package:flutter/material.dart';
import 'package:pocketa/features/onboarding/model/income_options.dart';

import '../../../l10n/app_localization.dart';

List<IncomeOption> getIncomeOptions(BuildContext context) {
  return [
    IncomeOption(label: context.l10n.freelance, icon: Icons.laptop_mac),
    IncomeOption(label: context.l10n.job, icon: Icons.work),
    IncomeOption(label: context.l10n.familySupport, icon: Icons.group),
    IncomeOption(label: context.l10n.other, icon: Icons.more_horiz),
  ];
}
