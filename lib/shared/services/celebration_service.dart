import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/shared/services/sound_service.dart';
import 'package:pocketa/shared/widgets/confetti_widget.dart';

/// Celebration service for gamification and user engagement
class CelebrationService {
  static final CelebrationService _instance = CelebrationService._internal();
  factory CelebrationService() => _instance;
  CelebrationService._internal();

  static final Logger _logger = Logger();
  final SoundService _soundService = SoundService();

  /// Show celebration overlay with confetti and sound
  Future<void> showCelebration({
    required BuildContext context,
    required String message,
    CelebrationType type = CelebrationType.success,
    Duration duration = const Duration(seconds: 3),
    bool enableSound = true,
    bool enableHaptic = true,
  }) async {
    try {
      // Play celebration sound
      if (enableSound) {
        switch (type) {
          case CelebrationType.success:
            await _soundService.playSuccess();
            break;
        case CelebrationType.achievement:
          await _soundService.playAchievement();
          break;
        case CelebrationType.transaction:
          await _soundService.playSuccess();
          break;
        case CelebrationType.milestone:
          await _soundService.playMilestone();
          break;
        case CelebrationType.reward:
          await _soundService.playReward();
          break;
        case CelebrationType.victory:
          await _soundService.playVictory();
          break;
        }
      }

      // Haptic feedback
      if (enableHaptic) {
        switch (type) {
          case CelebrationType.success:
            HapticFeedback.lightImpact();
            break;
          case CelebrationType.achievement:
            HapticFeedback.heavyImpact();
            break;
          case CelebrationType.transaction:
            HapticFeedback.mediumImpact();
            break;
        case CelebrationType.milestone:
          HapticFeedback.heavyImpact();
          break;
        case CelebrationType.reward:
          HapticFeedback.mediumImpact();
          break;
        case CelebrationType.victory:
          HapticFeedback.heavyImpact();
          break;
        }
      }

      // Show confetti overlay
      if (context.mounted) {
        _showConfettiOverlay(context, message, type, duration);
      }

      _logger.i('Celebration shown: $type - $message');
    } catch (e) {
      _logger.e('Failed to show celebration: $e');
    }
  }

  /// Show confetti overlay
  void _showConfettiOverlay(
    BuildContext context,
    String message,
    CelebrationType type,
    Duration duration,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfettiOverlay(
        message: message,
        type: type,
        duration: duration,
      ),
    );
  }

  /// Quick success celebration
  Future<void> showSuccess(BuildContext context, String message) async {
    await showCelebration(
      context: context,
      message: message,
      type: CelebrationType.success,
      duration: const Duration(seconds: 2),
    );
  }

  /// Achievement celebration
  Future<void> showAchievement(BuildContext context, String message) async {
    await showCelebration(
      context: context,
      message: message,
      type: CelebrationType.achievement,
      duration: const Duration(seconds: 4),
    );
  }

  /// Transaction celebration
  Future<void> showTransaction(BuildContext context, String message) async {
    await showCelebration(
      context: context,
      message: message,
      type: CelebrationType.transaction,
      duration: const Duration(seconds: 2),
    );
  }

  /// Milestone celebration
  Future<void> showMilestone(BuildContext context, String message) async {
    await showCelebration(
      context: context,
      message: message,
      type: CelebrationType.milestone,
      duration: const Duration(seconds: 5),
    );
  }

  /// Reward celebration
  Future<void> showReward(BuildContext context, String message) async {
    await showCelebration(
      context: context,
      message: message,
      type: CelebrationType.reward,
      duration: const Duration(seconds: 3),
    );
  }

}

/// Celebration types for different scenarios
enum CelebrationType {
  success,
  achievement,
  transaction,
  milestone,
  reward,
  victory,
}

/// Confetti overlay widget
class ConfettiOverlay extends StatefulWidget {
  final String message;
  final CelebrationType type;
  final Duration duration;

  const ConfettiOverlay({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _startCelebration();
  }

  void _startCelebration() async {
    _fadeController.forward();
    _confettiController.forward();
    
    await Future.delayed(widget.duration);
    
    if (mounted) {
      _fadeController.reverse();
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Confetti background
            ConfettiWidget(
              child: Container(),
              isActive: _confettiController.isAnimating,
              particleCount: 150,
              enableHapticFeedback: true,
              enableSound: false, // Sound is handled by CelebrationService
            ),
            // Message overlay
            Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForType(widget.type),
                      size: 48,
                      color: _getColorForType(context, widget.type),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(CelebrationType type) {
    switch (type) {
      case CelebrationType.success:
        return Icons.check_circle;
      case CelebrationType.achievement:
        return Icons.emoji_events;
      case CelebrationType.transaction:
        return Icons.attach_money;
      case CelebrationType.milestone:
        return Icons.star;
      case CelebrationType.reward:
        return Icons.card_giftcard;
      case CelebrationType.victory:
        return Icons.emoji_events;
    }
  }

  Color _getColorForType(BuildContext context, CelebrationType type) {
    switch (type) {
      case CelebrationType.success:
        return Colors.green;
      case CelebrationType.achievement:
        return Colors.amber;
      case CelebrationType.transaction:
        return Colors.blue;
      case CelebrationType.milestone:
        return Colors.purple;
      case CelebrationType.reward:
        return Colors.orange;
      case CelebrationType.victory:
        return Colors.red;
    }
  }
}

/// Celebration service provider for Riverpod
final celebrationServiceProvider = Provider<CelebrationService>((ref) {
  return CelebrationService();
});
