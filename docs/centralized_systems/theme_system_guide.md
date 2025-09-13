# Theme Management System Guide
## PocketA - Comprehensive Theme System Documentation

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Theme Architecture](#theme-architecture)
3. [Color System](#color-system)
4. [Typography System](#typography-system)
5. [Component Theming](#component-theming)
6. [Theme Provider](#theme-provider)
7. [Implementation Examples](#implementation-examples)
8. [Custom Themes](#custom-themes)
9. [Performance Optimization](#performance-optimization)
10. [Testing Themes](#testing-themes)
11. [Migration Guide](#migration-guide)
12. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA Theme Management System provides a comprehensive, centralized approach to theming across the entire application. It supports light/dark modes, custom themes, and ensures consistency while maintaining excellent performance and accessibility.

### Key Features
- **Material Design 3**: Full Material 3 implementation with custom enhancements
- **Light/Dark Mode**: Seamless theme switching with system preference support
- **Custom Branding**: Easy customization of colors, typography, and components
- **Accessibility**: WCAG 2.1 AA compliant contrast ratios and accessibility features
- **Performance Optimized**: Efficient theme switching with minimal rebuilds
- **State Management**: Riverpod-based theme state management with persistence

---

## 🏗️ Theme Architecture

### Core Theme Structure

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  // Brand color seeds
  static const _brandSeed = Color(0xFF1565C0); // Primary blue
  static const _accentSeed = Color(0xFF2E7D32); // Accent green
  
  // Theme getters
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);
  
  // Theme builder
  static ThemeData _buildTheme(Brightness brightness) {
    // Implementation details...
  }
}
```

### Theme Provider Integration

```dart
// lib/core/providers/theme_provider.dart
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  static const String _themeKey = 'theme_mode';
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = ThemeMode.values[themeIndex];
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
```

---

## 🎨 Color System

### Color Scheme Generation

```dart
class AppTheme {
  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    // Generate color schemes using Material 3 seed colors
    final base = ColorScheme.fromSeed(
      seedColor: _brandSeed, 
      brightness: brightness
    );
    final accent = ColorScheme.fromSeed(
      seedColor: _accentSeed, 
      brightness: brightness
    );
    
    // Custom surface colors
    final surface = isDark 
        ? const Color(0xFF1A1D23) 
        : const Color(0xFFFAFAFA);
    final surfaceContainerHighest = isDark 
        ? const Color(0xFF242831) 
        : const Color(0xFFF0F2F5);
    
    // Combine schemes
    final scheme = base.copyWith(
      secondary: accent.primary,
      onSecondary: accent.onPrimary,
      secondaryContainer: accent.primaryContainer,
      onSecondaryContainer: accent.onPrimaryContainer,
      surface: surface,
      surfaceContainerHighest: surfaceContainerHighest,
    );
    
    return ThemeData(
      colorScheme: scheme,
      // ... other theme properties
    );
  }
}
```

### Color Usage Examples

```dart
// Using theme colors in widgets
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return Container(
    color: colorScheme.surface,
    child: Text(
      'Themed Text',
      style: TextStyle(
        color: colorScheme.onSurface,
        backgroundColor: colorScheme.primaryContainer,
      ),
    ),
  );
}

// Using semantic colors
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  
  return Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.primary,
      border: Border.all(
        color: theme.colorScheme.outline,
        width: 1,
      ),
    ),
    child: Text(
      'Primary Container',
      style: TextStyle(
        color: theme.colorScheme.onPrimary,
      ),
    ),
  );
}
```

### Custom Color Extensions

```dart
// lib/core/theme/color_extensions.dart
extension ColorSchemeExtensions on ColorScheme {
  // Semantic color helpers
  Color get success => secondary;
  Color get warning => tertiary;
  Color get info => primary;
  
  // Surface variations
  Color get surfaceElevated => surfaceContainerHighest;
  Color get surfaceGlass => surface.withValues(alpha: 0.85);
  
  // Text color variations
  Color get textPrimary => onSurface;
  Color get textSecondary => onSurface.withValues(alpha: 0.7);
  Color get textTertiary => onSurface.withValues(alpha: 0.6);
  Color get textDisabled => onSurface.withValues(alpha: 0.38);
  
  // Border color variations
  Color get borderSubtle => outline.withValues(alpha: 0.12);
  Color get borderMedium => outline.withValues(alpha: 0.2);
  Color get borderStrong => outline;
}

// Usage
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  
  return Container(
    decoration: BoxDecoration(
      color: colors.surfaceElevated,
      border: Border.all(color: colors.borderMedium),
    ),
    child: Text(
      'Custom Colors',
      style: TextStyle(color: colors.textPrimary),
    ),
  );
}
```

---

## 📝 Typography System

### Typography Configuration

```dart
// lib/core/theme/app_typography.dart
class AppTypography {
  static TextTheme build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white : Colors.black;
    
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: baseColor,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: baseColor,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: baseColor,
      ),
    );
  }
}
```

### Typography Usage Examples

```dart
// Using theme typography
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Display Title',
        style: textTheme.displayLarge,
      ),
      Text(
        'Headline',
        style: textTheme.headlineMedium,
      ),
      Text(
        'Body text content',
        style: textTheme.bodyLarge,
      ),
      Text(
        'Small label',
        style: textTheme.labelSmall,
      ),
    ],
  );
}

