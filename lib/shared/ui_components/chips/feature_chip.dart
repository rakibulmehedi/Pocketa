import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// A reusable feature chip widget with responsive sizing
class FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? accentColor;

  const FeatureChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    final color = accentColor ?? theme.colorScheme.primary;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: layout.responsiveSize(
            phone: 12,
            tablet: 16,
            desktop: 20,
          ),
          vertical: layout.responsiveSize(
            phone: 8,
            tablet: 12,
            desktop: 16,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryStrong(context)
              : AppColors.surfaceElevated(context),
          borderRadius: BorderRadius.circular(
            layout.responsiveSize(
              phone: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.borderMedium(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: layout.responsiveSize(
                phone: 4,
                tablet: 6,
                desktop: 8,
              ),
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: layout.responsiveIconSize(
                phone: 18,
                tablet: 20,
                desktop: 22,
              ),
              color: isSelected
                  ? AppColors.buttonTextPrimary(context)
                  : color,
            ),
            SizedBox(width: layout.spaceS),
            Text(
              label,
              style: TextStyle(
                fontSize: layout.responsiveTextSize(
                  phone: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.buttonTextPrimary(context)
                    : AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
