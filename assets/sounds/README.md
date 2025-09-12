# Manual Sound Assets for Pocketa Celebrations

This directory contains manually added sound effects for the celebration system.

## Current Sound Files

The following .wav files are currently in use:

- `success.wav` - Onboarding complete sound (soft success chime)
- `cash.wav` - First transaction sound (subtle cash register ding)
- `victory.wav` - Budget milestone sound (short victory trumpet)
- `celebration.wav` - Streak complete sound (celebration pop)
- `pop.wav` - Easter egg sound (funny light pop)

## Usage

Sounds are played by the `SoundService` when celebration events are triggered:

```dart
await SoundService.playCelebrationSound(CelebrationEvent.onboardingComplete);
```

## Audio Policy

- **iOS**: Uses `AVAudioSessionCategory.ambient` (respects silent switch)
- **Android**: Uses `AndroidContentType.sonification` + `AndroidUsageType.assistanceSonification`
- **Volume**: Default 0.65 (60-70% of system volume)
- **Format**: WAV files (high quality, uncompressed)
- **Sample Rate**: 44.1kHz
- **Bit Depth**: 16-bit

## Fallback

If sound files are missing, the celebration system will continue to work with confetti and haptic feedback only.
