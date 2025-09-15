# Design System Documentation

This document outlines the comprehensive design system used in the Pocketa application.

## Table of Contents

- [Overview](#overview)
- [Color Palette](#color-palette)
- [Typography](#typography)
- [Spacing](#spacing)
- [Components](#components)
- [Responsive Design](#responsive-design)
- [Accessibility](#accessibility)
- [Animation Guidelines](#animation-guidelines)

## Overview

The Pocketa design system is built on modern design principles with a focus on financial applications. It provides a consistent, accessible, and responsive user experience across all platforms.

### Design Principles

- **Clarity**: Clear visual hierarchy and information architecture
- **Consistency**: Uniform design language across all components
- **Accessibility**: Inclusive design for all users
- **Responsiveness**: Adapts to different screen sizes and orientations
- **Performance**: Optimized for smooth interactions

## Color Palette

### Primary Colors

```dart
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  // Secondary colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFFB2DFDB);
}
```

### Semantic Colors

```dart
class AppColors {
  // Success colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color successDark = Color(0xFF388E3C);
  
  // Error colors
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color errorDark = Color(0xFFD32F2F);
  
  // Warning colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color warningDark = Color(0xFFF57C00);
  
  // Info colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFBBDEFB);
  static const Color infoDark = Color(0xFF1976D2);
}
```

### Neutral Colors

```dart
class AppColors {
  // Grayscale
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50 = Color(0xFFFAFAFA);
}
```

### Financial Colors

```dart
class AppColors {
  // Income (positive)
  static const Color income = Color(0xFF4CAF50);
  static const Color incomeLight = Color(0xFFC8E6C9);
  static const Color incomeDark = Color(0xFF388E3C);
  
  // Expense (negative)
  static const Color expense = Color(0xFFF44336);
  static const Color expenseLight = Color(0xFFFFCDD2);
  static const Color expenseDark = Color(0xFFD32F2F);
  
  // Transfer (neutral)
  static const Color transfer = Color(0xFF9E9E9E);
  static const Color transferLight = Color(0xFFE0E0E0);
  static const Color transferDark = Color(0xFF616161);
}
```

## Typography

### Font Families

```dart
class AppFonts {
  static const String primary = 'Inter';
  static const String secondary = 'Noto Sans';
  static const String display = 'Hind Siliguri';
}
```

### Text Styles

```dart
class AppTextStyles {
  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );
  
  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
```

## Spacing

### Spacing Scale

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
```

### Component Spacing

```dart
class AppSpacing {
  // Button spacing
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );
  
  // Card spacing
  static const EdgeInsets cardPadding = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets cardMargin = EdgeInsets.all(AppSpacing.sm);
  
  // Input field spacing
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );
  
  // Screen spacing
  static const EdgeInsets screenPadding = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets screenMargin = EdgeInsets.all(AppSpacing.sm);
}
```

## Components

### Buttons

#### Primary Button

```dart
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  });
}
```

**Variants:**
- `ButtonVariant.filled` - Solid background
- `ButtonVariant.outlined` - Outlined border
- `ButtonVariant.text` - Text only

**Sizes:**
- `ButtonSize.small` - 32px height
- `ButtonSize.medium` - 40px height
- `ButtonSize.large` - 48px height

#### Secondary Button

```dart
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  });
}
```

### Input Fields

#### Text Input

```dart
class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.variant = InputFieldVariant.outlined,
    this.size = InputFieldSize.medium,
  });
}
```

**Variants:**
- `InputFieldVariant.outlined` - Outlined border
- `InputFieldVariant.filled` - Filled background
- `InputFieldVariant.underlined` - Underlined style

**Sizes:**
- `InputFieldSize.small` - 32px height
- `InputFieldSize.medium` - 40px height
- `InputFieldSize.large` - 48px height

### Cards

#### Section Card

```dart
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.elevation = 2,
  });
}
```

**Properties:**
- `child` - Card content
- `title` - Card title
- `subtitle` - Card subtitle
- `actions` - Action buttons
- `elevation` - Shadow elevation

### Chips

#### Custom Chip

```dart
class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.selected = false,
    this.variant = ChipVariant.filled,
  });
}
```

**Variants:**
- `ChipVariant.filled` - Filled background
- `ChipVariant.outlined` - Outlined border
- `ChipVariant.flat` - Flat style

## Responsive Design

### Breakpoints

```dart
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

### Responsive Utilities

```dart
class Responsive {
  static bool isMobile(BuildContext context) => 
    MediaQuery.of(context).size.width < AppBreakpoints.mobile;
  
  static bool isTablet(BuildContext context) => 
    MediaQuery.of(context).size.width >= AppBreakpoints.mobile && 
    MediaQuery.of(context).size.width < AppBreakpoints.tablet;
  
  static bool isDesktop(BuildContext context) => 
    MediaQuery.of(context).size.width >= AppBreakpoints.tablet;
}
```

### Responsive Layout

```dart
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (Responsive.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
```

## Accessibility

### Color Contrast

All color combinations meet WCAG 2.1 AA standards:

- **Normal Text**: 4.5:1 contrast ratio
- **Large Text**: 3:1 contrast ratio
- **UI Components**: 3:1 contrast ratio

### Touch Targets

- **Minimum Size**: 44x44 logical pixels
- **Spacing**: 8px minimum between touch targets
- **Visual Feedback**: Clear pressed states

### Screen Reader Support

- **Semantic Labels**: All interactive elements have labels
- **Focus Management**: Logical focus order
- **Announcements**: Important state changes are announced

### Keyboard Navigation

- **Tab Order**: Logical tab sequence
- **Focus Indicators**: Clear focus indicators
- **Keyboard Shortcuts**: Common shortcuts supported

## Animation Guidelines

### Duration

```dart
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
```

### Easing

```dart
class AppEasing {
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounce = Curves.bounceOut;
}
```

### Animation Types

#### Fade Transitions

```dart
class FadeTransition extends StatelessWidget {
  const FadeTransition({
    super.key,
    required this.child,
    required this.animation,
  });
}
```

#### Slide Transitions

```dart
class SlideTransition extends StatelessWidget {
  const SlideTransition({
    super.key,
    required this.child,
    required this.animation,
    this.slideOffset = const Offset(0, 1),
  });
}
```

#### Scale Transitions

```dart
class ScaleTransition extends StatelessWidget {
  const ScaleTransition({
    super.key,
    required this.child,
    required this.animation,
    this.scale = 1.0,
  });
}
```

## Usage Guidelines

### Color Usage

1. **Primary Colors**: Use for main actions and branding
2. **Semantic Colors**: Use for status indicators and feedback
3. **Neutral Colors**: Use for text, backgrounds, and borders
4. **Financial Colors**: Use for income/expense indicators

### Typography Usage

1. **Display Styles**: Use for large headings and hero text
2. **Headline Styles**: Use for section headings
3. **Body Styles**: Use for regular text content
4. **Label Styles**: Use for form labels and small text

### Spacing Usage

1. **Consistent Spacing**: Use the spacing scale consistently
2. **Visual Hierarchy**: Use spacing to create visual hierarchy
3. **Touch Targets**: Ensure adequate spacing for touch targets
4. **Content Density**: Balance content density with readability

### Component Usage

1. **Consistent Styling**: Use components as designed
2. **Accessibility**: Ensure all components are accessible
3. **Responsiveness**: Test components on different screen sizes
4. **Performance**: Use components efficiently to maintain performance
