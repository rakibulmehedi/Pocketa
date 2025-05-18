import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/selectable_card.dart';
import '../utils/responsive_utils.dart';
import '../../features/onboarding/model/grid_item_model.dart';

class AppGrid extends ConsumerWidget {
  final List<GridItemModel> items;
  final String? selectedLabel; // for single select
  final List<String> selectedLabels; // for multi select
  final ValueChanged<String> onSelect;
  final bool isMultiSelect;

  const AppGrid({
    super.key,
    required this.items,
    required this.onSelect,
    this.selectedLabel,
    this.selectedLabels = const [],
    this.isMultiSelect = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtilities.gridCrossAxisCount(context),
        crossAxisSpacing: ResponsiveUtilities.gridAxisSpacing(context),
        mainAxisSpacing: ResponsiveUtilities.gridAxisSpacing(context),
        childAspectRatio: ResponsiveUtilities.gridChildAspectRatio(context),
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        final isSelected =
            isMultiSelect
                ? selectedLabels.contains(item.label)
                : selectedLabel == item.label;

        return SelectableCard(
          iconSize: 38,
          fontSize: 18,
          label: item.label,
          icon: item.icon,
          isSelected: isSelected,
          onTap: () => onSelect(item.label),
          isGrid: true,
          color: item.color,
        );
      },
    );
  }
}
