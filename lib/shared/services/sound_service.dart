// ──────────────────────────────────────────────────────────────────────────────
// Sound Service - Manual Celebration Audio
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pocketa/shared/services/celebration_service.dart';

/// Sound service for manual celebration audio files
class SoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isEnabled = true;
  static bool _isInitialized = false;
  
  // Default volume: 60-70% of system volume (following guidelines)
  static const double _defaultVolume = 0.65;

  /// Initialize the sound service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Set audio context for proper audio policy
      await _audioPlayer.setAudioContext(AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {
            AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.allowBluetooth,
          },
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ));
      
      _isInitialized = true;
      debugPrint('🔊 SoundService initialized');
    } catch (e) {
      debugPrint('⚠️ SoundService initialization failed: $e');
    }
  }

  /// Preload all celebration sounds for better performance
  static Future<void> preloadSounds() async {
    if (!_isInitialized) await initialize();
    
    try {
      final soundPaths = [
        'sounds/success.wav',
        'sounds/cash.wav',
        'sounds/victory.wav',
        'sounds/celebration.wav',
        'sounds/pop.wav',
      ];
      
      for (final soundPath in soundPaths) {
        await _audioPlayer.setSource(AssetSource(soundPath));
      }
      debugPrint('🎵 Preloaded ${soundPaths.length} celebration sounds');
    } catch (e) {
      debugPrint('⚠️ Failed to preload sounds: $e');
    }
  }

  /// Enable or disable sound effects
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
    debugPrint('🔊 Sound ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Check if sound is enabled
  static bool get isEnabled => _isEnabled;

  /// Play celebration sound for specific event
  static Future<void> playCelebrationSound(CelebrationEvent event) async {
    if (!_isEnabled) return;
    if (!_isInitialized) await initialize();

    try {
      final soundPath = _getSoundPathForEvent(event);
      if (soundPath != null) {
        await _audioPlayer.setVolume(_defaultVolume);
        await _audioPlayer.play(AssetSource(soundPath));
        debugPrint('🔊 Playing sound: $soundPath');
      }
    } catch (e) {
      // Silent fallback - haptic + visual still work
      debugPrint('⚠️ Sound playback failed: $e');
      // Don't throw error - let other celebration elements continue
    }
  }

  /// Configure audio service with proper settings
  static Future<void> configure({
    required bool enableSounds,
  }) async {
    _isEnabled = enableSounds;
    if (!_isInitialized) await initialize();
    debugPrint('🔊 SoundService configured: ${enableSounds ? 'enabled' : 'disabled'}');
  }

  /// Get sound path for specific celebration event
  static String? _getSoundPathForEvent(CelebrationEvent event) {
    return switch (event) {
      CelebrationEvent.onboardingComplete => 'sounds/success.wav',
      CelebrationEvent.firstTransaction => 'sounds/cash.wav',
      CelebrationEvent.budgetMilestone => 'sounds/victory.wav',
      CelebrationEvent.streakComplete => 'sounds/celebration.wav',
      CelebrationEvent.easterEgg => 'sounds/pop.wav',
    };
  }

  /// Dispose audio player
  static Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
