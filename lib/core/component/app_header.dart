import 'package:flutter/material.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? step; // 1, 2, 3
  final int totalSteps;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.step,
    this.totalSteps = 3,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleFontSize = ResponsiveUtils.width(context, 0.08);
    final subtitleFontSize = ResponsiveUtils.width(context, 0.035);
    final progress = (step != null && totalSteps > 0)
        ? (step!.clamp(1, totalSteps) / totalSteps)
        : null;

    return Padding(
      padding: padding ??
          EdgeInsets.only(
            top: ResponsiveUtils.height(context, 0.01),
            bottom: ResponsiveUtils.height(context, 0.02),
          ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (progress != null) ...[
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: progress,
              ),
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade300,
                  color: theme.primaryColor,
                  minHeight: ResponsiveUtils.height(context, 0.008),
                ),
              ),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 0.015)),
          ],
          Text(
            title,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.displayLarge?.color,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: ResponsiveUtils.height(context, 0.008)),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: subtitleFontSize,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
