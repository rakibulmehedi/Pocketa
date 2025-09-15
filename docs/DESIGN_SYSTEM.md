# Pocketa Design System

## Overview

The Pocketa design system provides a comprehensive set of design tokens, components, and guidelines to ensure consistency and quality across the application.

## Design Principles

### 1. Consistency
- Unified visual language across all screens
- Consistent spacing, typography, and color usage
- Standardized component behavior and interactions

### 2. Accessibility
- WCAG 2.1 AA compliance
- High contrast ratios for text and backgrounds
- Support for screen readers and assistive technologies
- Scalable text and touch targets

### 3. Responsiveness
- Adaptive layouts for phone, tablet, and desktop
- Fluid typography and spacing scales
- Context-aware component sizing

### 4. Performance
- Optimized for 60+ FPS animations
- Efficient rendering with minimal rebuilds
- Lightweight components and assets

## Color System

### Primary Colors
```dart
class AppColors {
  // Primary brand colors
  static Color primary(BuildContext context) => const Color(0xFF2196F3);
  static Color primaryVariant(BuildContext context) => const Color(0xFF1976D2);
  static Color onPrimary(BuildContext context) => const Color(0xFFFFFFFF);
  
  // Secondary colors
  static Color secondary(BuildContext context) => const Color(0xFF03DAC6);
  static Color secondaryVariant(BuildContext context) => const Color(0xFF018786);
  static Color onSecondary(BuildContext context) => const Color(0xFF000000);
  
  // Surface colors
  static Color surface(BuildContext context) => const Color(0xFFFFFFFF);
  static Color surfaceVariant(BuildContext context) => const Color(0xFFF5F5F5);
  static Color onSurface(BuildContext context) => const Color(0xFF212121);
  
  // Background colors
  static Color background(BuildContext context) => const Color(0xFFFAFAFA);
  static Color onBackground(BuildContext context) => const Color(0xFF212121);
}
```

### Semantic Colors
```dart
class AppColors {
  // Status colors
  static Color success(BuildContext context) => const Color(0xFF4CAF50);
  static Color warning(BuildContext context) => const Color(0xFFFF9800);
  static Color error(BuildContext context) => const Color(0xFFF44336);
  static Color info(BuildContext context) => const Color(0xFF2196F3);
  
  // Text colors
  static Color textPrimary(BuildContext context) => const Color(0xFF212121);
  static Color textSecondary(BuildContext context) => const Color(0xFF757575);
  static Color textDisabled(BuildContext context) => const Color(0xFFBDBDBD);
  
  // Border colors
  static Color borderLight(BuildContext context) => const Color(0xFFE0E0E0);
  static Color borderMedium(BuildContext context) => const Color(0xFFBDBDBD);
  static Color borderDark(BuildContext context) => const Color(0xFF757575);
}
```

### Dark Theme Colors
```dart
class AppColors {
  // Dark theme overrides
  static Color surfaceDark(BuildContext context) => const Color(0xFF121212);
  static Color surfaceVariantDark(BuildContext context) => const Color(0xFF1E1E1E);
  static Color onSurfaceDark(BuildContext context) => const Color(0xFFFFFFFF);
  
  static Color backgroundDark(BuildContext context) => const Color(0xFF000000);
  static Color onBackgroundDark(BuildContext context) => const Color(0xFFFFFFFF);
}
```

## Typography System

### Font Families
```dart
class AppFonts {
  static const String primary = 'Roboto';
  static const String secondary = 'Inter';
  static const String monospace = 'JetBrains Mono';
}
```

