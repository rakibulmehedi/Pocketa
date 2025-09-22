import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui_components/dialogs/app_dialog.dart';

/// Confirmation dialog
class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final l10n = AppLocalizations.of(context);

    return AppDialog(
      title: title,
      content: Text(message, style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelText ?? l10n.btn_cancel),
        ),
        SizedBox(width: layout.spaceS),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          child: Text(confirmText ?? l10n.btn_confirm),
        ),
      ],
    );
  }
}
