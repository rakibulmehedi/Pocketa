# PocketA Design Specification v2.0
## International Fintech App - Comprehensive UI/UX Design System

---

## 🎯 Design Philosophy

PocketA is a personal finance management app designed for the global market, with special focus on Bangladesh and South Asian markets. The design system emphasizes **trust**, **clarity**, and **accessibility** while maintaining a modern, professional aesthetic that instills confidence in financial management.

### Core Principles
- **Trust First**: Every design decision prioritizes user confidence in financial data
- **Cultural Sensitivity**: Respects local design preferences and cultural contexts
- **Accessibility**: WCAG 2.1 AA compliance with enhanced support for diverse users
- **Performance**: Lightweight, responsive design that works across all devices
- **Consistency**: Unified experience across all touchpoints

---

## 🎨 Visual Design System

### 1. Color Palette

#### Primary Colors
```dart
// Light Theme
primary: #0EA5E9 (sky-500)           // Trust, stability, financial security
onPrimary: #FFFFFF                   // High contrast text on primary
primaryContainer: #E0F2FE            // Subtle primary backgrounds
onPrimaryContainer: #0B6A8F          // Text on primary containers

// Dark Theme  
primary: #38BDF8 (sky-400)           // Softer primary for dark mode
onPrimary: #0B1220                   // Dark text on light primary
primaryContainer: #0B3A53            // Darker primary containers
onPrimaryContainer: #E0F2FE          // Light text on dark containers
```

#### Secondary Colors
```dart
// Light Theme
secondary: #10B981 (emerald-500)     // Growth, success, positive actions
onSecondary: #062D20                 // High contrast on secondary
secondaryContainer: #D1FAE5          // Light secondary backgrounds
onSecondaryContainer: #064E3B        // Text on secondary containers

// Dark Theme
secondary: #34D399 (emerald-400)     // Softer secondary for dark mode
onSecondary: #061A14                 // Dark text on light secondary
secondaryContainer: #065F46          // Darker secondary containers
onSecondaryContainer: #A7F3D0        // Light text on dark containers
```

#### Surface Colors
```dart
// Light Theme
surface: #FFFFFF                     // Main content areas
onSurface: #121417                   // Primary text
surfaceVariant: #F3F5F7              // Subtle backgrounds
onSurfaceVariant: #344055            // Secondary text
background: #F7F9FB                  // App background
onBackground: #0F172A                // Text on background

// Dark Theme
surface: #0B0F14                     // Main content areas
onSurface: #E5EAF0                   // Primary text
surfaceVariant: #121821              // Subtle backgrounds
onSurfaceVariant: #C7D1DE            // Secondary text
background: #070A0F                  // App background
onBackground: #E6EDF5                // Text on background
```

#### Semantic Colors
```dart
// Error States
error: #EF4444 (light) / #F87171 (dark)
onError: #FFFFFF (light) / #1C0C0C (dark)

// Warning States
warning: #F59E0B (light) / #FBBF24 (dark)
onWarning: #FFFFFF (light) / #1C1917 (dark)

// Success States
success: #10B981 (light) / #34D399 (dark)
onSuccess: #FFFFFF (light) / #064E3B (dark)

// Info States
info: #3B82F6 (light) / #60A5FA (dark)
onInfo: #FFFFFF (light) / #1E3A8A (dark)
```

### 2. Typography System

#### Font Stack
```dart
fontFamily: 'Inter'                  // Primary font (Latin scripts)
fontFamilyFallback: [
  'HindSiliguri',                    // Bengali script support
  'NotoSans',                        // Universal fallback
  'system-ui',                       // System fallback
]
```

#### Type Scale
```dart
// Display Styles
displayLarge: 57px / 64px line-height / 400 weight
displayMedium: 45px / 52px line-height / 400 weight
displaySmall: 36px / 44px line-height / 400 weight

// Headline Styles
headlineLarge: 32px / 40px line-height / 400 weight
headlineMedium: 28px / 36px line-height / 400 weight
headlineSmall: 24px / 32px line-height / 400 weight

// Title Styles
titleLarge: 22px / 28px line-height / 500 weight
titleMedium: 16px / 24px line-height / 500 weight
titleSmall: 14px / 20px line-height / 500 weight

// Body Styles
bodyLarge: 16px / 24px line-height / 400 weight
bodyMedium: 14px / 20px line-height / 400 weight
bodySmall: 12px / 16px line-height / 400 weight

// Label Styles
labelLarge: 14px / 20px line-height / 500 weight
labelMedium: 12px / 16px line-height / 500 weight
labelSmall: 11px / 16px line-height / 500 weight
```

### 3. Spacing System

