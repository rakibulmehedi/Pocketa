import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// Reusable empty state widget for consistent UI across the app
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? layout.pageGutter,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(layout.spaceXL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: layout.responsiveIconSize(phone: 48, tablet: 56, desktop: 64),
                color: AppColors.textSecondary(context),
              ),
            ),

            SizedBox(height: layout.spaceXL),

            // Title
            Text(
              title,
              style: AppTextStyles.responsiveTitle(context),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: layout.spaceM),
              Text(
                subtitle!,
                style: AppTextStyles.responsiveBody(context),
                textAlign: TextAlign.center,
              ),
            ],

            // Action
            if (action != null) ...[
              SizedBox(height: layout.spaceXL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}