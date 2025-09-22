import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/core/theme/app_colors.dart';

/// Enhanced empty state with customizable content
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? iconColor;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
    this.iconSize = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    final iconColorValue = iconColor ?? AppColors.textSecondary(context);

    return RepaintBoundary(
      child: Center(
        child: Padding(
          padding: layout.insetsAll(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColorValue.withValues(alpha: 0.6),
              ),
              SizedBox(height: layout.spaceL),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                SizedBox(height: layout.spaceS),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                SizedBox(height: layout.spaceXL),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
