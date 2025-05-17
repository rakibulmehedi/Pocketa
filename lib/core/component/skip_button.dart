import 'package:flutter/material.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import '../../l10n/app_localization.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const SkipButton({super.key, required this.onPressed, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed, // ✅ Function is now being called correctly
        child: Text(
          context.l10n.skip,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ?  AppColors.grey : AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