#### Base Unit: 8px Grid System
```dart
// Spacing Tokens
xs: 4px    // 0.5rem - Micro spacing
sm: 8px    // 1rem   - Small spacing
md: 12px   // 1.5rem - Medium spacing
lg: 16px   // 2rem   - Large spacing
xl: 24px   // 3rem   - Extra large spacing
xxl: 32px  // 4rem   - 2X large spacing
xxxl: 48px // 6rem   - 3X large spacing

// Responsive Scaling
phone: base * 1.0
tablet: base * 1.2
desktop: base * 1.4
```

#### Layout Spacing
```dart
// Page Gutters
phone: 16px
tablet: 24px
desktop: 32px

// Component Spacing
buttonPadding: 16px horizontal, 12px vertical
cardPadding: 16px
inputPadding: 12px horizontal, 14px vertical
sectionSpacing: 24px
```

### 4. Border Radius System

```dart
// Radius Tokens
xs: 4px     // Small elements, tags
sm: 8px     // Buttons, small cards
md: 12px    // Cards, inputs, containers
lg: 16px    // Large cards, modals
xl: 24px    // Hero elements, major containers
pill: 999px // Fully rounded elements

// Component-Specific
buttonRadius: 8px
cardRadius: 12px
inputRadius: 12px
modalRadius: 16px
```

### 5. Elevation & Shadows

```dart
// Elevation Levels
level0: 0px   // Flat surfaces
level1: 1px   // Cards, buttons
level2: 3px   // Modals, dropdowns
level3: 6px   // Dialogs, overlays
level4: 8px   // Tooltips, floating elements

// Shadow Configuration
lightTheme: rgba(16, 24, 40, 0.08) with 6px blur, 0px offset
darkTheme: rgba(0, 0, 0, 0.35) with 6px blur, 0px offset
```

---

## 🧩 Component Library

### 1. Buttons

#### Primary Button (FilledButton)
```dart
// Visual Properties
backgroundColor: colorScheme.primary
foregroundColor: colorScheme.onPrimary
borderRadius: 8px
padding: 16px horizontal, 12px vertical
elevation: 1px
minHeight: 48px

// States
hover: scale(1.02) + elevation(2px)
pressed: scale(0.98) + duration(120ms)
disabled: opacity(0.5) + no elevation
loading: spinner + disabled state
```

#### Secondary Button (OutlinedButton)
```dart
// Visual Properties
backgroundColor: transparent
foregroundColor: colorScheme.primary
borderColor: colorScheme.outline
borderWidth: 1px
borderRadius: 8px
padding: 16px horizontal, 12px vertical
minHeight: 48px

// States
hover: backgroundColor(primary.withOpacity(0.08))
pressed: backgroundColor(primary.withOpacity(0.12))
disabled: opacity(0.5)
```

#### Tertiary Button (TextButton)
```dart
// Visual Properties
backgroundColor: transparent
foregroundColor: colorScheme.primary
borderRadius: 8px
padding: 8px horizontal, 8px vertical
minHeight: 40px

// States
hover: backgroundColor(primary.withOpacity(0.08))
pressed: backgroundColor(primary.withOpacity(0.12))
disabled: opacity(0.5)
```

### 2. Cards

#### Standard Card
```dart
// Visual Properties
backgroundColor: colorScheme.surface
borderRadius: 12px
elevation: 1px
padding: 16px
margin: 8px

// Shadow
lightTheme: rgba(16, 24, 40, 0.06) with 6px blur, 0px offset
darkTheme: rgba(0, 0, 0, 0.35) with 6px blur, 0px offset
```

#### Glass Card (Footer Only)
```dart
// Visual Properties
backgroundColor: surface.withOpacity(0.85)
backdropFilter: blur(sigmaX: 8, sigmaY: 8)
borderRadius: 16px
border: 1px solid outline.withOpacity(0.08/0.16)
padding: 12px horizontal, 10px vertical
```

### 3. Input Fields

#### Text Input
```dart
// Visual Properties
backgroundColor: colorScheme.surface
borderColor: colorScheme.outline
borderWidth: 1px
borderRadius: 12px
padding: 12px horizontal, 14px vertical
minHeight: 48px

// States
focused: borderColor(primary) + borderWidth(1.8px)
error: borderColor(error)
disabled: opacity(0.5)
```

#### Amount Input
```dart
// Visual Properties
// Same as text input with additional:
prefix: currency symbol (৳, $, etc.)
suffix: currency code (BDT, USD, etc.)
textAlign: right
inputFormatters: currency formatting
```

### 4. Navigation

#### App Bar
```dart
// Visual Properties
backgroundColor: transparent (over gradient)
scrolledUnderElevation: 3px
titleTextStyle: titleLarge (22px, 500 weight)
iconTheme: onSurface color

// Behavior
- Transparent over gradient background
- Snaps to surface color after 16px scroll
- Smooth transition with 220ms duration
```

