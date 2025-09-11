import 'package:flutter/material.dart';
import 'package:pocketa/shared/widgets/custom_snackbar.dart';

class SnackbarService {
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool showCloseButton = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackbarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
    );
  }

  static void showCustom(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    bool showCloseButton = true,
  }) {
    _show(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
      showCloseButton: showCloseButton,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    bool showCloseButton = true,
  }) {
    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new custom snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackbar(
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration,
          icon: icon,
          showCloseButton: showCloseButton,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Convenience methods for common use cases
  static void showTransactionAdded(BuildContext context) {
    showSuccess(
      context,
      message: 'Transaction added successfully',
      duration: const Duration(seconds: 2),
    );
  }

  static void showTransactionUpdated(BuildContext context) {
    showSuccess(
      context,
      message: 'Transaction updated successfully',
      duration: const Duration(seconds: 2),
    );
  }

  static void showTransactionDeleted(BuildContext context) {
    showInfo(
      context,
      message: 'Transaction deleted',
      duration: const Duration(seconds: 2),
    );
  }

  static void showWalletAdded(BuildContext context) {
    showSuccess(
      context,
      message: 'Wallet added successfully',
      duration: const Duration(seconds: 2),
    );
  }

  static void showWalletUpdated(BuildContext context) {
    showSuccess(
      context,
      message: 'Wallet updated successfully',
      duration: const Duration(seconds: 2),
    );
  }

  static void showWalletDeleted(BuildContext context) {
    showInfo(
      context,
      message: 'Wallet deleted',
      duration: const Duration(seconds: 2),
    );
  }

  static void showGenericError(BuildContext context) {
    showError(
      context,
      message: 'Something went wrong. Please try again.',
      duration: const Duration(seconds: 4),
    );
  }

  static void showNetworkError(BuildContext context) {
    showError(
      context,
      message: 'Network error. Please check your connection.',
      duration: const Duration(seconds: 4),
    );
  }

  static void showValidationError(BuildContext context, String message) {
    showWarning(
      context,
      message: message,
      duration: const Duration(seconds: 3),
    );
  }

  static void showFeatureInfo(BuildContext context, String message) {
    showInfo(
      context,
      message: message,
      duration: const Duration(seconds: 2),
    );
  }
}