### Text Styles
```dart
class AppTextStyles {
  // Display styles
  static TextStyle responsiveDisplay(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return layout.responsiveTextStyle(
      phone: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
      ),
      tablet: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 32,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
      ),
      desktop: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 36,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
      ),
    );
  }
  
  // Title styles
  static TextStyle responsiveTitle(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return layout.responsiveTextStyle(
      phone: theme.textTheme.titleMedium!.copyWith(
        fontSize: 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
      ),
      tablet: theme.textTheme.titleMedium!.copyWith(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
      ),
      desktop: theme.textTheme.titleMedium!.copyWith(
        fontSize: 24,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
      ),
    );
  }
  
  // Body styles
  static TextStyle responsiveBody(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
      ),
      tablet: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 15,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
      ),
      desktop: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
      ),
    );
  }
  
  // Caption styles
  static TextStyle responsiveCaption(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
      ),
      tablet: theme.textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
      ),
      desktop: theme.textTheme.bodySmall!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
      ),
    );
  }
}
```

## Spacing System

### Spacing Scale
```dart
class AppSpacing {
  static const double xs = 4.0;   // Extra small
  static const double s = 8.0;    // Small
  static const double m = 16.0;   // Medium
  static const double l = 24.0;   // Large
  static const double xl = 32.0;  // Extra large
  static const double xxl = 48.0; // Extra extra large
}
```

### Responsive Spacing
```dart
class AppSize {
  // Base spacing
  double get spaceXS => 4.0;
  double get spaceS => 8.0;
  double get spaceM => 16.0;
  double get spaceL => 24.0;
  double get spaceXL => 32.0;
  double get spaceXXL => 48.0;
  
  // Page spacing
  EdgeInsets get pageGutter => EdgeInsets.symmetric(
    horizontal: responsiveSize(phone: 16, tablet: 24, desktop: 32),
  );
  
  // Component spacing
  EdgeInsets get componentPadding => EdgeInsets.all(
    responsiveSize(phone: 12, tablet: 16, desktop: 20),
  );
}
```

## Border Radius System

### Radius Scale
```dart
class AppRadius {
  static const double xs = 2.0;   // Extra small
  static const double s = 4.0;    // Small
  static const double m = 8.0;    // Medium
  static const double l = 12.0;   // Large
  static const double xl = 16.0;  // Extra large
  static const double xxl = 24.0; // Extra extra large
  static const double full = 999.0; // Fully rounded
}
```

### Responsive Radius
```dart
class AppSize {
  double get radiusXS => 2.0;
  double get radiusS => 4.0;
  double get radiusM => 8.0;
  double get radiusL => 12.0;
  double get radiusXL => 16.0;
  double get radiusXXL => 24.0;
  double get radiusFull => 999.0;
}
```

## Shadow System

### Elevation Levels
```dart
class AppShadows {
  static List<BoxShadow> level1(BuildContext context) => [
    BoxShadow(
      color: AppColors.shadowLight(context),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> level2(BuildContext context) => [
    BoxShadow(
      color: AppColors.shadowLight(context),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> level3(BuildContext context) => [
    BoxShadow(
      color: AppColors.shadowLight(context),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> level4(BuildContext context) => [
    BoxShadow(
      color: AppColors.shadowLight(context),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
```

## Animation System

### Duration Scale
```dart
class AppDurations {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
}
```

### Easing Curves
```dart
class AppCurves {
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;
}
```

### Animation Utilities
```dart
class UnifiedAnimations {
  // Fade animations
  static Widget fadeIn({
    required Widget child,
    Duration duration = AppDurations.normal,
    Curve curve = AppCurves.easeOut,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: curve),
      ),
      child: child,
    );
  }
  
  // Slide animations
  static Widget slideIn({
    required Widget child,
    Duration duration = AppDurations.normal,
    Curve curve = AppCurves.easeOut,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: curve),
      ),
      child: child,
    );
  }
  
  // Scale animations
  static Widget scaleIn({
    required Widget child,
    Duration duration = AppDurations.normal,
    Curve curve = AppCurves.easeOut,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: curve),
      ),
      child: child,
    );
  }
}
```

## Component System

### Button Components

