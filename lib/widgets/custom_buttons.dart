import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// Custom button for positive actions, such as submitting a form or proceeding to the next step
/// This button can be used in dialogs or forms where the user is expected to take a positive
/// action, such as confirming an action or submitting data.
/// It provides a consistent look and feel across the app for positive actions.
class PositiveButton extends StatelessWidget {
  /// Creates a [PositiveButton] widget.
  /// This button is typically used to trigger positive actions
  /// such as submitting a form or proceeding to the next step in a process.
  /// It can be used in various parts of the app,

  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const PositiveButton({super.key, this.label, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ElevatedButton.icon(
      onPressed: () {
        onPressed ?? // Snackbar
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.ok)));
      },
      icon: Icon(icon ?? Icons.arrow_forward), // Default icon if none provided
      label: Text(label ?? t.getStarted), // <- localized string
      style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
    );
  }
}

/// Custom button for negative actions, such as canceling or going back
/// This button can be used in dialogs or forms where the user might want to cancel their action
/// or go back to the previous screen.
/// It provides a consistent look and feel across the app for negative actions.
class NegativeButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const NegativeButton({super.key, this.label, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ElevatedButton.icon(
      onPressed: () {
        onPressed ?? // Snackbar
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.errorsTitle)));
      },
      icon: Icon(icon ?? Icons.cancel),
      label: Text(label ?? t.errorsTitle), // <- localized string
      style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
    );
  }
}