// Custom typography with theme colors
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  
  return Text(
    'Themed Text',
    style: theme.textTheme.headlineMedium?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    ),
  );
}
```

---

## 🧩 Component Theming

### Button Theming

```dart
class AppTheme {
  static ThemeData _buildTheme(Brightness brightness) {
    // ... color scheme setup
    
    // Button state helper
    WidgetStateProperty<T> state<T>(
      T normal, {
      T? selected,
      T? pressed,
      T? disabled,
      T? hovered,
      T? focused,
    }) {
      return WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled) && disabled != null) return disabled;
        if (s.contains(WidgetState.pressed) && pressed != null) return pressed;
        if (s.contains(WidgetState.selected) && selected != null) return selected;
        if (s.contains(WidgetState.hovered) && hovered != null) return hovered;
        if (s.contains(WidgetState.focused) && focused != null) return focused;
        return normal;
      });
    }
    
    // Base button style
    ButtonStyle baseBtn() => ButtonStyle(
      shape: state<OutlinedBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      )),
      padding: state(const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
      minimumSize: state(const Size(200, 48)),
      elevation: state(0.0),
      animationDuration: const Duration(milliseconds: 120),
      splashFactory: InkSparkle.splashFactory,
    );
    
    // Text button style
    final textButtonStyle = baseBtn().copyWith(
      foregroundColor: state(
        scheme.primary,
        disabled: scheme.onSurface.withValues(alpha: 0.38),
      ),
      overlayColor: state(
        scheme.primary.withValues(alpha: 0.08),
        pressed: scheme.primary.withValues(alpha: 0.12),
      ),
    );
    
    // Elevated button style
    final elevatedButtonStyle = baseBtn().copyWith(
      backgroundColor: state(
        scheme.primary,
        pressed: scheme.primary.withValues(alpha: 0.94),
        disabled: scheme.surfaceContainerHighest,
      ),
      foregroundColor: state(
        scheme.onPrimary,
        disabled: scheme.onSurface.withValues(alpha: 0.38),
      ),
    );
    
    return ThemeData(
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
      // ... other button themes
    );
  }
}
```

### Input Field Theming

```dart
class AppTheme {
  static ThemeData _buildTheme(Brightness brightness) {
    // ... other setup
    
    // Input border helper
    OutlineInputBorder inputBorder(Color color, [double width = 1]) => 
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(
          color: scheme.primary, 
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: inputBorder(scheme.outlineVariant),
        focusedBorder: inputBorder(scheme.primary, 1.8),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 1.8),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
      ),
    );
  }
}
```

### Card Theming

```dart
class AppTheme {
  static ThemeData _buildTheme(Brightness brightness) {
    // ... other setup
    
    return ThemeData(
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
```

---

## 🔄 Theme Provider

### Theme State Management

```dart
// lib/core/providers/theme_provider.dart
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  static const String _themeKey = 'theme_mode';
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = ThemeMode.values[themeIndex];
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }
  
  // Convenience methods
  void setLight() => setThemeMode(ThemeMode.light);
  void setDark() => setThemeMode(ThemeMode.dark);
  void setSystem() => setThemeMode(ThemeMode.system);
  
  // Theme name for UI display
  String get themeName {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
```

### Theme Provider Usage

```dart
// In your main app
class PocketaApp extends ConsumerWidget {
  const PocketaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // ... other configuration
    );
  }
}

// In widgets that need theme control
class ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    return PopupMenuButton<ThemeMode>(
      onSelected: themeNotifier.setThemeMode,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(Icons.light_mode),
              SizedBox(width: 8),
              Text('Light'),
              if (themeMode == ThemeMode.light) 
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(Icons.dark_mode),
              SizedBox(width: 8),
              Text('Dark'),
              if (themeMode == ThemeMode.dark) 
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(Icons.settings_system_daydream),
              SizedBox(width: 8),
              Text('System'),
              if (themeMode == ThemeMode.system) 
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ],
      child: Icon(Icons.palette),
    );
  }
}
```

---

## 🚀 Implementation Examples

### Complete Themed Widget

```dart
class ThemedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const ThemedCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