#### Bottom Navigation
```dart
// Visual Properties
backgroundColor: colorScheme.surface
indicatorColor: colorScheme.primaryContainer
elevation: 0px
labelBehavior: alwaysShow

// Icons
selected: colorScheme.primary
unselected: colorScheme.onSurfaceVariant
```

### 5. Footer CTA Bar

#### Layout
```dart
// Container
maxWidth: 840px (desktop) / 640px (mobile)
height: 68-72px
padding: 12-16px
borderRadius: 16px

// Background
backdropFilter: blur(sigmaX: 8, sigmaY: 8)
backgroundColor: surface.withOpacity(0.85)
border: 1px solid outline.withOpacity(0.08/0.16)

// Content Layout
Row(Back | Spacer | Primary)
```

#### Buttons
```dart
// Back Button
style: OutlinedButton.icon
icon: arrow_back_ios
label: "Back"
width: flexible

// Primary Button
style: FilledButton
label: dynamic (Continue, Save, etc.)
width: flexible (2x if no back button)
```

---

## 🎭 Motion & Animation

### 1. Duration System

```dart
// Micro-interactions
fast: 120ms      // Press feedback, hover states
normal: 220ms    // Enter/exit animations
slow: 320ms      // Complex transitions

// Staggered Animations
stagger: 60ms    // Between sibling elements
delay: 90ms      // Sequential reveals
```

### 2. Easing Curves

```dart
// Standard Easing
easeOut: Curves.easeOut           // Exit animations
easeInOut: Curves.easeInOut       // State changes
elasticOut: Curves.elasticOut     // Playful interactions

// Custom Easing
fastOutSlowIn: Curves.fastOutSlowIn  // Primary transitions
```

### 3. Animation Patterns

#### Page Transitions
```dart
// Enter Animation
duration: 220ms
curve: fastOutSlowIn
opacity: 0 → 1
scale: 0.95 → 1.0
slide: 20px up → 0

// Exit Animation
duration: 180ms
curve: easeOut
opacity: 1 → 0
scale: 1.0 → 0.95
```

#### Button Interactions
```dart
// Press Feedback
duration: 120ms
scale: 1.0 → 0.98
elevation: +2px

// Hover States
duration: 150ms
scale: 1.0 → 1.02
elevation: +1px
```

#### Confetti Animation
```dart
// Particle Count
particles: 18-28
duration: 600ms
colors: [primary, secondary]
spread: 45 degrees
gravity: 0.5
```

### 4. Reduced Motion Support

```dart
// Respect System Settings
if (MediaQuery.disableAnimations) {
  // Use fade/scale only
  // Remove complex animations
  // Maintain functionality
}
```

---

## 🌍 Internationalization & Accessibility

### 1. Localization Support

#### Supported Languages
- **English (en)**: Primary language
- **Bengali (bn)**: Full RTL support with HindSiliguri font

#### Text Scaling
```dart
// Respect system text scale
textScaleFactor: MediaQuery.textScaleFactorOf(context)
maxScale: 2.0 (prevent UI breaking)
```

#### Date & Currency Formatting
```dart
// Date Format
en: MM/dd/yyyy
bn: dd-MM-yyyy

// Currency Format
BDT: ৳1,234.56
USD: $1,234.56
EUR: €1,234.56
```

### 2. Accessibility Guidelines

#### WCAG 2.1 AA Compliance
```dart
// Color Contrast
normalText: 4.5:1 minimum
largeText: 3:1 minimum
uiComponents: 3:1 minimum

// Focus Indicators
focusColor: colorScheme.primary
focusWidth: 2px
focusOffset: 2px
```

#### Screen Reader Support
```dart
// Semantic Labels
semanticLabel: "Add transaction button"
hint: "Enter amount in Bangladeshi Taka"
value: "1,234.56 BDT"

// Live Regions
announcement: "Transaction added successfully"
polite: "Balance updated"
assertive: "Error: Invalid amount"
```

#### Touch Targets
```dart
// Minimum Size
minTouchTarget: 44x44px
recommendedTouchTarget: 48x48px
spacing: 8px minimum between targets
```

---

## 📱 Responsive Design

### 1. Breakpoint System

```dart
// Device Categories
phone: < 600px width
tablet: 600px - 840px width
desktop: > 840px width

// Layout Constraints
maxContentWidth: 840px
sidebarWidth: 280px (desktop)
footerMaxWidth: 840px
```

### 2. Layout Patterns

#### Mobile-First Approach
```dart
// Base: Mobile layout
// Tablet: Enhanced spacing, larger touch targets
// Desktop: Sidebar navigation, multi-column layouts
```

