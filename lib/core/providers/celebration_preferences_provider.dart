import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';

/// Celebration preferences model
class CelebrationPreferences {
  final bool enableCelebrationSound;
  final bool enableHaptics;
  final bool enableConfetti;

  const CelebrationPreferences({
    this.enableCelebrationSound = true,
    this.enableHaptics = true,
    this.enableConfetti = true,
  });

  CelebrationPreferences copyWith({
    bool? enableCelebrationSound,
    bool? enableHaptics,
    bool? enableConfetti,
  }) {
    return CelebrationPreferences(
      enableCelebrationSound: enableCelebrationSound ?? this.enableCelebrationSound,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableConfetti: enableConfetti ?? this.enableConfetti,
    );
  }

  Map<String, dynamic> toJson() => {
    'enableCelebrationSound': enableCelebrationSound,
    'enableHaptics': enableHaptics,
    'enableConfetti': enableConfetti,
  };

  factory CelebrationPreferences.fromJson(Map<String, dynamic> json) => CelebrationPreferences(
    enableCelebrationSound: json['enableCelebrationSound'] ?? true,
    enableHaptics: json['enableHaptics'] ?? true,
    enableConfetti: json['enableConfetti'] ?? true,
  );
}

/// Celebration preferences notifier
class CelebrationPreferencesNotifier extends StateNotifier<CelebrationPreferences> {
  CelebrationPreferencesNotifier() : super(const CelebrationPreferences()) {
    _loadPreferences();
  }

  static const String _key = 'celebration_preferences';

  Future<void> _loadPreferences() async {
    try {
      final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
      final data = prefs.get(_key);
      if (data != null) {
        state = CelebrationPreferences.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      // Use defaults if loading fails
      state = const CelebrationPreferences();
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
      await prefs.put(_key, state.toJson());
    } catch (e) {
      // Silently fail - preferences are not critical
    }
  }

  Future<void> setCelebrationSoundEnabled(bool enabled) async {
    state = state.copyWith(enableCelebrationSound: enabled);
    await _savePreferences();
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    state = state.copyWith(enableHaptics: enabled);
    await _savePreferences();
  }

  Future<void> setConfettiEnabled(bool enabled) async {
    state = state.copyWith(enableConfetti: enabled);
    await _savePreferences();
  }
}

/// Riverpod provider for celebration preferences
final celebrationPreferencesProvider = StateNotifierProvider<CelebrationPreferencesNotifier, CelebrationPreferences>(
  (ref) => CelebrationPreferencesNotifier(),
);
