import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/core/errors/failure.dart';
import 'package:pocketa/core/result/result.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/services/snackbar_service.dart';

/// Centralized error handling service
class ErrorHandler {
  static final Logger _logger = Logger();
  
  /// Handle errors and show appropriate UI feedback
  static void handleError(
    BuildContext context,
    Object error, {
    String? message,
    VoidCallback? onRetry,
    bool showSnackbar = true,
  }) {
    // Log the error
    _logger.e('Error occurred: $error', error: error, stackTrace: StackTrace.current);
    
    if (!showSnackbar) return;
    
    final l10n = AppLocalizations.of(context);
    final String errorMessage = message ?? _getErrorMessage(error, l10n);
    
    // Show error snackbar with retry option if available
    SnackbarService.showError(
      context,
      message: errorMessage,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
    );
  }
  
  /// Handle Result errors
  static void handleResultError<T>(
    BuildContext context,
    Result<T> result, {
    String? message,
    VoidCallback? onRetry,
  }) {
    result.when(
      ok: (data) {}, // Do nothing on success
      err: (failure) => handleError(
        context,
        failure,
        message: message,
        onRetry: onRetry,
      ),
    );
  }
  
  /// Get user-friendly error message
  static String _getErrorMessage(Object error, AppLocalizations l10n) {
    if (error is CacheFailure) {
      return l10n.errorCache;
    } else if (error is DatabaseFailure) {
      return l10n.errorDatabase;
    } else if (error is NetworkFailure) {
      return l10n.errorNetwork;
    } else if (error is Failure) {
      return error.message.isNotEmpty ? error.message : l10n.errorGeneric;
    }
    
    // Handle specific error types
    if (error is FormatException) {
      return l10n.errorValidation;
    }
    
    if (error is StateError) {
      return l10n.errorGeneric;
    }
    
    // Default error message
    return l10n.errorGeneric;
  }
  
  /// Handle errors in async operations with proper context
  static Future<T?> handleAsync<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? errorMessage,
    VoidCallback? onRetry,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    try {
      final result = await operation();
      if (showLoading && context.mounted) {
        Navigator.of(context).pop(); // Hide loading
      }
      return result;
    } catch (error) {
      if (showLoading && context.mounted) {
        Navigator.of(context).pop(); // Hide loading
      }
      
      if (context.mounted) {
        handleError(
          context,
          error,
          message: errorMessage,
          onRetry: onRetry,
        );
      }
      return null;
    }
  }
  
  /// Handle errors in Riverpod providers
  static void handleProviderError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace, {
    String? message,
  }) {
    _logger.e(
      'Provider error: $error',
      error: error,
      stackTrace: stackTrace,
    );
    
    handleError(
      context,
      error,
      message: message,
    );
  }
  
  /// Handle errors in widgets with proper disposal
  static void handleWidgetError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace, {
    String? message,
    VoidCallback? onRetry,
  }) {
    _logger.e(
      'Widget error: $error',
      error: error,
      stackTrace: stackTrace,
    );
    
    // Only show error if widget is still mounted
    if (context.mounted) {
      handleError(
        context,
        error,
        message: message,
        onRetry: onRetry,
      );
    }
  }
}

/// Mixin for widgets that need error handling
mixin ErrorHandlingMixin<W extends StatefulWidget> on State<W> {
  void handleError(
    Object error, {
    String? message,
    VoidCallback? onRetry,
  }) {
    ErrorHandler.handleWidgetError(
      context,
      error,
      StackTrace.current,
      message: message,
      onRetry: onRetry,
    );
  }
  
  Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? errorMessage,
    VoidCallback? onRetry,
    bool showLoading = true,
  }) {
    return ErrorHandler.handleAsync(
      context,
      operation,
      errorMessage: errorMessage,
      onRetry: onRetry,
      showLoading: showLoading,
    );
  }
}

/// Global error handler for uncaught errors
class GlobalErrorHandler {
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // In production, log the error
        Logger().e(
          'Flutter error: ${details.exception}',
          error: details.exception,
          stackTrace: details.stack,
        );
      }
    };
    
    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      Logger().e(
        'Platform error: $error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }
}
