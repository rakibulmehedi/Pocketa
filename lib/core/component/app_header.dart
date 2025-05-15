import 'package:flutter/material.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleFontSize = ResponsiveUtils.width(context, 0.08); // ~6% of width
    final subtitleFontSize = ResponsiveUtils.width(
      context,
      0.035,
    ); // ~3.5% of width

    return Padding(
      padding:
          padding ??
          EdgeInsets.only(
            top: ResponsiveUtils.height(context, 0.01),
            bottom: ResponsiveUtils.height(context, 0.01),
          ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
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
