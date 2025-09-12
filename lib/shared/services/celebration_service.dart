// ──────────────────────────────────────────────────────────────────────────────
// Celebration Service - Pocketa Celebration System
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/feature_flags.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/shared/ui/motion/confetti.dart';
import 'package:pocketa/shared/ui/motion/motion.dart';
import 'package:pocketa/shared/services/sound_service.dart';

/// Celebration events for Pocketa
enum CelebrationEvent {
  onboardingComplete,
  firstTransaction,
  budgetMilestone,
  streakComplete,
  easterEgg,
}

/// Comprehensive celebration service with haptics, sound, and confetti
class CelebrationService {
  static bool _isInitialized = false;
  static DateTime? _lastCelebrationTime;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  /// Get optimized particle count for device size
  static int _getOptimizedParticleCount(BuildContext context, int baseCount) {
    final size = MediaQuery.of(context).size;
    return (size.width <= 360 || size.height <= 360) 
        ? (baseCount * 0.6).round() 
        : baseCount;
  }

  /// Initialize the celebration service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Sound service is already initialized in main.dart
    _isInitialized = true;
  }

  /// Safe celebration that respects user preferences and reduced motion
  static Future<void> safeCelebrate(
    BuildContext context, {
    required CelebrationEvent event,
    Map<String, dynamic>? metadata,
    WidgetRef? ref,
  }) async {
    // Check if celebrations are disabled via feature flag
    if (!FeatureFlags.kEnableCelebrationV2) return;
    
    // Performance check: avoid celebrations if context is not mounted
    if (!context.mounted) return;
    
    // Debounce: prevent rapid-fire celebrations
    final now = DateTime.now();
    if (_lastCelebrationTime != null && 
        now.difference(_lastCelebrationTime!) < _debounceDuration) {
      return;
    }
    _lastCelebrationTime = now;
    
    // Check reduced motion preference
    final prefersNoMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    
    // Get user preferences
    final preferences = ref?.read(celebrationPreferencesProvider) ?? 
        const CelebrationPreferences();
    
    // Early return if all celebration features are disabled
    if (!preferences.enableCelebrationSound && 
        !preferences.enableHaptics && 
        !preferences.enableConfetti) {
      return;
    }

    // Trigger celebration with reduced motion flag
    await triggerCelebration(
      context,
      event,
      metadata: metadata,
      ref: ref,
      reducedMotion: prefersNoMotion,
    );
  }

  /// Trigger celebration for specific event
  static Future<void> triggerCelebration(
    BuildContext context,
    CelebrationEvent event, {
    Map<String, dynamic>? metadata,
    WidgetRef? ref,
    bool reducedMotion = false,
  }) async {
    // Initialize if needed
    if (!_isInitialized) await initialize();
    
    // Store context values before async operations
    final isReduced = Motion.isReduced(context);
    final preferences = ref?.read(celebrationPreferencesProvider) ?? 
        const CelebrationPreferences();
    
    // Respect user preferences
    if (isReduced || reducedMotion) {
      return;
    }

    // Store context values before async operations
    final mounted = context.mounted;
    
    switch (event) {
      case CelebrationEvent.onboardingComplete:
        if (mounted) await _triggerOnboardingComplete(context, metadata, preferences);
        break;
      case CelebrationEvent.firstTransaction:
        if (mounted) await _triggerFirstTransaction(context, metadata, preferences);
        break;
      case CelebrationEvent.budgetMilestone:
        if (mounted) await _triggerBudgetMilestone(context, metadata, preferences);
        break;
      case CelebrationEvent.streakComplete:
        if (mounted) await _triggerStreakComplete(context, metadata, preferences);
        break;
      case CelebrationEvent.easterEgg:
        if (mounted) await _triggerEasterEgg(context, metadata, preferences);
        break;
    }
  }

  /// Onboarding Complete Celebration
  /// Event → Onboarding শেষ (Finish button)
  /// Style → ConfettiStyle.achievement
  /// Haptic → HapticFeedback.mediumImpact()
  /// Sound → ছোট success chime (assets/sounds/success.mp3)
  /// Goal → User প্রথমবার সফলভাবে শুরু করলো → হাসি + reward feel
  static Future<void> _triggerOnboardingComplete(
    BuildContext context,
    Map<String, dynamic>? metadata,
    CelebrationPreferences preferences,
  ) async {
    // Store context values before async operations
    final showMessage = metadata?['showMessage'] == true;
    final particleCount = _getOptimizedParticleCount(context, 45);
    final mounted = context.mounted;
    
    // Start with haptic feedback for immediate response
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      HapticFeedback.mediumImpact();
    }

    // Play sound with slight delay for better UX timing
    if (preferences.enableCelebrationSound && FeatureFlags.kEnableCelebrationSounds) {
      Future.delayed(Duration(milliseconds: 50), () {
        SoundService.playCelebrationSound(CelebrationEvent.onboardingComplete);
      });
    }
    
    // Confetti with staggered timing for premium feel
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          celebrate(
            context,
            style: ConfettiStyle.achievement,
            duration: const Duration(milliseconds: 2500),
            particleCount: particleCount,
          );
        }
      });
    }

    // Show success message with perfect timing
    if (showMessage && mounted) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) {
          _showSuccessMessage(context, 'Welcome to Pocketa! 🎉');
        }
      });
    }
  }

  /// First Transaction Celebration
  /// Event → প্রথম Transaction যোগ করলে
  /// Style → ConfettiStyle.reward
  /// Haptic → HapticFeedback.lightImpact()
  /// Sound → assets/sounds/cash.mp3
  /// Goal → টাকা এন্ট্রি করার achievement কে celebrate করা
  static Future<void> _triggerFirstTransaction(
    BuildContext context,
    Map<String, dynamic>? metadata,
    CelebrationPreferences preferences,
  ) async {
    // Store context values before async operations
    final showMessage = metadata?['showMessage'] == true;
    final particleCount = _getOptimizedParticleCount(context, 35);
    final mounted = context.mounted;
    
    // Start with haptic feedback for immediate response
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      HapticFeedback.lightImpact();
    }

    // Play sound with slight delay for better UX timing
    if (preferences.enableCelebrationSound && FeatureFlags.kEnableCelebrationSounds) {
      Future.delayed(Duration(milliseconds: 30), () {
        SoundService.playCelebrationSound(CelebrationEvent.firstTransaction);
      });
    }
    
    // Confetti with staggered timing for premium feel
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      Future.delayed(Duration(milliseconds: 80), () {
        if (mounted) {
          celebrate(
            context,
            style: ConfettiStyle.reward,
            duration: const Duration(milliseconds: 2000),
            particleCount: particleCount,
          );
        }
      });
    }

    // Show transaction success message with perfect timing
    if (showMessage && mounted) {
      Future.delayed(Duration(milliseconds: 150), () {
        if (mounted) {
          _showSuccessMessage(context, 'Transaction added! 💰');
        }
      });
    }
  }

  /// Budget Milestone Celebration
  /// Event → Budget target এ পৌঁছানো বা target save complete
  /// Style → ConfettiStyle.victory
  /// Haptic → HapticFeedback.heavyImpact()
  /// Sound → ছোট victory trumpet (assets/sounds/victory.mp3)
  /// Goal → User কে গর্বিত feel করানো (বড় milestone unlock)
  static Future<void> _triggerBudgetMilestone(
    BuildContext context,
    Map<String, dynamic>? metadata,
    CelebrationPreferences preferences,
  ) async {
    // Store context values before async operations
    final showMessage = metadata?['showMessage'] == true;
    final particleCount = _getOptimizedParticleCount(context, 70);
    final mounted = context.mounted;
    
    // Confetti (if enabled)
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      await celebrate(
        context,
        style: ConfettiStyle.victory,
        duration: const Duration(milliseconds: 3500),
        particleCount: particleCount,
      );
    }

    // Haptic feedback (if enabled)
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      HapticFeedback.heavyImpact();
    }

    // Sound (if enabled)
    if (preferences.enableCelebrationSound && FeatureFlags.kEnableCelebrationSounds) {
      await SoundService.playCelebrationSound(CelebrationEvent.budgetMilestone);
    }

    // Optional: Show milestone message
    if (showMessage && mounted) {
      _showSuccessMessage(context, 'Budget target achieved! 🏆');
    }
  }

  /// Streak Complete Celebration
  /// Event → 7 days বা 30 days streak complete
  /// Style → ConfettiStyle.celebration
  /// Haptic → HapticFeedback.mediumImpact()
  /// Sound → assets/sounds/celebration.mp3
  /// Goal → Habit loop কে reinforce করা, emotional dopamine trigger
  static Future<void> _triggerStreakComplete(
    BuildContext context,
    Map<String, dynamic>? metadata,
    CelebrationPreferences preferences,
  ) async {
    // Store context values before async operations
    final showMessage = metadata?['showMessage'] == true;
    final particleCount = _getOptimizedParticleCount(context, 50);
    final mounted = context.mounted;
    
    // Confetti (if enabled)
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      await celebrate(
        context,
        style: ConfettiStyle.celebration,
        duration: const Duration(milliseconds: 3000),
        particleCount: particleCount,
      );
    }

    // Haptic feedback (if enabled)
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      HapticFeedback.mediumImpact();
    }

    // Sound (if enabled)
    if (preferences.enableCelebrationSound && FeatureFlags.kEnableCelebrationSounds) {
      await SoundService.playCelebrationSound(CelebrationEvent.streakComplete);
    }

    // Optional: Show streak message
    if (showMessage && mounted) {
      final days = metadata?['days'] ?? 0;
      _showSuccessMessage(context, '$days day streak! 🔥');
    }
  }

  /// Easter Egg Celebration
  /// Event → User profile section এ গিয়ে special "Easter Egg" ট্যাপ করলে
  /// Style → ConfettiStyle.milestone
  /// Haptic → HapticFeedback.selectionClick()
  /// Sound → funny pop sound (assets/sounds/pop.mp3)
  /// Goal → Surprise + Fun, ব্র্যান্ডকে প্রিমিয়াম কিন্তু হিউম্যান রাখা
  static Future<void> _triggerEasterEgg(
    BuildContext context,
    Map<String, dynamic>? metadata,
    CelebrationPreferences preferences,
  ) async {
    // Store context values before async operations
    final showMessage = metadata?['showMessage'] == true;
    final particleCount = _getOptimizedParticleCount(context, 25);
    final mounted = context.mounted;
    
    // Confetti (if enabled)
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      await celebrate(
        context,
        style: ConfettiStyle.milestone,
        duration: const Duration(milliseconds: 1800),
        particleCount: particleCount,
      );
    }

    // Haptic feedback (if enabled)
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      HapticFeedback.selectionClick();
    }

    // Sound (if enabled)
    if (preferences.enableCelebrationSound && FeatureFlags.kEnableCelebrationSounds) {
      await SoundService.playCelebrationSound(CelebrationEvent.easterEgg);
    }

    // Optional: Show easter egg message
    if (showMessage && mounted) {
      _showSuccessMessage(context, 'Easter egg found! 🥚✨');
    }
  }

  /// Show success message with snackbar
  static void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Quick celebration for simple events
  static Future<void> quickCelebration(
    BuildContext context,
    ConfettiStyle style, {
    String? message,
    HapticFeedbackType hapticType = HapticFeedbackType.light,
    WidgetRef? ref,
  }) async {
    // Get user preferences
    final preferences = ref?.read(celebrationPreferencesProvider) ?? 
        const CelebrationPreferences();

    // Confetti (if enabled)
    if (preferences.enableConfetti && FeatureFlags.kEnableCelebrationConfetti) {
      await celebrate(context, style: style);
    }

    // Haptic feedback (if enabled)
    if (preferences.enableHaptics && FeatureFlags.kEnableCelebrationHaptics) {
      switch (hapticType) {
        case HapticFeedbackType.light:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.medium:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selection:
          HapticFeedback.selectionClick();
          break;
      }
    }

    // Message
    if (message != null) {
      if (context.mounted) {
        _showSuccessMessage(context, message);
      }
    }
  }
}

/// Haptic feedback types for celebrations
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}
