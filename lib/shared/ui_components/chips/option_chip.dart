import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/core/theme/app_colors.dart';

/// A reusable option chip widget with responsive sizing
class OptionChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const OptionChip({
    super.key,
    required this.label,
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
        padding: EdgeInsets.symmetric(
          horizontal: layout.responsiveSize(
            phone: 24,
            tablet: 32,
            desktop: 40,
          ),
          vertical: layout.responsiveSize(
            phone: 8,
            tablet: 12,
            desktop: 16,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color
              : AppColors.surfaceElevated(context),
          borderRadius: BorderRadius.circular(
            layout.responsiveSize(
              phone: 8,
              tablet: 12,
              desktop: 16,
            ),
          ),
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.borderMedium(context),
            width: layout.responsiveSize(
              phone: 1.5,
              tablet: 2.0,
              desktop: 2.5,
            ),
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: layout.responsiveSize(
                phone: 4,
                tablet: 8,
                desktop: 12,
              ),
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: layout.responsiveTextSize(
              phone: 15,
              tablet: 16,
              desktop: 18,
            ),
            color: isSelected
                ? AppColors.buttonTextPrimary(context)
                : AppColors.textPrimary(context),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
