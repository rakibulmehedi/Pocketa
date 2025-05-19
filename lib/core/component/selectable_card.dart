import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/grid_or_list_chip.dart';

class SelectableCard extends ConsumerWidget {
  final bool isGrid;
  final String label;
  final double fontSize;
  final Widget? iconOrWidget;
  final IconData? icon;
  final Color color;
  final double iconSize;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    this.icon,
    required this.label,
    required this.color,
    this.iconOrWidget,
    required this.isSelected,
    required this.onTap,
    required this.isGrid,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppChip(
      label: label,
      widgetAsIcon: iconOrWidget,
      isSelected: isSelected,
      onTap: onTap,
      iconSize: iconSize,
      fontSize: fontSize,
      isGrid: isGrid,
      color: color,
      icon: icon,
    );
  }
}
