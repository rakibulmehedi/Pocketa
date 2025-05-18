import 'package:flutter/material.dart';
import 'package:pocketa/features/onboarding/model/grid_item_model.dart';

import '../../../l10n/app_localization.dart';

List<GridItemModel> getIncomeOptions(BuildContext context) {
  return [
    GridItemModel(label: context.l10n.freelance, icon: Icons.laptop_mac),
    GridItemModel(label: context.l10n.job, icon: Icons.work),
    GridItemModel(label: context.l10n.familySupport, icon: Icons.group),
    GridItemModel(label: context.l10n.other, icon: Icons.more_horiz),
  ];
}

List<GridItemModel> getIncomeRanges (BuildContext context, IconData icon) {
  return [
    GridItemModel(label: context.l10n.zeroToFiveThousand, icon: icon),
    GridItemModel(label: context.l10n.fiveThousandToTenThousand, icon: icon),
    GridItemModel(label: context.l10n.tenThousandToTwentyThousand, icon: icon),
    GridItemModel(label: context.l10n.twentyThousandToFiftyThousand, icon: icon),
    GridItemModel(label: context.l10n.fiftyThousandPlus, icon: icon),
  ];
}

List<GridItemModel> getCategories (BuildContext context, IconData icon) {
  return [
    GridItemModel(label: context.l10n.zeroToFiveThousand, icon: icon),
    GridItemModel(label: context.l10n.fiveThousandToTenThousand, icon: icon),
    GridItemModel(label: context.l10n.tenThousandToTwentyThousand, icon: icon),
    GridItemModel(label: context.l10n.twentyThousandToFiftyThousand, icon: icon),
    GridItemModel(label: context.l10n.fiftyThousandPlus, icon: icon),
  ];
}