### Themed Form Field

```dart
class ThemedTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  
  const ThemedTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      style: theme.textTheme.bodyLarge,
    );
  }
}
```

### Themed Navigation

```dart
class ThemedBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const ThemedBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
```

---

## 🎨 Custom Themes

### Creating Custom Themes

```dart
// lib/core/theme/custom_themes.dart
class CustomThemes {
  // Brand-specific theme
  static ThemeData brandTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    // Custom brand colors
    final brandSeed = const Color(0xFF6B46C1); // Purple brand
    final accentSeed = const Color(0xFF059669); // Green accent
    
    final base = ColorScheme.fromSeed(
      seedColor: brandSeed,
      brightness: brightness,
    );
    
    final accent = ColorScheme.fromSeed(
      seedColor: accentSeed,
      brightness: brightness,
    );
    
    // Custom surface colors
    final surface = isDark 
        ? const Color(0xFF0F0F23) 
        : const Color(0xFFFAFAFA);
    
    final scheme = base.copyWith(
      secondary: accent.primary,
      surface: surface,
    );
    
    return AppTheme._buildThemeWithScheme(scheme, brightness);
  }
  
  // High contrast theme for accessibility
  static ThemeData highContrastTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0000FF), // High contrast blue
      brightness: brightness,
    ).copyWith(
      primary: isDark ? Colors.white : Colors.black,
      onPrimary: isDark ? Colors.black : Colors.white,
      surface: isDark ? Colors.black : Colors.white,
      onSurface: isDark ? Colors.white : Colors.black,
    );
    
    return AppTheme._buildThemeWithScheme(scheme, brightness);
  }
}
```

### Theme Selection Provider

```dart
// lib/core/providers/theme_selection_provider.dart
enum CustomThemeType {
  defaultTheme,
  brandTheme,
  highContrastTheme,
}

class ThemeSelectionNotifier extends StateNotifier<CustomThemeType> {
  ThemeSelectionNotifier() : super(CustomThemeType.defaultTheme) {
    _loadThemeSelection();
  }
  
  static const String _themeSelectionKey = 'theme_selection';
  
  Future<void> _loadThemeSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeSelectionKey) ?? 0;
    state = CustomThemeType.values[themeIndex];
  }
  
  Future<void> setThemeType(CustomThemeType type) async {
    state = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeSelectionKey, type.index);
  }
}

final themeSelectionProvider = StateNotifierProvider<ThemeSelectionNotifier, CustomThemeType>((ref) {
  return ThemeSelectionNotifier();
});

// Theme getter based on selection
final selectedThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeProvider);
  final themeType = ref.watch(themeSelectionProvider);
  
  final brightness = switch (themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };
  
  return switch (themeType) {
    CustomThemeType.defaultTheme => AppTheme._buildTheme(brightness),
    CustomThemeType.brandTheme => CustomThemes.brandTheme(brightness),
    CustomThemeType.highContrastTheme => CustomThemes.highContrastTheme(brightness),
  };
});
```

---

## ⚡ Performance Optimization

### Efficient Theme Switching

```dart
// Optimized theme provider with caching
class OptimizedThemeNotifier extends StateNotifier<ThemeMode> {
  OptimizedThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  // Cache theme data to avoid rebuilding
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;
  
  ThemeData get lightTheme {
    _cachedLightTheme ??= AppTheme.light;
    return _cachedLightTheme!;
  }
  
  ThemeData get darkTheme {
    _cachedDarkTheme ??= AppTheme.dark;
    return _cachedDarkTheme!;
  }
  
  // Clear cache when needed
  void clearCache() {
    _cachedLightTheme = null;
    _cachedDarkTheme = null;
  }
}
```

### Const Theme Usage

```dart
// Use const constructors for theme-related widgets
class ThemedIconButton extends StatelessWidget {
  const ThemedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });
  
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
```

### Theme-Aware Widget Optimization

