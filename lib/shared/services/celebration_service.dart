import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/feature_flags.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/shared/motion/confetti_v2.dart';
import 'package:pocketa/shared/services/sound_service.dart';
import 'package:pocketa/shared/services/sound_preloader.dart';

/// Celebration events that can be triggered
enum CelebrationEvent {
  onboardingComplete,
  firstTransaction,
  budgetMilestone,
  streakComplete,
  easterEgg,
}

/// Premium Celebration Service for Pocketa
/// 
/// Features:
/// - Enhanced UX with sound + haptic + visual coordination
/// - Accessibility-first design
/// - Performance optimization with preloading
/// - Smart debouncing and error handling
class CelebrationService {
  static final SoundService _soundService = SoundService();
  static final SoundPreloader _soundPreloader = SoundPreloader();
  static final Map<String, DateTime> _lastCelebration = {};
  static const Duration _debounceTime = Duration(milliseconds: 200); // Faster response

  /// Initialize the celebration service with preloading
  static Future<void> initialize() async {
    await _soundService.initialize();
    
    // Start preloading sounds in background for better UX
    _soundPreloader.preloadAllSounds();
  }

  /// Get preloading status for UI feedback
  static Map<String, dynamic> getPreloadingStatus() {
    return _soundPreloader.getStatus();
  }

  /// Trigger a celebration with debouncing
  static Future<void> triggerCelebration(
    BuildContext context,
    CelebrationEvent event, {
    Map<String, dynamic>? metadata,
    WidgetRef? ref,
  }) async {
    // Check feature flag
    if (!FeatureFlags.kEnableCelebrationV2) return;

    // Debounce celebrations
    final now = DateTime.now();
    final lastTime = _lastCelebration[event.name];
    if (lastTime != null && now.difference(lastTime) < _debounceTime) {
      return;
    }
    _lastCelebration[event.name] = now;

    // Get preferences
    final preferences = ref?.read(celebrationPreferencesProvider) ?? const CelebrationPreferences();

    // Determine celebration style
    final style = _getStyleForEvent(event);
    final soundType = _getSoundTypeForEvent(event);

    // Enhanced sound + haptic coordination for premium UX
    if (FeatureFlags.kEnableCelebrationSounds && preferences.enableCelebrationSound) {
      try {
        // Use enhanced sound service with haptic coordination
        final hapticType = _getHapticTypeForEvent(event);
        await _soundService.playCelebrationSoundWithHaptic(soundType, hapticType);
      } catch (e) {
        if (kDebugMode) {
          print('🔊 Sound playback failed: $e');
        }
        // Fallback to haptic only
        if (FeatureFlags.kEnableCelebrationHaptics && preferences.enableHaptics) {
          _playHapticForEvent(event);
        }
      }
    } else if (FeatureFlags.kEnableCelebrationHaptics && preferences.enableHaptics) {
      // Play haptic only if sound is disabled
      _playHapticForEvent(event);
    }

    // Show confetti if enabled
    if (FeatureFlags.kEnableCelebrationConfetti && preferences.enableConfetti) {
      await ConfettiOverlay.show(
        context,
        style: style,
        onComplete: () {
          _showCelebrationMessage(context, event, metadata);
        },
      );
    } else {
      // Show message even without confetti
      _showCelebrationMessage(context, event, metadata);
    }
  }

  /// Quick celebration without service overhead
  static Future<void> quickCelebration(
    BuildContext context,
    ConfettiStyle style, {
    String? message,
    WidgetRef? ref,
  }) async {
    if (!FeatureFlags.kEnableCelebrationV2) return;

    final preferences = ref?.read(celebrationPreferencesProvider) ?? const CelebrationPreferences();

    // Play haptic if enabled
    if (FeatureFlags.kEnableCelebrationHaptics && preferences.enableHaptics) {
      _playHapticForStyle(style);
    }

    // Show confetti if enabled
    if (FeatureFlags.kEnableCelebrationConfetti && preferences.enableConfetti) {
      await ConfettiOverlay.show(
        context,
        style: style,
        onComplete: () {
          if (message != null) {
            _showToast(context, message);
          }
        },
      );
    } else if (message != null) {
      _showToast(context, message);
    }
  }

  /// Safe celebration that handles errors gracefully
  static Future<void> safeCelebrate(
    BuildContext context,
    CelebrationEvent event, {
    Map<String, dynamic>? metadata,
    WidgetRef? ref,
  }) async {
    try {
      await triggerCelebration(context, event, metadata: metadata, ref: ref);
    } catch (e) {
      if (kDebugMode) {
        print('🎉 Celebration failed: $e');
      }
      // Silently fail - celebrations are not critical
    }
  }

