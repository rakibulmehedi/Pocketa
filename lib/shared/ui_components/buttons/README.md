# Buttons

Comprehensive collection of button components with multiple styles, states, and advanced interactions.

## Components

### AppButton
Standard button with multiple styles and states. Perfect for most use cases.

**Styles:** primary, secondary, outline, text  
**Sizes:** small, medium, large

### QuickButton
Specialized button for quick actions with positive/negative states.

### ResponsiveIconButton
Icon-only button that adapts to screen sizes with selection states.

### InteractiveButton
Advanced button with comprehensive animations, haptic feedback, and extensive customization options.

**Styles:** primary, secondary, outline, text, success, warning, error, ghost  
**Sizes:** small, medium, large, extraLarge  
**Features:** Haptic feedback, animations, gradients, glow effects, shimmer, pulse, bounce

## Usage

### Basic Usage

```dart
import 'package:pocketa/shared/ui_components/buttons/buttons.dart';

// Standard button
AppButton(
  text: 'Save',
  onPressed: () => saveData(),
  style: AppButtonStyle.primary,
  icon: Icons.save,
)

// Quick action button
QuickButton(
  label: 'Delete',
  icon: Icons.delete,
  onPressed: () => deleteItem(),
  isPositive: false,
)

// Responsive icon button
ResponsiveIconButton(
  icon: Icons.favorite,
  onPressed: () => toggleFavorite(),
  isSelected: isFavorite,
)
```

### Advanced Interactive Button

```dart
// Basic interactive button
InteractiveButton(
  text: 'Submit',
  onPressed: () => submitForm(),
  style: InteractiveButtonStyle.primary,
  size: InteractiveButtonSize.medium,
  icon: Icons.check,
)

// Advanced interactive button with animations
InteractiveButton(
  text: 'Loading...',
  isLoading: true,
  style: InteractiveButtonStyle.success,
  size: InteractiveButtonSize.large,
  enableBounce: true,
  enableHaptic: true,
  hapticType: HapticType.medium,
  enableGlow: true,
  glowColor: Colors.green,
  gradient: LinearGradient(
    colors: [Colors.blue, Colors.purple],
  ),
)

// Shimmer effect button
InteractiveButton(
  text: 'Special Action',
  onPressed: () => performAction(),
  style: InteractiveButtonStyle.primary,
  enableShimmer: true,
  shimmerColor: Colors.white,
  enablePulse: true,
  pulseScale: 1.05,
)

// Outline button with custom styling
InteractiveButton(
  text: 'Cancel',
  onPressed: () => cancelAction(),
  style: InteractiveButtonStyle.outline,
  size: InteractiveButtonSize.small,
  borderColor: Colors.red,
  textColor: Colors.red,
  enableBounce: true,
  bounceScale: 1.1,
)
```

## Button Styles

### AppButton Styles
- **Primary**: Main action buttons with solid background
- **Secondary**: Success/positive actions with green theme
- **Outline**: Secondary actions with border only
- **Text**: Minimal text-only buttons

### InteractiveButton Styles
- **Primary**: Main action buttons
- **Secondary**: Success actions
- **Outline**: Secondary actions with border
- **Text**: Minimal text-only buttons
- **Success**: Success state with green theme
- **Warning**: Warning state with orange theme
- **Error**: Error state with red theme
- **Ghost**: Transparent background with subtle styling

## Button Sizes

### AppButton Sizes
- **Small**: Compact buttons for tight spaces
- **Medium**: Standard button size
- **Large**: Prominent buttons for important actions

### InteractiveButton Sizes
- **Small**: Compact buttons (12px font)
- **Medium**: Standard buttons (14px font)
- **Large**: Prominent buttons (16px font)
- **ExtraLarge**: Hero buttons (18px font)

## Advanced Features

### Haptic Feedback
```dart
InteractiveButton(
  text: 'Tap Me',
  onPressed: () {},
  hapticType: HapticType.medium, // light, medium, heavy, selection, none
  enableHaptic: true,
  enableSound: true,
)
```

### Animations
```dart
InteractiveButton(
  text: 'Animated',
  onPressed: () {},
  enableBounce: true,        // Elastic bounce on tap
  enablePulse: true,         // Continuous pulsing
  enableShimmer: true,       // Shimmer loading effect
  enableGlow: true,          // Glow effect on focus
  animationDuration: Duration(milliseconds: 300),
  animationCurve: Curves.easeInOut,
)
```

### Customization
```dart
InteractiveButton(
  text: 'Custom',
  onPressed: () {},
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  borderColor: Colors.deepPurple,
  borderRadius: 20.0,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 8),
  elevation: 4.0,
  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
)
```

### Accessibility
```dart
InteractiveButton(
  text: 'Accessible',
  onPressed: () {},
  semanticLabel: 'Save document',
  accessibilityHint: 'Double tap to save your changes',
  tooltip: 'Save your work',
  enableAccessibility: true,
)
```

### Focus and Keyboard
```dart
InteractiveButton(
  text: 'Focusable',
  onPressed: () {},
  enableFocus: true,
  autofocus: true,
  onFocusChange: () => print('Focus changed'),
  enableKeyboard: true,
  keyboardShortcut: 'Ctrl+S',
)
```

## Best Practices

1. **Use AppButton** for standard UI actions
2. **Use QuickButton** for quick actions like delete, edit
3. **Use ResponsiveIconButton** for icon-only actions
4. **Use InteractiveButton** for special interactions, loading states, or when you need advanced animations

2. **Choose appropriate styles** based on action importance:
   - Primary for main actions
   - Secondary for supporting actions
   - Outline for secondary actions
   - Text for minimal actions

3. **Use consistent sizing** throughout your app:
   - Small for compact spaces
   - Medium for most use cases
   - Large for important actions

4. **Enable haptic feedback** for better user experience on mobile devices

5. **Use animations sparingly** - they should enhance, not distract

6. **Test accessibility** with screen readers and keyboard navigation

## Performance Notes

- All buttons use `RepaintBoundary` for optimal performance
- Colors are cached for better performance
- Animations are optimized to minimize rebuilds
- Use `isLoading` state instead of disabling buttons during async operations