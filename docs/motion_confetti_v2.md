# Confetti V2 - Premium Celebration System

## Overview

The upgraded confetti system provides professional, achievement-grade celebrations with theme-aware colors, reduced-motion support, and enhanced physics. All improvements are backward-compatible and gated by feature flags.

## Features

### ✨ Premium Styles
- **Achievement**: Success, completion, milestone (2.5s, 40 particles)
- **Celebration**: General celebration (2.0s, 35 particles)  
- **Reward**: Prize, bonus, special reward (2.8s, 50 particles)
- **Milestone**: Progress milestone (1.8s, 25 particles)
- **Victory**: Major success, win (3.5s, 70 particles)

### 🎨 Theme Integration
- Automatically uses `Theme.of(context).colorScheme` colors
- Brightness-aware color adjustments
- Dark/light mode friendly
- No hardcoded colors in production

### ♿ Accessibility
- Respects `MediaQuery.disableAnimations`
- Reduced particle count for reduced motion
- Shorter durations when motion is disabled
- No global blur overlays

### ⚡ Performance
- `RepaintBoundary` for optimal rendering
- Responsive particle counts based on device
- Clean controller disposal
- Minimal GC pressure

## Usage

### Basic Usage
```dart
import 'package:pocketa/shared/ui/motion/confetti.dart';

// Simple celebration
await celebrate(context, style: ConfettiStyle.achievement);

// Custom celebration
await celebrate(
  context,
  style: ConfettiStyle.victory,
  duration: Duration(milliseconds: 3000),
  particleCount: 60,
  colors: [Colors.gold, Colors.silver],
);
```

### Direct API
```dart
// Direct overlay (respects feature flags)
await ConfettiOverlay.show(
  context,
  style: ConfettiStyle.reward,
  duration: Duration(milliseconds: 2000),
  particleCount: 40,
);
```

### Widget Wrapper
```dart
ConfettiBurst(
  trigger: showConfetti,
  style: ConfettiStyle.achievement,
  child: YourWidget(),
)
```

## Configuration

### Feature Flag
```dart
// lib/core/feature_flags.dart
class FeatureFlags {
  static const bool kEnableCelebrationV2 = true;
}
```

### Reduced Motion Behavior
- **Achievement**: 12 particles, 1.5s duration
- **Celebration**: 10 particles, 1.2s duration  
- **Reward**: 16 particles, 1.8s duration
- **Milestone**: 8 particles, 1.0s duration
- **Victory**: 20 particles, 2.5s duration

### Responsive Scaling
Particle counts automatically scale based on:
- Device type (phone/tablet/desktop)
- UI scale factor
- Clamped between 20-100 particles

## Implementation Details

### Physics
- Light gravity with variation
- Random rotation and rotation speed
- Burst delays for dramatic effect
- Scale animations for premium feel
- Smooth opacity fade-out

### Shapes
- Rectangle, Circle, Star, Diamond
- Triangle, Hexagon, Heart
- Style-specific shape preferences

### Haptic Feedback
- **Achievement/Celebration/Milestone**: Light impact
- **Reward**: Medium impact  
- **Victory**: Heavy impact

## Migration

### From Old API
```dart
// Old
ConfettiOverlay.show(context);

// New (backward compatible)
await celebrate(context, style: ConfettiStyle.achievement);
```

### Examples Updated
- Onboarding demo success → `ConfettiStyle.achievement`
- First transaction added → `ConfettiStyle.reward`
- Goal/streak events → `ConfettiStyle.victory`

## Testing

### Manual Testing
1. Test in light/dark mode
2. Enable reduced motion in system settings
3. Test on different device sizes
4. Verify haptic feedback works
5. Check performance on lower-end devices

### Automated Testing
```bash
flutter analyze  # Should show 0 issues
flutter test     # All tests should pass
```

## Rollback

To disable the new system:
```dart
// lib/core/feature_flags.dart
static const bool kEnableCelebrationV2 = false;
```

This will disable all confetti animations while keeping the code intact.

## Commit Suggestions

```bash
feat(motion): upgrade confetti with premium styles and theme integration
refactor(ui): add celebrate() helper with feature flag support  
chore: add feature flag for celebration v2
docs: add confetti v2 documentation
```
