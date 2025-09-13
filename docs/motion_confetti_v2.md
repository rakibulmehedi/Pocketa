# Confetti V2 System Documentation

## Overview

Confetti V2 is a premium celebration system that provides beautiful, physics-based confetti animations for various app events. It's designed to be performant, accessible, and theme-aware.

## Features

- **5 Celebration Styles**: achievement, celebration, reward, milestone, victory
- **7 Particle Shapes**: rectangle, circle, star, diamond, triangle, hexagon, heart
- **Physics Simulation**: gravity, drag, rotation with realistic motion
- **Theme Integration**: Uses app's color scheme for consistent branding
- **Accessibility**: Respects reduced motion preferences
- **Performance**: RepaintBoundary, efficient particle management
- **Feature Flags**: Easy to enable/disable via configuration

## Usage

### Basic Usage

```dart
import 'package:pocketa/shared/motion/confetti_v2.dart';

// Simple celebration
await celebrate(context, style: ConfettiStyle.achievement);

// With completion callback
await celebrate(
  context,
  style: ConfettiStyle.victory,
  onComplete: () {
    print('Celebration finished!');
  },
);
```

### Direct Overlay Usage

```dart
// Show confetti overlay directly
await ConfettiOverlay.show(
  context,
  style: ConfettiStyle.milestone,
  onComplete: () {
    // Handle completion
  },
);
```

## Confetti Styles

### Achievement
- **Duration**: 2000ms
- **Particles**: 40
- **Use Case**: Onboarding completion, first-time achievements
- **Haptic**: Light impact

### Celebration
- **Duration**: 2500ms
- **Particles**: 60
- **Use Case**: General celebrations, app milestones
- **Haptic**: Medium impact

### Reward
- **Duration**: 1800ms
- **Particles**: 35
- **Use Case**: Transaction success, small rewards
- **Haptic**: Light impact

### Milestone
- **Duration**: 3000ms
- **Particles**: 80
- **Use Case**: Streak achievements, major milestones
- **Haptic**: Heavy impact

### Victory
- **Duration**: 3500ms
- **Particles**: 100
- **Use Case**: Major achievements, app completion
- **Haptic**: Heavy impact

## Configuration

### Feature Flags

Control the system via feature flags in `lib/core/feature_flags.dart`:

```dart
class FeatureFlags {
  static const bool kEnableCelebrationV2 = true;
  static const bool kEnableCelebrationConfetti = true;
  static const bool kEnableCelebrationHaptics = true;
}
```

### Reduced Motion

The system automatically detects reduced motion preferences:

```dart
// Automatically handled
if (MediaQuery.of(context).disableAnimations) {
  // Uses fewer particles, shorter duration
}
```

## Implementation Details

### Physics
- **Gravity**: Configurable per style (0.15-0.35)
- **Drag**: Air resistance simulation (0.008-0.025)
- **Rotation**: Random rotation speed with physics
- **Velocity**: Horizontal and vertical spread control

### Performance
- **RepaintBoundary**: Isolates confetti rendering
- **Particle Pooling**: Reuses particle objects
- **Efficient Disposal**: Proper controller cleanup
- **Memory Management**: No memory leaks

### Theme Integration
- Uses `Theme.of(context).colorScheme` colors
- Automatically adapts to light/dark themes
- Maintains proper contrast ratios
- Respects brand colors

## Testing

Run the confetti tests:

```bash
flutter test test/shared/ui/motion/confetti_test.dart
```

## Migration from V1

The old `ConfettiWidget` is still available but deprecated. To migrate:

1. Replace `ConfettiWidget` usage with `celebrate()` calls
2. Update imports to use `confetti_v2.dart`
3. Choose appropriate `ConfettiStyle` for each use case
4. Test with reduced motion enabled

## Best Practices

1. **Use appropriate styles** for different events
2. **Test with reduced motion** enabled
3. **Don't overuse** - confetti should feel special
4. **Consider performance** on lower-end devices
5. **Respect user preferences** - honor feature flags

## Troubleshooting

### Confetti not showing
- Check `kEnableCelebrationConfetti` flag
- Verify context is valid and mounted
- Check for reduced motion settings

### Performance issues
- Reduce particle count in style configs
- Ensure RepaintBoundary is working
- Check for memory leaks in controllers

### Theme issues
- Verify color scheme is properly set
- Check contrast ratios in dark mode
- Ensure theme context is available
