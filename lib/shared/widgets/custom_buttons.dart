import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/design_system/design_system.dart';

/// Custom button for positive actions, such as submitting a form or proceeding to the next step
class PositiveButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const PositiveButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward), // Default icon if none provided
      label: Text(
        label,
        style: TypographyTokens.buttonText(context).copyWith(
          color: ColorTokens.buttonOnPrimary(context),
        ),
      ), // <- localized string
      style: ComponentTokens.primaryButton(context).copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(
            DesignTokens.getResponsiveSpacing(
              context,
              phone: 200,
              tablet: 220,
              desktop: 240,
            ),
            DesignTokens.getButtonHeight(context),
          ),
        ),
      ),
    );
  }
}

/// Custom button for negative actions, such as canceling or going back
class NegativeButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const NegativeButton({super.key, this.label, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.cancel),
      label: Text(label ?? t.errorsTitle), // <- localized string
      style: ComponentTokens.secondaryButton(context).copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(
            DesignTokens.getResponsiveSpacing(
              context,
              phone: 180,
              tablet: 200,
              desktop: 220,
            ),
            DesignTokens.getButtonHeight(context),
          ),
        ),
      ),
    );
  }
}