```dart
// Optimized theme-aware widget
class OptimizedThemedWidget extends StatelessWidget {
  const OptimizedThemedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Cache theme data at the top level
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Container(
      color: colorScheme.surface,
      child: Column(
        children: [
          Text(
            'Optimized Widget',
            style: textTheme.headlineMedium,
          ),
          Text(
            'Using cached theme data',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🧪 Testing Themes

### Theme Testing Utilities

```dart
// test/theme_test_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ThemeTestUtils {
  static Widget createThemedWidget({
    required Widget child,
    ThemeMode themeMode = ThemeMode.light,
    CustomThemeType customTheme = CustomThemeType.defaultTheme,
  }) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: child,
    );
  }
  
  static void expectThemeColors(WidgetTester tester, {
    required Color expectedPrimary,
    required Color expectedSurface,
  }) {
    final primaryColor = tester.widget<Material>(
      find.byType(Material).first,
    ).color;
    
    expect(primaryColor, expectedPrimary);
  }
}
```

### Theme Unit Tests

```dart
// test/theme_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme has correct colors', () {
      final theme = AppTheme.light;
      final colorScheme = theme.colorScheme;
      
      expect(colorScheme.brightness, Brightness.light);
      expect(colorScheme.primary, isNotNull);
      expect(colorScheme.surface, isNotNull);
    });
    
    test('dark theme has correct colors', () {
      final theme = AppTheme.dark;
      final colorScheme = theme.colorScheme;
      
      expect(colorScheme.brightness, Brightness.dark);
      expect(colorScheme.primary, isNotNull);
      expect(colorScheme.surface, isNotNull);
    });
    
    test('themes have consistent structure', () {
      final lightTheme = AppTheme.light;
      final darkTheme = AppTheme.dark;
      
      expect(lightTheme.textTheme.displayLarge, isNotNull);
      expect(darkTheme.textTheme.displayLarge, isNotNull);
      
      expect(lightTheme.buttonTheme, isNotNull);
      expect(darkTheme.buttonTheme, isNotNull);
    });
  });
}
```

### Widget Tests with Themes

```dart
// test/themed_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/theme/app_theme.dart';

void main() {
  group('Themed Widget Tests', () {
    testWidgets('renders correctly in light theme', (tester) async {
      await tester.pumpWidget(
        ThemeTestUtils.createThemedWidget(
          themeMode: ThemeMode.light,
          child: const ThemedCard(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        ),
      );
      
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });
    
    testWidgets('renders correctly in dark theme', (tester) async {
      await tester.pumpWidget(
        ThemeTestUtils.createThemedWidget(
          themeMode: ThemeMode.dark,
          child: const ThemedCard(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        ),
      );
      
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });
    
    testWidgets('theme switching works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const ThemeToggleButton(),
        ),
      );
      
      // Test theme toggle
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();
      
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });
  });
}
```

---

## 🔄 Migration Guide

### From Hardcoded Colors to Theme System

```dart
// Before - Hardcoded colors
Container(
  color: Colors.blue,
  child: Text(
    'Content',
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
);

// After - Theme system
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Content',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
);
```

### From Custom Themes to Centralized System

```dart
// Before - Custom theme in widget
Widget build(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      primaryColor: Colors.purple,
      textTheme: Theme.of(context).textTheme.copyWith(
        headline1: TextStyle(color: Colors.purple),
      ),
    ),
    child: MyWidget(),
  );
}

// After - Centralized theme system
Widget build(BuildContext context) {
  return MyWidget(); // Uses global theme automatically
}
```

### From Theme.of(context) to Provider Pattern

```dart
// Before - Direct theme access
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Container(color: theme.primaryColor);
}

// After - Provider pattern
class ThemedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final theme = themeMode == ThemeMode.dark ? AppTheme.dark : AppTheme.light;
    
    return Container(color: theme.colorScheme.primary);
  }
}
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_theme/
├── lib/
│   ├── theme.dart                    # Main export
│   ├── app_theme.dart               # Core theme definitions
│   ├── app_typography.dart          # Typography system
│   ├── custom_themes.dart           # Custom theme variants
│   ├── providers/
│   │   ├── theme_provider.dart      # Theme state management
│   │   └── theme_selection_provider.dart
│   ├── extensions/
│   │   └── color_scheme_extensions.dart
│   └── widgets/
│       ├── theme_toggle_button.dart
│       └── themed_widgets.dart
├── test/
│   ├── theme_test.dart
│   ├── theme_test_utils.dart
│   └── themed_widget_test.dart
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_theme
description: Comprehensive theme system for Flutter applications
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_theme:
    git:
      url: https://github.com/your-org/pocketa_theme.git
      ref: main

// In your app
import 'package:pocketa_theme/theme.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: MyHomePage(),
    );
  }
}

// In your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.colorScheme.primary,
      child: Text(
        'Themed Text',
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
```

---

This comprehensive theme system guide provides everything needed to implement, maintain, and extend a centralized theme system across multiple projects. The system is designed to be flexible, performant, and easy to use while providing powerful theming capabilities.
