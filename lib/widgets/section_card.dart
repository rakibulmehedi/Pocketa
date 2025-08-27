import 'package:flutter/material.dart';

/// A reusable Section Card widget for grouping related fields or content.
class SectionCard extends StatelessWidget {
  final String? title;
  final Widget? trailing; // optional action button beside title
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final bool showDivider;

  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.children,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style: theme.textTheme.titleMedium),
                if (trailing != null) trailing!,
              ],
            ),
            if (showDivider) const Divider(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }
}
