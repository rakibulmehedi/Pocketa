import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Sound tier classification for volume and priority
enum SoundTier {
  positive,    // Daily wins - subtle
  significant, // Important progress - moderate
  major,       // Life-changing moments - prominent
}

/// Sound metadata for enhanced UX
class SoundMetadata {
  final String path;
  final SoundTier tier;
  final double volumeMultiplier;

  const SoundMetadata(this.path, this.tier, this.volumeMultiplier);
}

/// Premium Sound Service for Pocketa
/// 
/// Features:
/// - Volume normalization for premium clarity
/// - Accessibility-first design
/// - Smart preloading for performance
/// - Silent mode detection
/// - Error handling with graceful fallbacks
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isPreloading = false;
  final Map<String, AudioPlayer> _preloadedPlayers = {};

  // Sound file paths with metadata
  static const Map<String, SoundMetadata> _soundFiles = {
    'success': SoundMetadata('sounds/success.wav', SoundTier.positive, 0.35),
    'achievement': SoundMetadata('sounds/achievement.wav', SoundTier.significant, 0.40),
    'celebration': SoundMetadata('sounds/celebration.wav', SoundTier.major, 0.45),
    'reward': SoundMetadata('sounds/reward.wav', SoundTier.positive, 0.35),
    'milestone': SoundMetadata('sounds/milestone.wav', SoundTier.significant, 0.40),
    'victory': SoundMetadata('sounds/victory.wav', SoundTier.major, 0.45),
  };

  // Premium volume settings (normalized for clarity)
  static const double _baseVolume = 0.38; // Premium clarity range
  static const double _silentModeMultiplier = 0.65; // 65% of base in silent mode
  static const double _accessibilityMultiplier = 0.8; // 80% for accessibility

  /// Initialize the sound service with premium configuration
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure audio session for premium experience
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.assistanceSonification,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
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

      _isInitialized = true;
      
      // Start preloading sounds for better performance
      _preloadSounds();
      
      if (kDebugMode) {
        print('🔊 SoundService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔊 SoundService initialization failed: $e');
      }
      // Continue without sound - not critical
      // Don't set _isInitialized to true if initialization failed
    }
  }

  /// Preload sounds for better performance and UX
  Future<void> _preloadSounds() async {
    if (_isPreloading) return;
    _isPreloading = true;

    try {
      for (final entry in _soundFiles.entries) {
        final player = AudioPlayer();
        await player.setSource(AssetSource(entry.value.path));
        _preloadedPlayers[entry.key] = player;
      }
      
      if (kDebugMode) {
        print('🔊 Preloaded ${_preloadedPlayers.length} sounds');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔊 Sound preloading failed: $e');
      }
    } finally {
      _isPreloading = false;
    }
  }

  /// Play a celebration sound with premium UX
  Future<void> playCelebrationSound(String soundType) async {
    if (!_isInitialized) {
      await initialize();
      if (!_isInitialized) return;
    }

    try {
      final metadata = _soundFiles[soundType];
      if (metadata == null) {
        if (kDebugMode) {
          print('🔊 Unknown sound type: $soundType');
        }
        return;
      }

      // Calculate premium volume with accessibility considerations
      final volume = await _calculatePremiumVolume(metadata);
      
      // Use preloaded player if available, otherwise fallback to main player
      final player = _preloadedPlayers[soundType] ?? _audioPlayer;
      
      await player.play(
        AssetSource(metadata.path),
        volume: volume,
      );

      if (kDebugMode) {
        print('🔊 Playing ${metadata.tier.name} sound: ${metadata.path} (volume: ${volume.toStringAsFixed(2)})');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔊 Failed to play sound: $e');
      }
      // Silently fail - sound is not critical
    }
  }

  /// Calculate premium volume with accessibility and system considerations
  Future<double> _calculatePremiumVolume(SoundMetadata metadata) async {
    double volume = _baseVolume * metadata.volumeMultiplier;
    
    // Apply silent mode reduction
    if (await _isSilentMode()) {
      volume *= _silentModeMultiplier;
    }
    
    // Apply accessibility reduction if needed
    if (await _shouldReduceVolumeForAccessibility()) {
      volume *= _accessibilityMultiplier;
    }
    
    return volume.clamp(0.0, 1.0);
  }

  /// Check if device is in silent mode
  Future<bool> _isSilentMode() async {
    try {
      // Platform-specific silent mode detection
      final result = await SystemChannels.platform.invokeMethod('isSilentMode');
      return result == true;
    } catch (e) {
      // Fallback: assume not silent if detection fails
      return false;
    }
  }

  /// Check if volume should be reduced for accessibility
  Future<bool> _shouldReduceVolumeForAccessibility() async {
    try {
      // This would integrate with accessibility settings
      // For now, return false as a placeholder
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Play sound with haptic feedback for enhanced UX
  Future<void> playCelebrationSoundWithHaptic(String soundType, HapticFeedbackType hapticType) async {
    // Play haptic feedback first for immediate response
    _playHapticFeedback(hapticType);
    
    // Then play sound
    await playCelebrationSound(soundType);
  }

  /// Play haptic feedback based on sound tier
  void _playHapticFeedback(HapticFeedbackType hapticType) {
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

  /// Get sound metadata for external use
  SoundMetadata? getSoundMetadata(String soundType) {
    return _soundFiles[soundType];
  }

  /// Check if sounds are preloaded
  bool get isPreloaded => _preloadedPlayers.isNotEmpty;

  /// Get preloading status
  bool get isPreloading => _isPreloading;

  /// Dispose resources with cleanup
  Future<void> dispose() async {
    // Dispose all preloaded players
    for (final player in _preloadedPlayers.values) {
      await player.dispose();
    }
    _preloadedPlayers.clear();
    
    // Dispose main player
    await _audioPlayer.dispose();
    
    _isInitialized = false;
    _isPreloading = false;
  }
}

/// Haptic feedback types for different sound tiers
enum HapticFeedbackType {
  light,     // For positive sounds
  medium,    // For significant sounds  
  heavy,     // For major sounds
  selection, // For UI interactions
}
