import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';

/// Base bottom sheet with common functionality
class BaseSheet extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? contentPadding;
  final double? maxHeight;
  final bool isScrollable;

  const BaseSheet({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.contentPadding,
    this.maxHeight,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? (layout.isDesktop ? 600 : double.infinity),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.rem(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || showCloseButton) _buildHeader(context, theme),
          if (content != null) _buildContent(context),
          if (actions != null) _buildActions(context),
        ],
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
    final contentWidget = Padding(
      padding: contentPadding ?? EdgeInsets.all(16.rem(context)),
      child: content!,
    );

    if (isScrollable) {
      return Flexible(
        child: SingleChildScrollView(
          child: contentWidget,
        ),
      );
    } else {
      return Flexible(child: contentWidget);
    }
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

/// Base form sheet
class BaseFormSheet extends StatefulWidget {
  final String? title;
  final Widget form;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final String saveText;
  final String cancelText;
  final bool isLoading;
  final bool isValid;
  final double? maxHeight;

  const BaseFormSheet({
    super.key,
    this.title,
    required this.form,
    this.onSave,
    this.onCancel,
    this.saveText = 'Save',
    this.cancelText = 'Cancel',
    this.isLoading = false,
    this.isValid = true,
    this.maxHeight,
  });

  @override
  State<BaseFormSheet> createState() => _BaseFormSheetState();
}

class _BaseFormSheetState extends State<BaseFormSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseSheet(
      title: widget.title,
      content: widget.form,
      maxHeight: widget.maxHeight,
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

/// Sheet service for showing common sheets
class SheetService {
  /// Show form sheet
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
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BaseFormSheet(
        title: title,
        form: form,
        onSave: onSave,
        onCancel: onCancel,
        saveText: saveText,
        cancelText: cancelText,
        isLoading: isLoading,
        isValid: isValid,
        maxHeight: maxHeight,
      ),
    );
  }

  /// Show custom sheet
  static Future<T?> showCustom<T>(
    BuildContext context, {
    String? title,
    Widget? content,
    List<Widget>? actions,
    bool showCloseButton = true,
    VoidCallback? onClose,
    EdgeInsetsGeometry? contentPadding,
    double? maxHeight,
    bool isScrollable = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BaseSheet(
        title: title,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
        onClose: onClose,
        contentPadding: contentPadding,
        maxHeight: maxHeight,
        isScrollable: isScrollable,
      ),
    );
  }
}
