// lib/core/components/app_button.dart
import 'package:flutter/material.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

import '../themes/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isPrimary ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.grey,
          foregroundColor: isPrimary ? Colors.white : AppColors.textDark,
          padding: ResponsiveUtils.verticalPadding(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.font(context, 16),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
