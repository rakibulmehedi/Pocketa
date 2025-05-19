import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../../core/themes/app_colors.dart';
import '../model/grid_item_model.dart';

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