#### Primary Button
```dart
class PositiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  
  const PositiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary(context),
        foregroundColor: AppColors.onPrimary(context),
        padding: layout.componentPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radiusM),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.onPrimary(context),
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: layout.responsiveIconSize()),
                  SizedBox(width: layout.spaceS),
                ],
                Text(
                  text,
                  style: AppTextStyles.responsiveButton(context),
                ),
              ],
            ),
    );
  }
}
```

#### Secondary Button
```dart
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary(context),
        side: BorderSide(color: AppColors.primary(context)),
        padding: layout.componentPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radiusM),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary(context),
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: layout.responsiveIconSize()),
                  SizedBox(width: layout.spaceS),
                ],
                Text(
                  text,
                  style: AppTextStyles.responsiveButton(context),
                ),
              ],
            ),
    );
  }
}
```

### Input Components

#### Text Field
```dart
class AppTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  
  const AppTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  });
  
  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  size: layout.responsiveIconSize(),
                  color: _isFocused
                      ? AppColors.primary(context)
                      : AppColors.textSecondary(context),
                )
              : null,
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: AppColors.surface(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(layout.radiusM),
            borderSide: BorderSide(color: AppColors.borderLight(context)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(layout.radiusM),
            borderSide: BorderSide(color: AppColors.borderLight(context)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(layout.radiusM),
            borderSide: BorderSide(color: AppColors.primary(context), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(layout.radiusM),
            borderSide: BorderSide(color: AppColors.error(context)),
          ),
          contentPadding: layout.componentPadding,
        ),
      ),
    );
  }
}
```

### Card Components

#### Section Card
```dart
class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  
  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.trailing,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusL),
      ),
      color: backgroundColor ?? AppColors.surface(context),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(layout.radiusL),
        child: Padding(
          padding: padding ?? layout.componentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null || subtitle != null || trailing != null)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: AppTextStyles.responsiveTitle(context),
                            ),
                          if (subtitle != null) ...[
                            SizedBox(height: layout.spaceXS),
                            Text(
                              subtitle!,
                              style: AppTextStyles.responsiveCaption(context),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              if (child != null) ...[
                if (title != null || subtitle != null)
                  SizedBox(height: layout.spaceM),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## Responsive Design

### Breakpoints
```dart
class AppBreakpoints {
  static const double phone = 360;
  static const double tablet = 768;
  static const double desktop = 1200;
}
```

### Responsive Utilities
```dart
class Responsive {
  static Widget builder({
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final device = _getDeviceType(width);
        final layout = AppSize(device: device);
        
        return _ResponsiveProvider(
          layout: layout,
          child: child,
        );
      },
    );
  }
  
  static DeviceSize _getDeviceType(double width) {
    if (width < AppBreakpoints.tablet) {
      return DeviceSize.phone;
    } else if (width < AppBreakpoints.desktop) {
      return DeviceSize.tablet;
    } else {
      return DeviceSize.desktop;
    }
  }
}
```

## Accessibility

### Accessibility Guidelines
- Minimum touch target size: 44x44 points
- Color contrast ratio: 4.5:1 for normal text, 3:1 for large text
- Support for screen readers with semantic labels
- Keyboard navigation support
- High contrast mode support

### Accessibility Implementation
```dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  
  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.semanticLabel,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
```

## Usage Guidelines

### 1. Color Usage
- Use primary colors for main actions and branding
- Use semantic colors for status indicators
- Maintain sufficient contrast ratios
- Test with colorblind users

### 2. Typography
- Use appropriate text styles for content hierarchy
- Maintain consistent line heights and spacing
- Test with different font sizes
- Ensure readability across devices

### 3. Spacing
- Use the spacing scale consistently
- Maintain visual rhythm and balance
- Test on different screen sizes
- Consider content density

### 4. Components
- Use existing components when possible
- Extend components rather than creating new ones
- Maintain consistent behavior
- Test accessibility features

### 5. Animations
- Use appropriate durations and easing
- Provide reduced motion alternatives
- Test performance on low-end devices
- Ensure animations enhance rather than distract
