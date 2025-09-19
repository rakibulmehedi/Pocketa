import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/domain/entities/onboarding_entity.dart';

/// A reusable income option chip widget with responsive sizing
class IncomeOptionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final IncomeType value;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const IncomeOptionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.onTap,
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
        padding: EdgeInsets.all(layout.spaceM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryStrong(context)
              : AppColors.surfaceElevated(context),
          borderRadius: BorderRadius.circular(layout.radiusM),
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
        child: Column(
          children: [
            Icon(
              icon,
              size: layout.responsiveIconSize(
                phone: 28,
                tablet: 32,
                desktop: 36,
              ),
              color: isSelected
                  ? AppColors.buttonTextPrimary(context)
                  : AppColors.iconSecondary(context),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              label,
              style: TextStyle(
                fontSize: layout.responsiveTextSize(
                  phone: 13,
                  tablet: 14,
                  desktop: 15,
                ),
                color: isSelected
                    ? AppColors.buttonTextPrimary(context)
                    : AppColors.textPrimary(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
