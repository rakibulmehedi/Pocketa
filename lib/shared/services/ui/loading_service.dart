import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/shared/services/ui/snackbar_service.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// Simple loading service for managing loading states with premium UX
class LoadingService {
  static final Map<String, OverlayEntry> _overlays = {};
  static final Map<String, bool> _loadingStates = {};

  /// Show loading overlay with simple API
  static void show(
    BuildContext context, {
    String? key,
    String message = 'Loading...',
    bool dismissible = false,
    Duration? timeout,
    VoidCallback? onTimeout,
  }) {
    final loadingKey = key ?? 'default';
    
    // Hide existing loading if any
    hide(context, key: loadingKey);
    
    // Set loading state
    _loadingStates[loadingKey] = true;
    
    // Create overlay entry
    final overlay = OverlayEntry(
      builder: (context) => _LoadingOverlay(
        message: message,
        dismissible: dismissible,
        onDismiss: () => hide(context, key: loadingKey),
        timeout: timeout,
        onTimeout: onTimeout,
      ),
    );
    
    // Insert overlay
    Overlay.of(context).insert(overlay);
    _overlays[loadingKey] = overlay;
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  /// Hide loading overlay
  static void hide(BuildContext context, {String? key}) {
    final loadingKey = key ?? 'default';
    
    if (_overlays.containsKey(loadingKey)) {
      _overlays[loadingKey]?.remove();
      _overlays.remove(loadingKey);
    }
    
    _loadingStates[loadingKey] = false;
  }

  /// Check if loading is active
  static bool isLoading({String? key}) {
    return _loadingStates[key ?? 'default'] ?? false;
  }

  /// Show loading with success feedback
  static Future<void> showWithSuccess(
    BuildContext context, {
    String? key,
    required Future<void> Function() operation,
    String loadingMessage = 'Loading...',
    String successMessage = 'Success!',
    Duration successDuration = const Duration(seconds: 2),
  }) async {
    show(context, key: key, message: loadingMessage);
    
    try {
      await operation();
      hide(context, key: key);
      SnackbarService.showSuccess(
        context,
        message: successMessage,
        duration: successDuration,
      );
    } catch (e) {
      hide(context, key: key);
      SnackbarService.showError(
        context,
        message: 'Operation failed. Please try again.',
      );
    }
  }

  /// Show loading with error handling
  static Future<T?> showWithErrorHandling<T>(
    BuildContext context, {
    String? key,
    required Future<T> Function() operation,
    String loadingMessage = 'Loading...',
    String? errorMessage,
    VoidCallback? onError,
  }) async {
    show(context, key: key, message: loadingMessage);
    
    try {
      final result = await operation();
      hide(context, key: key);
      return result;
    } catch (e) {
      hide(context, key: key);
      
      if (onError != null) {
        onError();
      } else {
        SnackbarService.showError(
          context,
          message: errorMessage ?? 'Something went wrong. Please try again.',
        );
      }
      return null;
    }
  }

  /// Show loading with retry functionality
  static Future<void> showWithRetry(
    BuildContext context, {
    String? key,
    required Future<void> Function() operation,
    String loadingMessage = 'Loading...',
    String retryMessage = 'Failed to load. Tap to retry.',
  }) async {
    show(context, key: key, message: loadingMessage);
    
    try {
      await operation();
      hide(context, key: key);
    } catch (e) {
      hide(context, key: key);
      
      SnackbarService.showWithRetry(
        context,
        message: retryMessage,
        onRetry: () => showWithRetry(
          context,
          key: key,
          operation: operation,
          loadingMessage: loadingMessage,
          retryMessage: retryMessage,
        ),
      );
    }
  }

  /// Clear all loading overlays
  static void clearAll(BuildContext context) {
    for (final entry in _overlays.values) {
      entry.remove();
    }
    _overlays.clear();
    _loadingStates.clear();
  }
}

/// Simple loading overlay widget
class _LoadingOverlay extends StatefulWidget {
  final String message;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final Duration? timeout;
  final VoidCallback? onTimeout;

  const _LoadingOverlay({
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.timeout,
    this.onTimeout,
  });

  @override
  State<_LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<_LoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    // Handle timeout
    if (widget.timeout != null) {
      Future.delayed(widget.timeout!, () {
        if (mounted) {
          widget.onTimeout?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black.withValues(alpha: 0.5),
      child: GestureDetector(
        onTap: widget.dismissible ? widget.onDismiss : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          widget.message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (widget.dismissible) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Tap to dismiss',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