#### Grid System
```dart
// Columns
phone: 1 column
tablet: 2 columns
desktop: 3+ columns

// Gutters
phone: 16px
tablet: 24px
desktop: 32px
```

---

## 🎨 Background & Gradients

### 1. Background System

#### App Background
```dart
// Light Theme
gradient: linear(top→bottom, #F7F9FB → #FFFFFF)
opacity: 100% (no blur on text)

// Dark Theme
gradient: linear(top→bottom, #070A0F → #0B0F14)
opacity: 100% (no blur on text)
```

#### Card Backgrounds
```dart
// Standard Cards
backgroundColor: colorScheme.surface
elevation: 1px
noGradient: true

// Glass Elements (Footer Only)
backgroundColor: surface.withOpacity(0.85)
backdropFilter: blur(8px)
```

### 2. Gradient Usage Rules

```dart
// DO
- Use gradients only behind scroll content
- Ensure text readability (contrast ≥ 4.5:1)
- Apply to DecoratedBox under CustomScrollView

// DON'T
- Apply gradients over text cards
- Use full-screen blur overlays
- Mix gradient and solid backgrounds inconsistently
```

---

## 🔧 Implementation Guidelines

### 1. Theme Implementation

#### Core Theme Structure
```dart
// lib/core/theme/app_theme.dart
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = isDark ? _darkScheme : _lightScheme;
  
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    // ... component themes
  );
}
```

#### Component Themes
```dart
// Button Themes
filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle)
outlinedButtonTheme: OutlinedButtonThemeData(style: _outlinedButtonStyle)
textButtonTheme: TextButtonThemeData(style: _textButtonStyle)

// Card Themes
cardTheme: CardTheme(
  color: colorScheme.surface,
  elevation: 1,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
)

// Input Themes
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: colorScheme.surface,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
)
```

### 2. Component Usage

#### Footer CTA Bar
```dart
// Global Usage
FooterCtaBar(
  primaryLabel: l10n.continue,
  onPrimary: () => nextStep(),
  showBack: currentStep != OnboardingStep.welcome,
  onBack: () => previousStep(),
)
```

#### Responsive Layout
```dart
// Layout Usage
Responsive.builder(
  child: Column(
    children: [
      // Content with responsive spacing
      Padding(
        padding: EdgeInsets.all(context.layout.spaceL),
        child: content,
      ),
    ],
  ),
)
```

### 3. Motion Implementation

#### Animation Wrapper
```dart
// Motion Wrapper
FadeSlide(
  delay: Motion.d060,
  child: widget,
)

// Scale Tap
ScaleTap(
  onTap: onPressed,
  child: button,
)
```

---

## 📊 Quality Assurance

### 1. Design Review Checklist

#### Visual Consistency
- [ ] All colors use design tokens
- [ ] Typography follows scale system
- [ ] Spacing uses 8px grid
- [ ] Border radius consistent
- [ ] Shadows follow elevation system

#### Accessibility
- [ ] Color contrast meets WCAG 2.1 AA
- [ ] Touch targets ≥ 44px
- [ ] Screen reader labels present
- [ ] Focus indicators visible
- [ ] Text scales properly

#### Responsiveness
- [ ] Mobile layout works (320px+)
- [ ] Tablet layout enhanced (600px+)
- [ ] Desktop layout optimized (840px+)
- [ ] Content doesn't overflow
- [ ] Touch targets appropriate

#### Motion
- [ ] Animations respect reduced motion
- [ ] Durations follow timing system
- [ ] Easing curves appropriate
- [ ] No layout jank
- [ ] Confetti limited to 0.6s

### 2. Testing Scenarios

#### Light Theme Testing
- [ ] Onboarding flow (all 5 screens)
- [ ] Dashboard with charts
- [ ] Transaction forms
- [ ] Settings screens
- [ ] Error states

#### Dark Theme Testing
- [ ] Same screens as light theme
- [ ] Proper contrast ratios
- [ ] Readable text on all surfaces
- [ ] Consistent visual hierarchy

#### Internationalization Testing
- [ ] Bengali text rendering
- [ ] RTL layout support
- [ ] Currency formatting
- [ ] Date formatting
- [ ] Text scaling (0.8x - 2.0x)

---

## 🚀 Future Considerations

### 1. Design System Evolution
- Component library expansion
- Advanced animation patterns
- Enhanced accessibility features
- Multi-platform adaptations

### 2. Performance Optimization
- Lazy loading for complex animations
- Reduced motion alternatives
- Memory-efficient gradient rendering
- Optimized asset delivery

### 3. User Experience Enhancements
- Personalized theme options
- Advanced gesture support
- Voice interaction patterns
- Haptic feedback integration

---

*This design specification serves as the single source of truth for PocketA's visual and interaction design. All implementations should reference this document and maintain consistency with the defined patterns and principles.*
