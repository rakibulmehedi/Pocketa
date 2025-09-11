import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/core/error_handling/error_handler.dart';
import 'package:pocketa/core/errors/failure.dart';

/// Advanced error recovery system with retry mechanisms and fallback strategies
class ErrorRecovery {
  static final Logger _logger = Logger();
  static final Map<String, int> _retryCounts = {};
  static final Map<String, DateTime> _lastRetryTimes = {};
  
  /// Maximum retry attempts for different error types
  static final Map<Type, int> _maxRetries = {
    NetworkFailure: 3,
    DatabaseFailure: 2,
    CacheFailure: 1,
  };

  /// Retry delays for different error types (in milliseconds)
  static final Map<Type, List<int>> _retryDelays = {
    NetworkFailure: [1000, 2000, 4000], // Exponential backoff
    DatabaseFailure: [500, 1000],
    CacheFailure: [100],
  };

  /// Get max retries for an operation based on error type
  static int _getMaxRetries(String operationName) {
    // Default to 3 retries if we can't determine the error type
    return 3;
  }

  /// Get retry delays for an operation based on error type
  static List<int> _getRetryDelays(String operationName) {
    // Default to exponential backoff if we can't determine the error type
    return [1000, 2000, 4000];
  }

  /// Retry an operation with exponential backoff
  static Future<T?> retryOperation<T>(
    Future<T> Function() operation,
    String operationName, {
    int? maxRetries,
    List<int>? retryDelays,
    bool Function(Exception)? shouldRetry,
    VoidCallback? onRetry,
    VoidCallback? onMaxRetriesReached,
  }) async {
    final retries = maxRetries ?? _getMaxRetries(operationName);
    final delays = retryDelays ?? _getRetryDelays(operationName);
    
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final result = await operation();
        _resetRetryCount(operationName);
        return result;
      } catch (e) {
        final exception = e is Exception ? e : Exception(e.toString());
        
        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(exception)) {
          _logger.w('Operation $operationName failed with non-retryable error: $e');
          rethrow;
        }
        
        // Check if we've exceeded max retries
        if (attempt >= retries) {
          _logger.e('Operation $operationName failed after $retries retries: $e');
          onMaxRetriesReached?.call();
          rethrow;
        }
        
        // Wait before retrying
        final delay = attempt < delays.length 
            ? delays[attempt] 
            : delays.last;
        
        _logger.w('Operation $operationName failed (attempt ${attempt + 1}/$retries), retrying in ${delay}ms: $e');
        _incrementRetryCount(operationName);
        onRetry?.call();
        
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
    
    return null;
  }

  /// Retry with circuit breaker pattern
  static Future<T?> retryWithCircuitBreaker<T>(
    Future<T> Function() operation,
    String operationName, {
    int failureThreshold = 5,
    Duration timeout = const Duration(minutes: 1),
    T? fallbackValue,
  }) async {
    final now = DateTime.now();
    final lastFailure = _lastRetryTimes[operationName];
    
    // Check if circuit is open (too many recent failures)
    if (lastFailure != null && 
        now.difference(lastFailure) < timeout &&
        _retryCounts[operationName]! >= failureThreshold) {
      _logger.w('Circuit breaker open for $operationName, using fallback');
      return fallbackValue;
    }
    
    try {
      final result = await operation();
      _resetRetryCount(operationName);
      return result;
    } catch (e) {
      _incrementRetryCount(operationName);
      _lastRetryTimes[operationName] = now;
      
      if (_retryCounts[operationName]! >= failureThreshold) {
        _logger.e('Circuit breaker opened for $operationName after ${_retryCounts[operationName]} failures');
        return fallbackValue;
      }
      
      rethrow;
    }
  }

  /// Retry with different strategies based on error type
  static Future<T?> retryWithStrategy<T>(
    Future<T> Function() operation,
    String operationName,
    BuildContext context, {
    T? fallbackValue,
  }) async {
    return await retryOperation<T>(
      operation,
      operationName,
      shouldRetry: (exception) => _shouldRetryError(exception),
      onRetry: () => _showRetryNotification(context, operationName),
      onMaxRetriesReached: () => _showMaxRetriesNotification(context, operationName),
    );
  }

  /// Handle network errors with offline fallback
  static Future<T?> handleNetworkError<T>(
    Future<T> Function() onlineOperation,
    Future<T> Function() offlineOperation,
    String operationName,
    BuildContext context,
  ) async {
    try {
      return await onlineOperation();
    } on NetworkFailure catch (e) {
      _logger.w('Network error for $operationName, trying offline operation: $e');
      
      try {
        return await offlineOperation();
      } catch (offlineError) {
        _logger.e('Offline operation also failed for $operationName: $offlineError');
        ErrorHandler.handleError(
          context,
          e,
          message: 'Unable to complete operation. Please check your connection.',
        );
        return null;
      }
    }
  }

  /// Graceful degradation for non-critical operations
  static Future<T?> gracefulDegradation<T>(
    Future<T> Function() primaryOperation,
    Future<T> Function() fallbackOperation,
    String operationName,
    BuildContext context, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      return await primaryOperation().timeout(timeout);
    } catch (e) {
      _logger.w('Primary operation failed for $operationName, trying fallback: $e');
      
      try {
        return await fallbackOperation();
      } catch (fallbackError) {
        _logger.e('Fallback operation also failed for $operationName: $fallbackError');
        ErrorHandler.handleError(
          context,
          e,
          message: 'Operation completed with limited functionality.',
        );
        return null;
      }
    }
  }

  /// Reset retry count for an operation
  static void _resetRetryCount(String operationName) {
    _retryCounts.remove(operationName);
    _lastRetryTimes.remove(operationName);
  }

  /// Increment retry count for an operation
  static void _incrementRetryCount(String operationName) {
    _retryCounts[operationName] = (_retryCounts[operationName] ?? 0) + 1;
  }

  /// Check if an error should be retried
  static bool _shouldRetryError(Exception exception) {
    if (exception is NetworkFailure) return true;
    if (exception is DatabaseFailure) return true;
    if (exception is CacheFailure) return true;
    return false;
  }

  /// Show retry notification to user
  static void _showRetryNotification(BuildContext context, String operationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Retrying $operationName...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show max retries notification to user
  static void _showMaxRetriesNotification(BuildContext context, String operationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$operationName failed after multiple attempts'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Clear all retry data
  static void clearRetryData() {
    _retryCounts.clear();
    _lastRetryTimes.clear();
  }
}
