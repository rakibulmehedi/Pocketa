# 🎵 Pocketa Sound Guidelines

## Overview

This document outlines the sound design philosophy, implementation guidelines, and best practices for Pocketa's celebration system. Our approach prioritizes emotional reinforcement over noise, ensuring sounds enhance the user experience without overwhelming it.

---

## 🎯 Philosophy

### Core Principles

**Sound = Emotional Reinforcement, Not Noise**
- Every sound must serve a purpose: reinforcing positive behavior, celebrating achievements, or providing subtle feedback
- Sounds should feel like a natural extension of the visual and haptic experience
- Quality over quantity: fewer, more meaningful sounds create stronger emotional impact

**Default Subtle, Premium, and Optional**
- All sounds are subtle by design - they enhance rather than dominate the experience
- Premium quality sounds that feel polished and professional
- Always optional with clear user control via settings

**Multi-Modal Experience**
- Sounds must pair with haptic feedback and visual cues (confetti)
- The combination creates a more engaging and memorable experience
- Each modality reinforces the others, creating a cohesive celebration

### When to Use Sound

✅ **DO Use Sound For:**
- Major milestone achievements (onboarding complete, first transaction)
- Significant progress markers (budget targets, streak achievements)
- Hidden rewards and easter eggs
- Critical success states that deserve celebration

❌ **DON'T Use Sound For:**
- Routine interactions (button taps, navigation)
- Error states or warnings
- Loading states or progress indicators
- Every single action or confirmation

---

## 📌 Usage Principles

### Technical Specifications

**Duration & Size**
- **Maximum Duration**: 400ms per sound
- **File Size Limit**: 50KB per sound file
- **Format**: MP3 (optimized for mobile)
- **Sample Rate**: 44.1kHz (standard quality)
- **Bit Rate**: 128kbps (balanced quality/size)

**Sound Characteristics**
- **Volume**: 60-70% of system volume (never override user preferences)
- **Tone**: Warm, positive, encouraging
- **Style**: Subtle chimes, soft dings, light pops
- **Avoid**: Loud, cheesy, or jarring sound effects

### User Control

**Settings Integration**
- Toggle: "Celebration Sounds" in Settings → Preferences
- Default: Enabled for new users
- Persistence: Remember user preference across app sessions
- Granular Control: Individual sound toggles for power users

**System Integration**
- Respect "Silent Mode" / "Do Not Disturb"
- Honor "Reduced Motion" accessibility setting
- Follow system volume levels
- Pause during phone calls or media playback

---

## 🎶 Milestone → Sound Mapping

### 1. Onboarding Complete
- **Sound**: `success.mp3`
- **Description**: Soft success chime with gentle fade-in
- **Duration**: 300ms
- **Emotional Goal**: Welcome and achievement feeling
- **Visual Pairing**: Achievement confetti + medium haptic

### 2. First Transaction
- **Sound**: `cash.mp3`
- **Description**: Subtle cash register ding (not cheesy)
- **Duration**: 250ms
- **Emotional Goal**: Money entry achievement celebration
- **Visual Pairing**: Reward confetti + light haptic

### 3. Budget Milestone (100%)
- **Sound**: `victory.mp3`
- **Description**: Short victory trumpet (elegant, not loud)
- **Duration**: 400ms
- **Emotional Goal**: Pride in major financial achievement
- **Visual Pairing**: Victory confetti + heavy haptic

### 4. Streak Complete (7+ Days)
- **Sound**: `celebration.mp3`
- **Description**: Celebration pop with subtle confetti sound
- **Duration**: 350ms
- **Emotional Goal**: Habit reinforcement and dopamine trigger
- **Visual Pairing**: Celebration confetti + medium haptic

### 5. Easter Egg / Hidden Reward
- **Sound**: `pop.mp3`
- **Description**: Funny, light "pop" sound
- **Duration**: 200ms
- **Emotional Goal**: Surprise and delight
- **Visual Pairing**: Milestone confetti + selection haptic

---

## 🔧 Technical Implementation

### Audio Player Setup

```dart
// lib/shared/services/sound_service.dart
class SoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isEnabled = true;
  
  // Preload sounds for performance
  static Future<void> preloadSounds() async {
    final sounds = [
      'sounds/success.mp3',
      'sounds/cash.mp3', 
      'sounds/victory.mp3',
      'sounds/celebration.mp3',
      'sounds/pop.mp3',
    ];
    
    for (final sound in sounds) {
      await _audioPlayer.setSource(AssetSource(sound));
    }
  }
}
```

### Feature Flag Integration

```dart
// lib/core/feature_flags.dart
class FeatureFlags {
  static const bool kEnableCelebrationSounds = true;
  static const bool kEnableSoundPreloading = true;
}
```

### Settings Integration

```dart
// lib/features/settings/presentation/widgets/sound_settings.dart
class SoundSettingsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text('Celebration Sounds'),
      subtitle: Text('Play sounds for achievements'),
      value: ref.watch(soundEnabledProvider),
      onChanged: (value) {
        ref.read(soundEnabledProvider.notifier).update((state) => value);
        SoundService.setEnabled(value);
      },
    );
  }
}
```

### Asset Organization

