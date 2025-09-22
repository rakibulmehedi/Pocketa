import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flow/core/theme/app_colors.dart';

/// Snackbar types for different message categories
enum AppSnackbarType { success, error, warning, info }

/// Enhanced snackbar service with premium features and better integration
class SnackbarService {
  static const Duration _defaultDuration = Duration(seconds: 3);
  static const Duration _errorDuration = Duration(seconds: 4);
  static const Duration _successDuration = Duration(seconds: 2);
  
  /// Show success snackbar with premium styling and haptic feedback
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _successDuration,
    bool enableHaptic = true,
    bool showCloseButton = true,
  }) {
    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }
    
    _show(
      context,
      message: message,
      type: AppSnackbarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
      enableHaptic: enableHaptic,
    );
  }

  /// Show error snackbar with premium styling and haptic feedback
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _errorDuration,
    bool enableHaptic = true,
    bool showCloseButton = true,
  }) {
    if (enableHaptic) {
      HapticFeedback.heavyImpact();
    }
    
    _show(
      context,
      message: message,
      type: AppSnackbarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
      enableHaptic: enableHaptic,
    );
  }

  /// Show warning snackbar with premium styling and haptic feedback
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
    bool enableHaptic = true,
    bool showCloseButton = true,
  }) {
    if (enableHaptic) {
      HapticFeedback.mediumImpact();
    }
    
    _show(
      context,
      message: message,
      type: AppSnackbarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
      enableHaptic: enableHaptic,
    );
  }

  /// Show info snackbar with premium styling and haptic feedback
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
    bool enableHaptic = true,
    bool showCloseButton = true,
  }) {
    if (enableHaptic) {
      HapticFeedback.selectionClick();
    }
    
    _show(
      context,
      message: message,
      type: AppSnackbarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      showCloseButton: showCloseButton,
      enableHaptic: enableHaptic,
    );
  }

  /// Show custom snackbar with premium styling and haptic feedback
  static void showCustom(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
    IconData? icon,
    bool showCloseButton = true,
    bool enableHaptic = true,
  }) {
    if (enableHaptic) {
      _getHapticForType(type);
    }
    
    _show(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
      showCloseButton: showCloseButton,
      enableHaptic: enableHaptic,
    );
  }

  /// Private method to show snackbar with enhanced features
  static void _show(
    BuildContext context, {
    required String message,
    required AppSnackbarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
    IconData? icon,
    bool showCloseButton = true,
    bool enableHaptic = true,
  }) {
    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new premium snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          message: message,
          type: type,
          actionLabel: actionLabel,
          action: onAction,
          enableHaptic: enableHaptic,
        ),
        backgroundColor: _getBackgroundColor(context, type),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Build snackbar content widget
  static Widget _buildSnackbarContent({
    required BuildContext context,
    required String message,
    required AppSnackbarType type,
    String? actionLabel,
    VoidCallback? action,
    bool enableHaptic = true,
  }) {
    return Row(
      children: [
        Icon(
          _getIcon(type),
          color: AppColors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (action != null && actionLabel != null) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: action,
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Get icon for snackbar type
  static IconData _getIcon(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return Icons.check_circle_outline;
      case AppSnackbarType.error:
        return Icons.error_outline;
      case AppSnackbarType.warning:
        return Icons.warning_outlined;
      case AppSnackbarType.info:
        return Icons.info_outline;
    }
  }

  /// Get background color for snackbar type
  static Color _getBackgroundColor(BuildContext context, AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return AppColors.success(context);
      case AppSnackbarType.error:
        return AppColors.error(context);
      case AppSnackbarType.warning:
        return AppColors.warning(context);
      case AppSnackbarType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  /// Get appropriate haptic feedback for snackbar type
  static void _getHapticForType(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        HapticFeedback.lightImpact();
        break;
      case AppSnackbarType.error:
        HapticFeedback.heavyImpact();
        break;
      case AppSnackbarType.warning:
        HapticFeedback.mediumImpact();
        break;
      case AppSnackbarType.info:
        HapticFeedback.selectionClick();
        break;
    }
  }

  // ============================================================================
  // CONVENIENCE METHODS FOR COMMON USE CASES
  // ============================================================================

  /// Show transaction added success with premium feedback
  static void showTransactionAdded(BuildContext context) {
    showSuccess(
      context,
      message: 'Transaction added successfully',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show transaction updated success with premium feedback
  static void showTransactionUpdated(BuildContext context) {
    showSuccess(
      context,
      message: 'Transaction updated successfully',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show transaction deleted info with premium feedback
  static void showTransactionDeleted(BuildContext context) {
    showInfo(
      context,
      message: 'Transaction deleted',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show wallet added success with premium feedback
  static void showWalletAdded(BuildContext context) {
    showSuccess(
      context,
      message: 'Wallet added successfully',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show wallet updated success with premium feedback
  static void showWalletUpdated(BuildContext context) {
    showSuccess(
      context,
      message: 'Wallet updated successfully',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show wallet deleted info with premium feedback
  static void showWalletDeleted(BuildContext context) {
    showInfo(
      context,
      message: 'Wallet deleted',
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  /// Show generic error with premium feedback
  static void showGenericError(BuildContext context) {
    showError(
      context,
      message: 'Something went wrong. Please try again.',
      duration: _errorDuration,
      enableHaptic: true,
    );
  }

  /// Show network error with premium feedback
  static void showNetworkError(BuildContext context) {
    showError(
      context,
      message: 'Network error. Please check your connection.',
      duration: _errorDuration,
      enableHaptic: true,
    );
  }

  /// Show validation error with premium feedback
  static void showValidationError(BuildContext context, String message) {
    showWarning(
      context,
      message: message,
      duration: _defaultDuration,
      enableHaptic: true,
    );
  }

  /// Show feature info with premium feedback
  static void showFeatureInfo(BuildContext context, String message) {
    showInfo(
      context,
      message: message,
      duration: _successDuration,
      enableHaptic: true,
    );
  }

  // ============================================================================
  // PREMIUM FEATURES
  // ============================================================================

  /// Show snackbar with custom action and premium styling
  static void showWithAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = _defaultDuration,
    bool enableHaptic = true,
  }) {
    _show(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  /// Show snackbar with retry action
  static void showWithRetry(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
    AppSnackbarType type = AppSnackbarType.error,
    Duration duration = _errorDuration,
    bool enableHaptic = true,
  }) {
    showWithAction(
      context,
      message: message,
      actionLabel: 'Retry',
      onAction: onRetry,
      type: type,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  /// Show snackbar with undo action
  static void showWithUndo(
    BuildContext context, {
    required String message,
    required VoidCallback onUndo,
    Duration duration = _defaultDuration,
    bool enableHaptic = true,
  }) {
    showWithAction(
      context,
      message: message,
      actionLabel: 'Undo',
      onAction: onUndo,
      type: AppSnackbarType.info,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  /// Show snackbar with dismiss action
  static void showWithDismiss(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = _defaultDuration,
    bool enableHaptic = true,
  }) {
    showWithAction(
      context,
      message: message,
      actionLabel: 'Dismiss',
      onAction: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      type: type,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  /// Show snackbar with custom duration and haptic feedback
  static void showCustomDuration(
    BuildContext context, {
    required String message,
    required Duration duration,
    AppSnackbarType type = AppSnackbarType.info,
    bool enableHaptic = true,
  }) {
    _show(
      context,
      message: message,
      type: type,
      duration: duration,
      enableHaptic: enableHaptic,
    );
  }

  /// Show snackbar without haptic feedback (for silent notifications)
  static void showSilent(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = _defaultDuration,
  }) {
    _show(
      context,
      message: message,
      type: type,
      duration: duration,
      enableHaptic: false,
    );
  }

  /// Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Clear all snackbars
  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
