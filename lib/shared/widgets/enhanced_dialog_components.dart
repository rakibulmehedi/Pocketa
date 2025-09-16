import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/colors.dart';
import 'package:pocketa/core/theme/text_styles.dart';

/// Enhanced dialog components with consistent styling and responsive design
class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final double? maxWidth;
  final EdgeInsetsGeometry? contentPadding;

  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.maxWidth,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: layout.borderRadiusL,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? layout.responsiveSize(
            phone: double.infinity,
            tablet: 400,
            desktop: 500,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || showCloseButton) _buildHeader(context, layout, theme),
            Padding(
              padding: contentPadding ?? layout.paddingL,
              child: content,
            ),
            if (actions != null) _buildActions(context, layout, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLayout layout, ThemeData theme) {
    return Container(
      padding: layout.paddingL,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: layout.borderRadiusL,
          topRight: layout.borderRadiusL,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: AppTextStyles.headlineSmall(context),
              ),
            ),
          if (showCloseButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLayout layout, ThemeData theme) {
    return Container(
      padding: layout.paddingL,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: layout.borderRadiusL,
          bottomRight: layout.borderRadiusL,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      ),
    );
  }
}

/// Confirmation dialog with customizable actions
class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return AppDialog(
      title: title,
      content: Text(
        message,
        style: AppTextStyles.bodyLarge(context),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: TextStyle(
              color: cancelColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(width: layout.spacingS),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Loading dialog with progress indicator
class AppLoadingDialog extends StatelessWidget {
  final String message;
  final bool isDismissible;

  const AppLoadingDialog({
    super.key,
    this.message = 'Loading...',
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: AppDialog(
        showCloseButton: isDismissible,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: layout.spacingM),
            Text(
              message,
              style: AppTextStyles.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet with consistent styling
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showDragHandle;
  final double? maxHeight;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showDragHandle = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: layout.borderRadiusL,
          topRight: layout.borderRadiusL,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _buildDragHandle(theme, layout),
          if (title != null) _buildTitle(context, layout, theme),
          Flexible(
            child: SingleChildScrollView(
              padding: layout.paddingL,
              child: content,
            ),
          ),
          if (actions != null) _buildActions(context, layout, theme),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme, AppLayout layout) {
    return Container(
      margin: EdgeInsets.only(top: layout.spacingM),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, AppLayout layout, ThemeData theme) {
    return Container(
      padding: layout.paddingL,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: AppTextStyles.headlineSmall(context),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLayout layout, ThemeData theme) {
    return Container(
      padding: layout.paddingL,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: layout.borderRadiusM,
          topRight: layout.borderRadiusM,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      ),
    );
  }
}

/// Snackbar with enhanced styling
class AppSnackbar extends StatelessWidget {
  final String message;
  final AppSnackbarType type;
  final Duration duration;
  final VoidCallback? action;
  final String? actionLabel;

  const AppSnackbar({
    super.key,
    required this.message,
    this.type = AppSnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.action,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return SnackBar(
      content: Text(
        message,
        style: AppTextStyles.bodyMedium(context).copyWith(
          color: _getTextColor(theme),
        ),
      ),
      backgroundColor: _getBackgroundColor(theme),
      duration: duration,
      action: action != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel!,
              onPressed: action!,
              textColor: _getTextColor(theme),
            )
          : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: layout.borderRadiusM,
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (type) {
      case AppSnackbarType.success:
        return Colors.green;
      case AppSnackbarType.error:
        return Colors.red;
      case AppSnackbarType.warning:
        return Colors.orange;
      case AppSnackbarType.info:
        return theme.colorScheme.primary;
    }
  }

  Color _getTextColor(ThemeData theme) {
    switch (type) {
      case AppSnackbarType.success:
      case AppSnackbarType.error:
      case AppSnackbarType.warning:
      case AppSnackbarType.info:
        return Colors.white;
    }
  }
}

/// Snackbar types enum
enum AppSnackbarType {
  success,
  error,
  warning,
  info,
}
