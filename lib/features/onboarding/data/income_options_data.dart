import 'package:flutter/material.dart';
import 'package:pocketa/features/onboarding/model/income_options.dart';

import '../../../l10n/app_localization.dart';

List<IncomeOption> getIncomeOptions(BuildContext context) {
  return [
    IncomeOption(label: L.of(context).freelance, icon: Icons.laptop_mac),
    IncomeOption(label: L.of(context).job, icon: Icons.work),
    IncomeOption(label: L.of(context).familySupport, icon: Icons.group),
    IncomeOption(label: L.of(context).other, icon: Icons.more_horiz),
  ];
}
