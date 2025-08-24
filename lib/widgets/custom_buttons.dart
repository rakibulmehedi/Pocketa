import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localizations.dart';

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
    final theme = ThemeData();
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward), // Default icon if none provided
      label: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ), // <- localized string
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: theme.colorScheme.primary,
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.cancel),
      label: Text(label ?? t.errorsTitle), // <- localized string
      style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
    );
  }
}
