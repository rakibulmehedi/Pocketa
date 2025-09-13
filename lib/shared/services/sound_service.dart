import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Sound service for gamification and user feedback
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  static final Logger _logger = Logger();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Sound file paths - using .wav for better quality
  static const String _successSound = 'sounds/success.wav';
  static const String _celebrationSound = 'sounds/celebration.wav';
  
  // Additional premium sounds
  static const String _achievementSound = 'sounds/achievement.wav';
  static const String _milestoneSound = 'sounds/milestone.wav';
  static const String _rewardSound = 'sounds/reward.wav';
  static const String _victorySound = 'sounds/victory.wav';

  /// Initialize the sound service
  Future<void> initialize() async {
    try {
      // Configure audio context for better performance
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient,
            options: {
              AVAudioSessionOptions.defaultToSpeaker,
              AVAudioSessionOptions.allowBluetooth,
            },
          ),
        ),
      );
      
      _logger.i('SoundService initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize SoundService: $e');
    }
  }

  /// Play a sound effect
  Future<void> playSound(SoundType soundType) async {
    if (kDebugMode) {
      _logger.d('Playing sound: $soundType');
    }

    try {
      String soundPath;
      switch (soundType) {
        case SoundType.success:
          soundPath = _successSound;
          break;
        case SoundType.celebration:
          soundPath = _celebrationSound;
          break;
        case SoundType.achievement:
          soundPath = _achievementSound;
          break;
        case SoundType.milestone:
          soundPath = _milestoneSound;
          break;
        case SoundType.reward:
          soundPath = _rewardSound;
          break;
        case SoundType.victory:
          soundPath = _victorySound;
          break;
      }

      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      _logger.e('Failed to play sound $soundType: $e');
    }
  }

  /// Play success sound for positive actions
  Future<void> playSuccess() => playSound(SoundType.success);

  /// Play celebration sound for achievements
  Future<void> playCelebration() => playSound(SoundType.celebration);

  /// Play achievement sound for accomplishments
  Future<void> playAchievement() => playSound(SoundType.achievement);

  /// Play milestone sound for significant progress
  Future<void> playMilestone() => playSound(SoundType.milestone);

  /// Play reward sound for earned rewards
  Future<void> playReward() => playSound(SoundType.reward);

  /// Play victory sound
  Future<void> playVictory() => playSound(SoundType.victory);

  /// Stop all sounds
  Future<void> stopAll() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      _logger.e('Failed to stop sounds: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      _logger.e('Failed to dispose SoundService: $e');
    }
  }
}

/// Available sound types for gamification
enum SoundType {
  success,
  celebration,
  achievement,
  milestone,
  reward,
  victory,
}

/// Sound service provider for Riverpod
final soundServiceProvider = Provider<SoundService>((ref) {
  return SoundService();
});