import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/shared/motion/confetti_v2.dart';

/// Celebration Demo Widget
/// 
/// A demo component to test all celebration types
/// Perfect for development and testing
class CelebrationDemo extends ConsumerStatefulWidget {
  const CelebrationDemo({super.key});

  @override
  ConsumerState<CelebrationDemo> createState() => _CelebrationDemoState();
}

class _CelebrationDemoState extends ConsumerState<CelebrationDemo> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.celebration_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Celebration Demo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test all celebration types and effects',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Celebration Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCelebrationButton(
                  context,
                  'Onboarding Complete',
                  CelebrationEvent.onboardingComplete,
                  Icons.check_circle_rounded,
                  Colors.green,
                ),
                _buildCelebrationButton(
                  context,
                  'First Transaction',
                  CelebrationEvent.firstTransaction,
                  Icons.account_balance_wallet_rounded,
                  Colors.blue,
                ),
                _buildCelebrationButton(
                  context,
                  'Budget Milestone',
                  CelebrationEvent.budgetMilestone,
                  Icons.trending_up_rounded,
                  Colors.orange,
                ),
                _buildCelebrationButton(
                  context,
                  'Streak Complete',
                  CelebrationEvent.streakComplete,
                  Icons.local_fire_department_rounded,
                  Colors.red,
                ),
                _buildCelebrationButton(
                  context,
                  'Easter Egg',
                  CelebrationEvent.easterEgg,
                  Icons.egg_rounded,
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quick Celebration
            _buildQuickCelebrationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationButton(
    BuildContext context,
    String label,
    CelebrationEvent event,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: _isPlaying ? null : () => _triggerCelebration(event),
      icon: _isPlaying 
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          )
        : Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
    );
  }

  Widget _buildQuickCelebrationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Celebrations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickButton(
              context,
              'Success',
              ConfettiStyle.achievement,
              'Great job!',
              Icons.thumb_up_rounded,
            ),
            _buildQuickButton(
              context,
              'Reward',
              ConfettiStyle.reward,
              'Reward earned!',
              Icons.card_giftcard_rounded,
            ),
            _buildQuickButton(
              context,
              'Victory',
              ConfettiStyle.victory,
              'Victory!',
              Icons.emoji_events_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String label,
    ConfettiStyle style,
    String message,
    IconData icon,
  ) {
    return OutlinedButton.icon(
      onPressed: _isPlaying ? null : () => _triggerQuickCelebration(style, message),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
    );
  }

  Future<void> _triggerCelebration(CelebrationEvent event) async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    try {
      await CelebrationService.triggerCelebration(
        context,
        event,
        metadata: _getMetadataForEvent(event),
        ref: ref,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _triggerQuickCelebration(ConfettiStyle style, String message) async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    try {
      await CelebrationService.quickCelebration(
        context,
        style,
        message: message,
        ref: ref,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Map<String, dynamic> _getMetadataForEvent(CelebrationEvent event) {
    switch (event) {
      case CelebrationEvent.budgetMilestone:
        return {'percentage': 100};
      case CelebrationEvent.streakComplete:
        return {'days': 7};
      default:
        return {};
    }
  }
}
