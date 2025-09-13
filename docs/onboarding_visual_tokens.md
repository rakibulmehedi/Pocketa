# Onboarding Visual Tokens - Design System

## Spacing System
All spacing uses `context.layout` tokens for consistent scaling across devices.

### Base Spacing
```dart
// Micro spacing
layout.spaceXs  // 4dp
layout.spaceS   // 8dp
layout.spaceM   // 12dp
layout.spaceL   // 16dp
layout.spaceXl  // 24dp
layout.space2xl // 32dp
layout.space3xl // 48dp

// Page-level spacing
layout.pageGutter // Safe area + responsive gutter
layout.gutter     // Responsive gutter (1.5rem - 4rem)
```

### Component Spacing
```dart
// Card padding
layout.spaceM    // 12dp - internal card padding
layout.spaceL    // 16dp - card margin

// Button spacing
layout.spaceS    // 8dp - button internal padding
layout.spaceM    // 12dp - button margin

// Text spacing
layout.spaceS    // 8dp - between title and subtitle
layout.spaceL    // 16dp - between sections
layout.spaceXl   // 24dp - between major sections
```

## Typography Scale
All text uses responsive typography with proper scaling.

### Headlines
```dart
// Screen titles
layout.t2xl  // 24sp - Mobile
layout.t3xl  // 28sp - Tablet/Desktop

// Section titles
layout.tXl   // 20sp - Mobile
layout.t2xl  // 24sp - Tablet/Desktop
```

### Body Text
```dart
// Primary body text
layout.tBase // 15sp - Mobile
layout.tLg   // 17sp - Tablet/Desktop

// Secondary text
layout.tSm   // 13sp - Mobile
layout.tBase // 15sp - Tablet/Desktop

// Small text
layout.tXs   // 11sp - Mobile
layout.tSm   // 13sp - Tablet/Desktop
```

### Responsive Typography
```dart
// Use responsiveTextStyle for device-specific sizing
layout.responsiveTextStyle(
  phone: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  tablet: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  desktop: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
)
```

## Border Radius
Consistent corner rounding across all components.

```dart
layout.radiusS  // 8dp - Small elements (chips, badges)
layout.radiusM  // 12dp - Cards, buttons
layout.radiusL  // 16dp - Large cards, modals
layout.radiusXl // 24dp - Hero elements, major containers
```

## Icon Sizes
Scalable icon system for different contexts.

```dart
layout.iconS  // 18dp - Small icons (inline)
layout.iconM  // 22dp - Medium icons (buttons)
layout.iconL  // 28dp - Large icons (cards)
layout.iconXl // 36dp - Hero icons (screens)
```

## Layout Constraints
Responsive max-widths for content centering.

### Content Widths
```dart
// Mobile: Full width
// Tablet: 720dp max
// Desktop: 1000dp max

ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: layout.isDesktop ? 1000 : layout.isTablet ? 720 : double.infinity,
  ),
  child: content,
)
```

### Page Structure
```dart
Padding(
  padding: layout.pageGutter,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: layout.isDesktop ? 1000 : layout.isTablet ? 720 : double.infinity,
    ),
    child: content,
  ),
)
```

## Color Tokens
Theme-aware color system (no hardcoded colors).

### Primary Colors
```dart
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.primaryContainer
```

### Surface Colors
```dart
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.surfaceContainerHighest
```

### Semantic Colors
```dart
Theme.of(context).colorScheme.success
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.warning
```

## Animation Tokings
Consistent timing and easing for all animations.

### Duration
```dart
AppMotion.fast  // 180ms - Micro-interactions
AppMotion.med   // 240ms - Standard animations
AppMotion.slow  // 320ms - Complex animations
```

### Easing
```dart
AppMotion.ease     // easeOutCubic - Standard
AppMotion.easeIn   // easeInCubic - Entrances
AppMotion.spring   // easeOutBack - Success states
```

### Stagger Delays
```dart
0ms    // Hero elements
80ms   // Headlines
120ms  // Subtitles
160ms  // Content
200ms  // CTAs
240ms  // Secondary elements
```

## Touch Targets
Accessibility-compliant touch targets.

```dart
layout.minTapTarget // 44dp minimum
layout.hitSlop      // 4dp hit area expansion
```

## Image Sizing
Optimized image loading with proper dimensions.

```dart
// Hero illustrations
width: layout.responsiveSize(phone: 200, tablet: 280, desktop: 320)
height: layout.responsiveSize(phone: 200, tablet: 280, desktop: 320)

// Cache dimensions (logical × DPR)
cacheWidth: (200 * MediaQuery.of(context).devicePixelRatio).round()
cacheHeight: (200 * MediaQuery.of(context).devicePixelRatio).round()
```

## Component Patterns

### Cards
```dart
GlassCard(
  padding: EdgeInsets.all(layout.spaceM),
  margin: EdgeInsets.all(layout.spaceS),
  child: content,
)
```

### Buttons
```dart
// Primary button
Container(
  padding: EdgeInsets.symmetric(
    horizontal: layout.spaceL,
    vertical: layout.spaceM,
  ),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
    borderRadius: BorderRadius.circular(layout.radiusM),
  ),
  child: Text(buttonText),
)

// Secondary button
Container(
  padding: EdgeInsets.symmetric(
    horizontal: layout.spaceL,
    vertical: layout.spaceM,
  ),
  decoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(layout.radiusM),
    border: Border.all(color: Theme.of(context).colorScheme.outline),
  ),
  child: Text(buttonText),
)
```

### Feature Chips
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: layout.spaceL,
    vertical: layout.spaceM,
  ),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(layout.radiusS),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: layout.iconM),
      SizedBox(width: layout.spaceS),
      Text(label),
    ],
  ),
)
```

## Responsive Breakpoints
Device-specific adaptations.

```dart
// Device detection
context.device == DeviceSize.phone
context.device == DeviceSize.tablet
context.device == DeviceSize.desktop

// Breakpoint detection
layout.isMobile
layout.isTablet
layout.isDesktop
```

## Performance Optimizations

### Repaint Boundaries
```dart
RepaintBoundary(
  child: ConfettiWidget(
    isActive: isAnimating,
    child: content,
  ),
)
```

### Image Precaching
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _precacheNextStepImage();
  });
}

void _precacheNextStepImage() {
  precacheImage(AssetImage('assets/next_step.png'), context);
}
```

## Accessibility Tokens

### Text Scaling
```dart
// Respects user's text scale preference
layout.textScale // 0.85 - 1.3 range
```

### Contrast Ratios
- Normal text: 4.5:1 (AA)
- Large text: 3:1 (AA)
- UI components: 3:1 (AA)

### Focus Indicators
```dart
// Focus ring for keyboard navigation
BoxDecoration(
  border: Border.all(
    color: Theme.of(context).colorScheme.primary,
    width: 2,
  ),
)
```
