import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound Preloader for enhanced performance and UX
/// 
/// Features:
/// - Background preloading of all sounds
/// - Progress tracking for loading states
/// - Memory management and cleanup
/// - Error handling with retry logic
class SoundPreloader {
  static final SoundPreloader _instance = SoundPreloader._internal();
  factory SoundPreloader() => _instance;
  SoundPreloader._internal();

  final Map<String, AudioPlayer> _preloadedPlayers = {};
  bool _isPreloading = false;
  bool _isPreloaded = false;
  double _preloadProgress = 0.0;
  String? _currentLoadingSound;

  // Sound files to preload
  static const List<String> _soundFiles = [
    'success',
    'achievement', 
    'celebration',
    'reward',
    'milestone',
    'victory',
  ];

  /// Get preloading progress (0.0 to 1.0)
  double get progress => _preloadProgress;

  /// Check if preloading is complete
  bool get isPreloaded => _isPreloaded;

  /// Check if currently preloading
  bool get isPreloading => _isPreloading;

  /// Get currently loading sound name
  String? get currentLoadingSound => _currentLoadingSound;

  /// Get preloaded player for a sound
  AudioPlayer? getPlayer(String soundType) {
    return _preloadedPlayers[soundType];
  }

  /// Start preloading all sounds
  Future<void> preloadAllSounds() async {
    if (_isPreloading || _isPreloaded) return;

    _isPreloading = true;
    _preloadProgress = 0.0;

    try {
      final totalSounds = _soundFiles.length;
      
      for (int i = 0; i < totalSounds; i++) {
        final soundType = _soundFiles[i];
        _currentLoadingSound = soundType;
        
        try {
          final player = AudioPlayer();
          await player.setSource(AssetSource('sounds/$soundType.wav'));
          _preloadedPlayers[soundType] = player;
          
          if (kDebugMode) {
            print('🔊 Preloaded sound: $soundType');
          }
        } catch (e) {
          if (kDebugMode) {
            print('🔊 Failed to preload $soundType: $e');
          }
          // Continue with other sounds even if one fails
        }
        
        _preloadProgress = (i + 1) / totalSounds;
      }

      _isPreloaded = true;
      _currentLoadingSound = null;
      
      if (kDebugMode) {
        print('🔊 Preloading complete: ${_preloadedPlayers.length}/${totalSounds} sounds loaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔊 Preloading failed: $e');
      }
    } finally {
      _isPreloading = false;
    }
  }

  /// Preload a specific sound
  Future<bool> preloadSound(String soundType) async {
    if (_preloadedPlayers.containsKey(soundType)) return true;

    try {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/$soundType.wav'));
      _preloadedPlayers[soundType] = player;
      
      if (kDebugMode) {
        print('🔊 Preloaded individual sound: $soundType');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('🔊 Failed to preload $soundType: $e');
      }
      return false;
    }
  }

  /// Retry preloading failed sounds
  Future<void> retryFailedSounds() async {
    final failedSounds = <String>[];
    
    for (final soundType in _soundFiles) {
      if (!_preloadedPlayers.containsKey(soundType)) {
        failedSounds.add(soundType);
      }
    }

    if (failedSounds.isEmpty) return;

    if (kDebugMode) {
      print('🔊 Retrying ${failedSounds.length} failed sounds');
    }

    for (final soundType in failedSounds) {
      await preloadSound(soundType);
    }
  }

  /// Clear preloaded sounds to free memory
  Future<void> clearPreloadedSounds() async {
    for (final player in _preloadedPlayers.values) {
      await player.dispose();
    }
    _preloadedPlayers.clear();
    _isPreloaded = false;
    _preloadProgress = 0.0;
    _currentLoadingSound = null;
    
    if (kDebugMode) {
      print('🔊 Cleared all preloaded sounds');
    }
  }

  /// Get preloading status summary
  Map<String, dynamic> getStatus() {
    return {
      'isPreloading': _isPreloading,
      'isPreloaded': _isPreloaded,
      'progress': _preloadProgress,
      'loadedSounds': _preloadedPlayers.keys.toList(),
      'totalSounds': _soundFiles.length,
      'currentLoading': _currentLoadingSound,
    };
  }

  /// Dispose all resources
  Future<void> dispose() async {
    await clearPreloadedSounds();
  }
}
