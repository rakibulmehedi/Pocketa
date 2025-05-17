import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import '../../config/provider/theme_provider.dart';

/// ✅ OnboardingChip:
/// - এটি একটি custom choice chip widget
/// - responsive, theme-aware, এবং selectable

class OnboardingChip extends ConsumerWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const OnboardingChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ✅ Theme & Responsive
    final isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    /// ✅ Responsive size calculate
    final iconSize = ResponsiveUtils.icon(context, 42);
    final fontSize = ResponsiveUtils.font(context, 14);

    /// ✅ Color calculate
    final primaryColor = theme.primaryColor;

    final borderColor = isSelected
        ? primaryColor
        : AppColors.grey.withOpacity(0.4);

    final iconColor = isSelected
        ? primaryColor
        : AppColors.grey;

    final textColor = isSelected
        ? primaryColor
        : isDark
        ? AppColors.textLight
        : AppColors.grey;

    final backgroundColor = isSelected
        ? primaryColor.withOpacity(0.08)
        : isDark
        ? AppColors.textDark.withOpacity(0.2)
        : AppColors.primary.withOpacity(0.03);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: BoxConstraints(
          /// ✅ Responsive width constraints (min & max)
          minWidth: size.width * 0.25,
          maxWidth: size.width * 0.35,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
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
        ),
      ),
    );
  }
}