  /// Get confetti style for event
  static ConfettiStyle _getStyleForEvent(CelebrationEvent event) {
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        return ConfettiStyle.achievement;
      case CelebrationEvent.firstTransaction:
        return ConfettiStyle.reward;
      case CelebrationEvent.budgetMilestone:
        return ConfettiStyle.milestone;
      case CelebrationEvent.streakComplete:
        return ConfettiStyle.victory;
      case CelebrationEvent.easterEgg:
        return ConfettiStyle.celebration;
    }
  }

  /// Get sound type for event
  static String _getSoundTypeForEvent(CelebrationEvent event) {
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        return 'achievement';
      case CelebrationEvent.firstTransaction:
        return 'reward';
      case CelebrationEvent.budgetMilestone:
        return 'milestone';
      case CelebrationEvent.streakComplete:
        return 'victory';
      case CelebrationEvent.easterEgg:
        return 'celebration';
    }
  }

  /// Get haptic type for event (enhanced UX coordination)
  static HapticFeedbackType _getHapticTypeForEvent(CelebrationEvent event) {
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        return HapticFeedbackType.medium; // Significant achievement
      case CelebrationEvent.firstTransaction:
        return HapticFeedbackType.light; // Positive action
      case CelebrationEvent.budgetMilestone:
        return HapticFeedbackType.heavy; // Major milestone
      case CelebrationEvent.streakComplete:
        return HapticFeedbackType.heavy; // Major achievement
      case CelebrationEvent.easterEgg:
        return HapticFeedbackType.medium; // Surprise discovery
    }
  }

  /// Play haptic feedback for event
  static void _playHapticForEvent(CelebrationEvent event) {
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        HapticFeedback.lightImpact();
        break;
      case CelebrationEvent.firstTransaction:
        HapticFeedback.lightImpact();
        break;
      case CelebrationEvent.budgetMilestone:
        HapticFeedback.heavyImpact();
        break;
      case CelebrationEvent.streakComplete:
        HapticFeedback.heavyImpact();
        break;
      case CelebrationEvent.easterEgg:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  /// Play haptic feedback for style
  static void _playHapticForStyle(ConfettiStyle style) {
    switch (style) {
      case ConfettiStyle.achievement:
        HapticFeedback.lightImpact();
        break;
      case ConfettiStyle.celebration:
        HapticFeedback.mediumImpact();
        break;
      case ConfettiStyle.reward:
        HapticFeedback.lightImpact();
        break;
      case ConfettiStyle.milestone:
        HapticFeedback.heavyImpact();
        break;
      case ConfettiStyle.victory:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  /// Show celebration message
  static void _showCelebrationMessage(
    BuildContext context,
    CelebrationEvent event,
    Map<String, dynamic>? metadata,
  ) {
    final message = _getMessageForEvent(event, metadata);
    if (message != null) {
      _showToast(context, message);
    }
  }

  /// Get enhanced message for event with better UX
  static String? _getMessageForEvent(CelebrationEvent event, Map<String, dynamic>? metadata) {
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        return 'Welcome to Pocketa! 🎉\nYour financial journey starts now!';
      case CelebrationEvent.firstTransaction:
        return 'First transaction logged! 💰\nGreat start to tracking your finances!';
      case CelebrationEvent.budgetMilestone:
        final percentage = metadata?['percentage'] as int?;
        return percentage != null 
          ? 'Budget milestone reached! 🎯\n${percentage}% of your budget used!'
          : 'Budget milestone reached! 🎯\nYou\'re doing great!';
      case CelebrationEvent.streakComplete:
        final days = metadata?['days'] as int?;
        if (days != null) {
          if (days >= 30) {
            return '$days day streak! 🔥\nYou\'re a financial champion!';
          } else if (days >= 7) {
            return '$days day streak! 🔥\nKeep up the great work!';
          } else {
            return '$days day streak! 🔥\nBuilding momentum!';
          }
        }
        return 'Streak complete! 🔥\nConsistency is key!';
      case CelebrationEvent.easterEgg:
        return 'Easter egg discovered! 🥚\nYou found a hidden feature!';
    }
  }

  /// Show enhanced toast message with better UX
  static void _showToast(BuildContext context, String message) {
    final lines = message.split('\n');
    final isMultiLine = lines.length > 1;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMultiLine) ...[
              Text(
                lines[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lines[1],
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ] else
              Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
        duration: Duration(seconds: isMultiLine ? 3 : 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 8,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Dispose resources
  static Future<void> dispose() async {
    await _soundService.dispose();
  }
}
