// lib/core/components/app_button.dart
import 'package:flutter/material.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

import '../themes/app_colors.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool disabled = !isEnabled || isLoading;

    // Define colors based on button type
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (type) {
      case AppButtonType.primary:
        backgroundColor =
            disabled ? AppColors.primary.withOpacity(0.4) : AppColors.primary;
        foregroundColor = Colors.white;
        borderColor = Colors.transparent;
        break;

      case AppButtonType.secondary:
        backgroundColor = isDark ? Colors.grey[500]! : Colors.grey[300]!;
        foregroundColor = isDark ? AppColors.textLight : AppColors.textDark;
        borderColor = Colors.transparent;
        break;

      case AppButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderColor = AppColors.primary;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: ResponsiveUtilities.verticalPadding(context, percent: 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                : Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveUtilities.font(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
