import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import '../performance/interactive_wrapper.dart';

/// Quick action buttons for common actions
class QuickButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isPositive;
  final bool enableHaptic;

  const QuickButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isPositive = true,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return RepaintBoundary(
      child: InteractiveWrapper(
        onTap: onPressed,
        enableHaptic: enableHaptic,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: layout.spaceL,
            vertical: layout.spaceM,
          ),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.success(context).withValues(alpha: 0.1)
                : AppColors.error(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(layout.radiusM),
            border: Border.all(
              color: isPositive
                  ? AppColors.success(context).withValues(alpha: 0.3)
                  : AppColors.error(context).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
                  color: isPositive
                      ? AppColors.success(context)
                      : AppColors.error(context),
                ),
                SizedBox(width: layout.spaceS),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isPositive
                      ? AppColors.success(context)
                      : AppColors.error(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}