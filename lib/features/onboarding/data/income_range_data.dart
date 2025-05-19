import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../core/themes/app_colors.dart';
import '../model/grid_item_model.dart';

final Color _primaryColor = AppColors.primary;

List<GridItemModel> getIncomeRanges(BuildContext context) {
  return [
    GridItemModel(
      label: context.l10n.zeroToFiveThousand,
      icon: Icons.attach_money,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.fiveThousandToTenThousand,
      icon: Icons.attach_money,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.tenThousandToTwentyThousand,
      icon: Icons.attach_money,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.twentyThousandToFiftyThousand,
      icon: Icons.attach_money,
      color: _primaryColor,
    ),
    GridItemModel(
      label: context.l10n.fiftyThousandPlus,
      icon: Icons.attach_money,
      color: _primaryColor,
    ),
  ];
}
