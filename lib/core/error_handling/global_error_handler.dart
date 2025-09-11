import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Global error handler for the entire application
class GlobalErrorHandler {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  static final List<ErrorHandler> _handlers = [];
  static final StreamController<AppError> _errorController = 
      StreamController<AppError>.broadcast();

  /// Stream of all errors in the application
  static Stream<AppError> get errorStream => _errorController.stream;

  /// Initialize global error handling
  static void initialize() {
    if (_isInitialized) return;
    
    _isInitialized = true;
    
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleAsyncError(error, stack);
      return true;
    };

    // Handle isolate errors
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        _handleIsolateError(errorAndStacktrace[0], errorAndStacktrace[1]);
      }).sendPort,
    );

    _logger.d('Global error handler initialized');
  }

  /// Add a custom error handler
  static void addHandler(ErrorHandler handler) {
    _handlers.add(handler);
  }

  /// Remove a custom error handler
  static void removeHandler(ErrorHandler handler) {
    _handlers.remove(handler);
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    final error = AppError(
      type: ErrorType.flutter,
      message: details.exception.toString(),
      stackTrace: details.stack,
      context: details.context?.toString(),
      library: details.library,
    );

    _logError(error);
    _notifyHandlers(error);
    emitError(error);
  }

  /// Handle async errors
  static void _handleAsyncError(Object error, StackTrace stackTrace) {
    final appError = AppError(
      type: ErrorType.async,
      message: error.toString(),
      stackTrace: stackTrace,
    );

    _logError(appError);
    _notifyHandlers(appError);
    emitError(appError);
  }

  /// Handle isolate errors
  static void _handleIsolateError(Object error, StackTrace stackTrace) {
    final appError = AppError(
      type: ErrorType.isolate,
      message: error.toString(),
      stackTrace: stackTrace,
    );

    _logError(appError);
    _notifyHandlers(appError);
    emitError(appError);
  }

  /// Log error with appropriate level
  static void _logError(AppError error) {
    switch (error.severity) {
      case ErrorSeverity.low:
        _logger.d('Error: ${error.message}', error: error.exception, stackTrace: error.stackTrace);
        break;
      case ErrorSeverity.medium:
        _logger.w('Error: ${error.message}', error: error.exception, stackTrace: error.stackTrace);
        break;
      case ErrorSeverity.high:
        _logger.e('Error: ${error.message}', error: error.exception, stackTrace: error.stackTrace);
        break;
      case ErrorSeverity.critical:
        _logger.f('Critical Error: ${error.message}', error: error.exception, stackTrace: error.stackTrace);
        break;
    }
  }

  /// Notify all registered handlers
  static void _notifyHandlers(AppError error) {
    for (final handler in _handlers) {
      try {
        handler.handleError(error);
      } catch (e) {
        _logger.e('Error in error handler: $e');
      }
    }
  }

  /// Emit error to stream
  static void emitError(AppError error) {
    if (!_errorController.isClosed) {
      _errorController.add(error);
    }
  }

  /// Handle error with recovery
  static Future<T?> handleWithRecovery<T>(
    Future<T> Function() operation,
    String operationName, {
    T? fallbackValue,
    BuildContext? context,
  }) async {
    try {
      return await operation();
    } catch (e) {
      final error = AppError(
        type: ErrorType.operation,
        message: e.toString(),
        operation: operationName,
      );

      _logError(error);
      _notifyHandlers(error);
      emitError(error);

      return fallbackValue;
    }
  }

  /// Dispose resources
  static void dispose() {
    _errorController.close();
    _handlers.clear();
    _isInitialized = false;
  }
}

/// Application error representation
class AppError {
  final ErrorType type;
  final String message;
  final StackTrace? stackTrace;
  final String? context;
  final String? library;
  final String? operation;
  final DateTime timestamp;
  final ErrorSeverity severity;

  AppError({
    required this.type,
    required this.message,
    this.stackTrace,
    this.context,
    this.library,
    this.operation,
    DateTime? timestamp,
    this.severity = ErrorSeverity.medium,
  }) : timestamp = timestamp ?? DateTime.now();

  Object? get exception => this;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'message': message,
    'stackTrace': stackTrace?.toString(),
    'context': context,
    'library': library,
    'operation': operation,
    'timestamp': timestamp.toIso8601String(),
    'severity': severity.name,
  };
}

/// Error types
enum ErrorType {
  flutter,
  async,
  isolate,
  operation,
  network,
  database,
  cache,
  validation,
  unknown,
}

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Custom error handler interface
abstract class ErrorHandler {
  void handleError(AppError error);
}

