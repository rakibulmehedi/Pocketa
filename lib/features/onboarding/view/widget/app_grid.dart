import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/component/selectable_card.dart';
import 'package:pocketa/features/onboarding/model/grid_item_model.dart';

import '../../../../core/widgets/grid_or_list_chip.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/onboarding_data.dart';
import '../../model/onboarding_state.dart';
import '../income_source_selection_view.dart';

class AppGrid extends ConsumerWidget {
  final List<GridItemModel> items;
  final String? selectedLabel;
  final ValueChanged<String> onSelect;

  const AppGrid({
    super.key,
    required this.items,
    required this.selectedLabel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GridView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
          crossAxisSpacing: ResponsiveUtils.gridAxisSpacing(context),
          mainAxisSpacing: ResponsiveUtils.gridAxisSpacing(context),
          childAspectRatio: ResponsiveUtils.gridChildAspectRatio(context),
        ),
        itemBuilder: (_, index) {
          final item = items[index];
          return SelectableCard(
            iconSize: 38,
            fontSize: 18,
            label: item.label,
            icon: item.icon,
            isSelected: selectedLabel == item.label,
            onTap: () => onSelect(item.label),
            isGrid: true,
          );
        },
      ),
    );
  }
}
