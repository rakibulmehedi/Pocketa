// lib/core/components/app_card.dart
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppCard extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Color? background;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.title,
    this.icon,
    this.background,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background ?? AppColors.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) icon!,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
