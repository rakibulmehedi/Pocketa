import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// Base dialog with common functionality
class BaseDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? contentPadding;
  final double? maxWidth;
  final double? maxHeight;

  const BaseDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.contentPadding,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.rem(context)),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? (layout.isDesktop ? 400 : double.infinity),
          maxHeight: maxHeight ?? (layout.isDesktop ? 600 : double.infinity),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || showCloseButton) _buildHeader(context, theme),
            if (content != null) _buildContent(context),
            if (actions != null) _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.rem(context)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              iconSize: 20.rem(context),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: contentPadding ?? EdgeInsets.all(16.rem(context)),
        child: content!,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.rem(context)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      ),
    );
  }
}

/// Base confirmation dialog
class BaseConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;
  final bool isDestructive;

  const BaseConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      title: title,
      content: Text(
        message,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: cancelColor ?? theme.colorScheme.onSurface,
          ),
          child: Text(cancelText),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? 
                (isDestructive ? theme.colorScheme.error : theme.colorScheme.primary),
            foregroundColor: isDestructive 
                ? theme.colorScheme.onError 
                : theme.colorScheme.onPrimary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Base form dialog
class BaseFormDialog extends StatefulWidget {
  final String? title;
  final Widget form;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final String saveText;
  final String cancelText;
  final bool isLoading;
  final bool isValid;

  const BaseFormDialog({
    super.key,
    this.title,
    required this.form,
    this.onSave,
    this.onCancel,
    this.saveText = 'Save',
    this.cancelText = 'Cancel',
    this.isLoading = false,
    this.isValid = true,
  });

  @override
  State<BaseFormDialog> createState() => _BaseFormDialogState();
}

class _BaseFormDialogState extends State<BaseFormDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      title: widget.title,
      content: widget.form,
      actions: [
        TextButton(
          onPressed: widget.isLoading ? null : (widget.onCancel ?? () => Navigator.of(context).pop()),
          child: Text(widget.cancelText),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: widget.isLoading || !widget.isValid ? null : widget.onSave,
          child: widget.isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(widget.saveText),
        ),
      ],
    );
  }
}

/// Dialog service for showing common dialogs
class DialogService {
  /// Show confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BaseConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
  }

  /// Show form dialog
  static Future<T?> showForm<T>(
    BuildContext context, {
    String? title,
    required Widget form,
    VoidCallback? onSave,
    VoidCallback? onCancel,
    String saveText = 'Save',
    String cancelText = 'Cancel',
    bool isLoading = false,
    bool isValid = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => BaseFormDialog(
        title: title,
        form: form,
        onSave: onSave,
        onCancel: onCancel,
        saveText: saveText,
        cancelText: cancelText,
        isLoading: isLoading,
        isValid: isValid,
      ),
    );
  }

  /// Show custom dialog
  static Future<T?> showCustom<T>(
    BuildContext context, {
    String? title,
    Widget? content,
    List<Widget>? actions,
    bool showCloseButton = true,
    VoidCallback? onClose,
    EdgeInsetsGeometry? contentPadding,
    double? maxWidth,
    double? maxHeight,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => BaseDialog(
        title: title,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
        onClose: onClose,
        contentPadding: contentPadding,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
    );
  }
}