```
assets/sounds/
├── README.md                 # Sound asset documentation
├── success.mp3              # Onboarding complete
├── cash.mp3                 # First transaction  
├── victory.mp3              # Budget milestone
├── celebration.mp3          # Streak complete
└── pop.mp3                  # Easter egg
```

---

## 🧪 Testing & Accessibility

### Testing Checklist

**Device Testing**
- [ ] Test on different device sizes (phone, tablet)
- [ ] Test with headphones vs speakers
- [ ] Test in quiet vs noisy environments
- [ ] Test with different system volume levels

**Accessibility Testing**
- [ ] Test with "Reduced Motion" enabled (sounds should be disabled)
- [ ] Test with "Silent Mode" enabled (sounds should be disabled)
- [ ] Test with "Do Not Disturb" enabled
- [ ] Test during phone calls (sounds should pause)

**Performance Testing**
- [ ] Test sound loading time (should be < 100ms)
- [ ] Test memory usage during sound playback
- [ ] Test battery impact of sound playback
- [ ] Test with multiple rapid celebrations

**User Experience Testing**
- [ ] Test sound quality on different devices
- [ ] Test emotional impact of sound + visual + haptic combination
- [ ] Test user preference persistence
- [ ] Test fallback behavior when sounds fail

### Fallback Strategy

```dart
// Always provide fallback when sound fails
static Future<void> playCelebrationSound(String event) async {
  try {
    if (!_isEnabled || !_isSoundAvailable) return;
    
    final soundPath = _getSoundPath(event);
    if (soundPath != null) {
      await _audioPlayer.play(AssetSource(soundPath));
    }
  } catch (e) {
    // Silent fallback - haptic + visual still work
    debugPrint('Sound playback failed: $e');
  }
}
```

---

## 🌍 Future Improvements

### Sound Packs

**Multiple Themes**
- **Default**: Current subtle, professional sounds
- **Minimal**: Even more subtle, zen-like sounds
- **Festive**: Slightly more celebratory for special occasions
- **Seasonal**: Eid, Puja, New Year themed sounds

**Implementation**
```dart
enum SoundPack {
  default,
  minimal, 
  festive,
  seasonal,
}

class SoundService {
  static SoundPack _currentPack = SoundPack.default;
  
  static Future<void> setSoundPack(SoundPack pack) async {
    _currentPack = pack;
    await _loadPackSounds();
  }
}
```

### A/B Testing

**Sound Variations**
- Test different chime tones for onboarding
- Test various cash register sounds for transactions
- Test different victory sounds for milestones
- Measure user engagement and retention

**Analytics Integration**
```dart
// Track sound usage and user preferences
await AnalyticsService.logEvent('sound_played', {
  'event': event,
  'sound_pack': _currentPack.name,
  'user_preference': _isEnabled,
});
```

### AI-Driven Personalization

**Adaptive Sounds**
- Learn user preferences over time
- Adjust sound frequency based on usage patterns
- Suggest sound pack changes based on behavior
- Personalized celebration timing

**Smart Timing**
- Detect user's active hours for sound timing
- Adjust sound volume based on environment (if possible)
- Learn from user's celebration engagement

---

## 📊 Success Metrics

### Key Performance Indicators

**User Engagement**
- Celebration completion rate
- User retention after first celebration
- Settings toggle usage (sound on/off)
- User feedback on sound experience

**Technical Performance**
- Sound loading time (< 100ms target)
- Memory usage during celebrations
- Battery impact measurement
- Error rate for sound playback

**Accessibility Compliance**
- Reduced motion respect rate
- Silent mode compliance
- Fallback success rate
- User satisfaction with accessibility features

---

## 🎨 Design Guidelines

### Sound Design Principles

**Frequency Spectrum**
- Use mid-range frequencies (500Hz - 4kHz) for clarity
- Avoid low frequencies that might interfere with music
- Keep high frequencies subtle to avoid harshness

**Dynamic Range**
- Use gentle attack and decay curves
- Avoid sudden volume changes
- Maintain consistent perceived loudness

**Cultural Considerations**
- Ensure sounds are culturally appropriate for Bangla users
- Avoid sounds that might be offensive or inappropriate
- Consider local music traditions in sound design

### Brand Alignment

**Pocketa's Voice**
- Professional yet approachable
- Encouraging without being pushy
- Premium quality that reflects app value
- Consistent with visual design language

**Emotional Journey**
- Onboarding: Welcome and confidence-building
- Transactions: Achievement and progress
- Milestones: Pride and accomplishment
- Streaks: Habit reinforcement and motivation
- Easter eggs: Delight and surprise

---

## 🔄 Maintenance & Updates

### Regular Reviews

**Monthly**
- Review user feedback on sound experience
- Check performance metrics and optimization opportunities
- Update sound assets if needed

**Quarterly**
- Evaluate sound pack performance
- Plan new sound variations
- Review accessibility compliance

**Annually**
- Complete sound system audit
- Plan major sound design updates
- Evaluate new audio technologies

### Version Control

**Sound Asset Versioning**
- Version sound files (e.g., `success_v1.mp3`)
- Maintain backward compatibility
- Document changes in sound characteristics
- Test new sounds thoroughly before release

---

**Created by**: UX Sound Design Team  
**Last Updated**: December 2024  
**Version**: 1.0.0  
**Next Review**: January 2025
