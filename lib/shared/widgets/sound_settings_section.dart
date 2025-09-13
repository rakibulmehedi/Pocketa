import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/shared/services/sound_service.dart';

/// Premium Sound Settings Section
/// 
/// Features:
/// - Comprehensive sound preferences
/// - Real-time preview functionality
/// - Accessibility considerations
/// - Visual feedback and loading states
class SoundSettingsSection extends ConsumerStatefulWidget {
  const SoundSettingsSection({super.key});

  @override
  ConsumerState<SoundSettingsSection> createState() => _SoundSettingsSectionState();
}

class _SoundSettingsSectionState extends ConsumerState<SoundSettingsSection> {
  bool _isPlayingPreview = false;
  String? _previewSoundType;

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(celebrationPreferencesProvider);
    final notifier = ref.read(celebrationPreferencesProvider.notifier);
    final preloadStatus = CelebrationService.getPreloadingStatus();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.volume_up_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sound & Celebration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Customize your celebration experience',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Sound Effects Toggle
            _buildSoundToggle(
              context,
              preferences,
              notifier,
              'Celebration Sounds',
              'Play sounds for achievements and milestones',
              preferences.enableCelebrationSound,
              (value) => notifier.setCelebrationSoundEnabled(value),
            ),

            // Haptic Feedback Toggle
            _buildSoundToggle(
              context,
              preferences,
              notifier,
              'Haptic Feedback',
              'Vibrate for celebrations and interactions',
              preferences.enableHaptics,
              (value) => notifier.setHapticsEnabled(value),
            ),

            // Confetti Effects Toggle
            _buildSoundToggle(
              context,
              preferences,
              notifier,
              'Confetti Effects',
              'Show visual celebrations for achievements',
              preferences.enableConfetti,
              (value) => notifier.setConfettiEnabled(value),
            ),

            const SizedBox(height: 24),

            // Sound Preview Section
            if (preferences.enableCelebrationSound) ...[
              _buildPreviewSection(context, preloadStatus),
              const SizedBox(height: 16),
            ],

            // Preloading Status
            _buildPreloadingStatus(context, preloadStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundToggle(
    BuildContext context,
    CelebrationPreferences preferences,
    CelebrationPreferencesNotifier notifier,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (enabled) {
        // Provide haptic feedback for the toggle
        HapticFeedback.selectionClick();
        onChanged(enabled);
      },
      secondary: Icon(
        _getIconForSetting(title),
        color: value 
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, Map<String, dynamic> preloadStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sound Preview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to preview celebration sounds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPreviewButton(context, 'success', 'Success'),
            _buildPreviewButton(context, 'achievement', 'Achievement'),
            _buildPreviewButton(context, 'celebration', 'Celebration'),
            _buildPreviewButton(context, 'reward', 'Reward'),
            _buildPreviewButton(context, 'milestone', 'Milestone'),
            _buildPreviewButton(context, 'victory', 'Victory'),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewButton(BuildContext context, String soundType, String label) {
    final isPlaying = _isPlayingPreview && _previewSoundType == soundType;
    
    return OutlinedButton.icon(
      onPressed: isPlaying ? null : () => _playPreviewSound(soundType),
      icon: isPlaying
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Icon(
            Icons.play_arrow_rounded,
            size: 16,
          ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
    );
  }

  Widget _buildPreloadingStatus(BuildContext context, Map<String, dynamic> preloadStatus) {
    final isPreloading = preloadStatus['isPreloading'] as bool? ?? false;
    final isPreloaded = preloadStatus['isPreloaded'] as bool? ?? false;
    final progress = preloadStatus['progress'] as double? ?? 0.0;
    final loadedSounds = preloadStatus['loadedSounds'] as List<dynamic>? ?? [];
    final totalSounds = preloadStatus['totalSounds'] as int? ?? 0;

    if (!isPreloading && !isPreloaded) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPreloaded ? Icons.check_circle : Icons.download,
                size: 16,
                color: isPreloaded 
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isPreloaded 
                  ? 'Sounds Ready'
                  : 'Loading Sounds...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (isPreloading) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% complete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ] else if (isPreloaded) ...[
            const SizedBox(height: 4),
            Text(
              '$totalSounds sounds loaded and ready',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForSetting(String title) {
    switch (title) {
      case 'Celebration Sounds':
        return Icons.volume_up_rounded;
      case 'Haptic Feedback':
        return Icons.vibration_rounded;
      case 'Confetti Effects':
        return Icons.celebration_rounded;
      default:
        return Icons.settings_rounded;
    }
  }

  Future<void> _playPreviewSound(String soundType) async {
    if (_isPlayingPreview) return;

    setState(() {
      _isPlayingPreview = true;
      _previewSoundType = soundType;
    });

    try {
      final soundService = SoundService();
      await soundService.playCelebrationSound(soundType);
      
      // Add haptic feedback for preview
      HapticFeedback.lightImpact();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Preview failed: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingPreview = false;
          _previewSoundType = null;
        });
      }
    }
  }
}
