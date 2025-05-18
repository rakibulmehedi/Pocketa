import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/provider/theme_provider.dart';
import '../themes/app_colors.dart';
import '../utils/responsive_utils.dart';

class AppChip extends ConsumerWidget {
  final bool isGrid;
  final String label;
  final IconData icon;
  final double iconSize;
  final double fontSize;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    final Color primaryColor = theme.primaryColor;
    final Color iconColor = isSelected ? primaryColor : AppColors.grey;
    final Color textColor =
        isSelected
            ? primaryColor
            : isDark
            ? AppColors.textLight
            : AppColors.grey;

    final Color backgroundColor =
        isSelected
            ? primaryColor.withOpacity(0.08)
            : isDark
            ? AppColors.textDark.withOpacity(0.2)
            : AppColors.primary.withOpacity(0.03);

    final Color borderColor =
        isSelected ? primaryColor : AppColors.grey.withOpacity(0.4);

    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.width(context, 0.04),
      vertical: ResponsiveUtils.height(context, 0.02),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: ResponsiveUtils.width(context, 0.003),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child:
            isGrid
                ? _buildGridContent(context, iconColor, textColor)
                : _buildListContent(context, iconColor, textColor),
      ),
    );
  }

  Widget _buildGridContent(
    BuildContext context,
    Color iconColor,
    Color textColor,
  ) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(
    BuildContext context,
    Color iconColor,
    Color textColor,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
