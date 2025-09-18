# 🔧 UI Components API Reference

Complete API reference for all UI components in the Pocketa app.

## 📋 Contents

- [App Bars](#app-bars)
- [Buttons](#buttons)
- [Cards](#cards)
- [Dialogs](#dialogs)
- [Lists](#lists)
- [Indicators](#indicators)
- [Chips](#chips)
- [Forms](#forms)
- [Menus](#menus)
- [Performance](#performance)
- [Summary](#summary)
- [Enums](#enums)

---

## App Bars

### CustomAppBar

Enhanced app bar with premium fintech design.

```dart
const CustomAppBar({
  Key? key,
  required String title,
  String? subtitle,
  bool showBack = false,
  VoidCallback? onBackTap,
  VoidCallback? onMenuTap,
  List<Widget>? actions,
  String? trailingPillText,
  IconData? trailingPillIcon,
  Color? trailingPillColor,
  Color? accentColor,
  double height = kToolbarHeight,
  PreferredSizeWidget? bottom,
  bool enableHaptic = true,
  Duration animationDuration = const Duration(milliseconds: 200),
})
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | **required** | Main title text |
| `subtitle` | `String?` | `null` | Optional subtitle under title |
| `showBack` | `bool` | `false` | Show back button instead of menu |
| `onBackTap` | `VoidCallback?` | `null` | Custom back button handler |
| `onMenuTap` | `VoidCallback?` | `null` | Custom menu button handler |
| `actions` | `List<Widget>?` | `null` | Additional action buttons |
| `trailingPillText` | `String?` | `null` | Text for trailing metric pill |
| `trailingPillIcon` | `IconData?` | `null` | Icon for trailing pill |
| `trailingPillColor` | `Color?` | `null` | Color for trailing pill |
| `accentColor` | `Color?` | `null` | Accent color for pill |
| `height` | `double` | `kToolbarHeight` | App bar height |
| `bottom` | `PreferredSizeWidget?` | `null` | Bottom widget (e.g., TabBar) |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |
| `animationDuration` | `Duration` | `200ms` | Animation duration |

### CustomSliverAppBar

Enhanced sliver app bar with collapsible design.

```dart
const CustomSliverAppBar({
  Key? key,
  required String title,
  String? subtitle,
  Widget? flexibleSpace,
  bool pinned = true,
  bool floating = false,
  bool snap = false,
  double expandedHeight = 200.0,
  double collapsedHeight = kToolbarHeight,
  List<Widget>? actions,
  String? trailingPillText,
  IconData? trailingPillIcon,
  Color? trailingPillColor,
  Color? accentColor,
  bool showBack = false,
  VoidCallback? onBackTap,
  VoidCallback? onMenuTap,
  PreferredSizeWidget? bottom,
  bool enableHaptic = true,
  Duration animationDuration = const Duration(milliseconds: 300),
})
```

---

## Buttons

### AppButton

Performance-optimized button with multiple styles and states.

```dart
const AppButton({
  Key? key,
  required String text,
  VoidCallback? onPressed,
  AppButtonStyle style = AppButtonStyle.primary,
  AppButtonSize size = AppButtonSize.medium,
  IconData? icon,
  bool isLoading = false,
  bool isFullWidth = false,
  bool enableHaptic = true,
  Duration animationDuration = const Duration(milliseconds: 150),
})
```

**Styles:**
- `AppButtonStyle.primary` - Primary action button
- `AppButtonStyle.secondary` - Secondary action button  
- `AppButtonStyle.outline` - Outlined button
- `AppButtonStyle.text` - Text-only button

**Sizes:**
- `AppButtonSize.small` - Compact button
- `AppButtonSize.medium` - Standard button
- `AppButtonSize.large` - Prominent button

### QuickButton

Quick action buttons for common tasks.

```dart
const QuickButton({
  Key? key,
  required String label,
  IconData? icon,
  required VoidCallback onPressed,
  bool isPositive = true,
  bool enableHaptic = true,
})
```

### ResponsiveIconButton

Responsive icon button that adapts to screen size.

```dart
const ResponsiveIconButton({
  Key? key,
  required IconData icon,
  VoidCallback? onPressed,
  String? tooltip,
  Color? color,
  Color? backgroundColor,
  double? size,
  EdgeInsetsGeometry? padding,
  bool isSelected = false,
})
```

---

## Cards

### SectionCard

Consistent section card with header.

```dart
const SectionCard({
  Key? key,
  required String title,
  String? subtitle,
  Widget? trailing,
  required List<Widget> children,
  EdgeInsetsGeometry? padding,
  bool enableHover = true,
  Duration animationDuration = const Duration(milliseconds: 200),
})
```

### InteractiveCard

Reusable interactive card with micro-interactions.

```dart
const InteractiveCard({
  Key? key,
  required String title,
  String? subtitle,
  required Widget child,
  bool isSelected = false,
  VoidCallback? onTap,
  Duration animationDuration = const Duration(milliseconds: 200),
  Curve animationCurve = Curves.easeInOut,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Color? backgroundColor,
  Color? selectedColor,
  BorderRadius? borderRadius,
  List<BoxShadow>? boxShadow,
  Border? border,
  bool enableHapticFeedback = true,
  bool enableSound = false,
})
```

### PersonalizationCard

Specialized card for personalization options.

```dart
const PersonalizationCard({
  Key? key,
  required String title,
  String? subtitle,
  required List<CardOption> options,
  required List<dynamic> selectedValues,
  required Function(List<dynamic>) onSelectionChanged,
  bool allowMultiSelect = false,
  required PersonalizationCardType cardType,
})
```

### ResponsiveGrid

Auto-responsive grid component.

```dart
const ResponsiveGrid({
  Key? key,
  required List<Widget> children,
  int? crossAxisCount,
  double mainAxisSpacing = 8.0,
  double crossAxisSpacing = 8.0,
  EdgeInsetsGeometry? padding,
  ScrollController? controller,
  bool shrinkWrap = false,
  ScrollPhysics? physics,
  String? cacheKey,
})
```

---

## Dialogs

### AppDialog

Premium interactive dialog component.

```dart
const AppDialog({
  Key? key,
  String? title,
  required Widget content,
  List<Widget>? actions,
  bool showCloseButton = true,
  double? maxWidth,
  EdgeInsetsGeometry? contentPadding,
  bool enableHaptic = true,
})
```

### AppConfirmationDialog

Confirmation dialog with standard actions.

```dart
const AppConfirmationDialog({
  Key? key,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
})
```

---

## Lists

### AppListTile

Premium interactive list tile.

```dart
const AppListTile({
  Key? key,
  Widget? leading,
  required Widget title,
  Widget? subtitle,
  Widget? trailing,
  VoidCallback? onTap,
  bool enableHover = true,
  Duration animationDuration = const Duration(milliseconds: 150),
})
```

### OptimizedListView

Performance-optimized list view.

```dart
const OptimizedListView({
  Key? key,
  required List<Widget> children,
  EdgeInsetsGeometry? padding,
  ScrollController? controller,
  bool shrinkWrap = false,
  ScrollPhysics? physics,
  String? cacheKey,
})
```

### OptimizedGridView

Performance-optimized grid view.

```dart
const OptimizedGridView({
  Key? key,
  required List<Widget> children,
  required int crossAxisCount,
  double mainAxisSpacing = 8.0,
  double crossAxisSpacing = 8.0,
  EdgeInsetsGeometry? padding,
  ScrollController? controller,
  bool shrinkWrap = false,
  ScrollPhysics? physics,
  String? cacheKey,
})
```

---

## Indicators

### AppLoadingIndicator

Premium loading indicator.

```dart
const AppLoadingIndicator({
  Key? key,
  double size = 24.0,
  Color? color,
  double strokeWidth = 2.0,
  String? message,
  bool showMessage = false,
  Duration animationDuration = const Duration(milliseconds: 1200),
})
```

### EmptyState

Enhanced empty state component.

```dart
const EmptyState({
  Key? key,
  required IconData icon,
  required String title,
  String? subtitle,
  Widget? action,
  Color? iconColor,
  double iconSize = 64.0,
})
```

---

## Chips

### FeatureChip

Feature selection chip with responsive sizing.

```dart
const FeatureChip({
  Key? key,
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  bool isSelected = false,
  Color? accentColor,
})
```

### OptionChip

Option selection chip with responsive sizing.

```dart
const OptionChip({
  Key? key,
  required String label,
  required String value,
  required bool isSelected,
  required VoidCallback onTap,
  Color? accentColor,
})
```

### IncomeOptionChip

Income type chip with responsive sizing.

```dart
const IncomeOptionChip({
  Key? key,
  required String label,
  required IconData icon,
  required IncomeType value,
  required bool isSelected,
  required VoidCallback onTap,
  Color? accentColor,
})
```

---

## Forms

### AppTextFormField

Enhanced text form field with consistent styling.

```dart
const AppTextFormField({
  Key? key,
  required String label,
  TextEditingController? controller,
  String? initialValue,
  IconData? prefixIcon,
  Widget? suffix,
  String? prefixText,
  TextStyle? prefixStyle,
  String? suffixText,
  TextStyle? suffixStyle,
  TextInputType keyboardType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.done,
  List<TextInputFormatter>? inputFormatters,
  int maxLines = 1,
  int minLines = 1,
  bool readOnly = false,
  bool enabled = true,
  bool autofocus = false,
  String? helperText,
  String? hintText,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  VoidCallback? onTap,
})
```

### AmountField

Amount input field with currency formatting.

```dart
const AmountField({
  Key? key,
  required TextEditingController controller,
  String label = 'Amount',
  String? currencySymbol,
  ValueChanged<String>? onChanged,
})
```

### AppDateTimeField

Date and time input field.

```dart
const AppDateTimeField({
  Key? key,
  required String label,
  required DateTime valueUtc,
  required ValueChanged<DateTime> onChanged,
  IconData prefixIcon = Icons.event_outlined,
  bool enable = true,
})
```

### AppDropdownField

Dropdown field with consistent styling.

```dart
const AppDropdownField<T>({
  Key? key,
  required String label,
  required T initialValue,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T?> onChanged,
  String? Function(T?)? validator,
  IconData? prefixIcon,
  bool isDense = false,
})
```

### NoteField

Note input field for additional text.

```dart
const NoteField({
  Key? key,
  required TextEditingController controller,
})
```

---

## Menus

### MoreMenu

More options menu with delete and extra options.

```dart
const MoreMenu({
  Key? key,
  VoidCallback? onDelete,
  List<PopupMenuEntry>? extraItems,
})
```

### LanguageToggleButton

Language toggle button with segmented control.

```dart
const LanguageToggleButton({Key? key})
```

---

## Performance

### OptimizedWidget

Performance-optimized widget wrapper.

```dart
const OptimizedWidget({
  Key? key,
  required Widget child,
  String? cacheKey,
})
```

### MemoizedWidget

Memoized widget for expensive computations.

```dart
const MemoizedWidget({
  Key? key,
  required Widget Function() builder,
  required List<dynamic> dependencies,
})
```

### InteractiveWrapper

Interactive wrapper with haptic feedback and animations.

```dart
const InteractiveWrapper({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  bool enableHaptic = true,
  Duration animationDuration = const Duration(milliseconds: 150),
})
```

---

## Summary

### SummaryHeader

Summary header with gradient background.

```dart
const SummaryHeader({
  Key? key,
  required String title,
  String? subtitle,
  Widget? trailing,
  Color? gradientStart,
  Color? gradientEnd,
})
```

### SummaryRow

Summary row with income, expense, and net cards.

```dart
const SummaryRow({
  Key? key,
  required double income,
  required double expense,
  required double net,
  String? currencySymbol,
  bool compact = false,
})
```

---

## Enums

### AppButtonStyle

```dart
enum AppButtonStyle {
  primary,    // Primary action button
  secondary,  // Secondary action button
  outline,    // Outlined button
  text,       // Text-only button
}
```

### AppButtonSize

```dart
enum AppButtonSize {
  small,   // Compact button
  medium,  // Standard button
  large,   // Prominent button
}
```

### AppSnackbarType

```dart
enum AppSnackbarType {
  success,  // Success messages
  error,    // Error messages
  warning,  // Warning messages
  info,     // Information messages
}
```

### PersonalizationCardType

```dart
enum PersonalizationCardType {
  income,       // Income-related personalization
  language,     // Language selection
  currency,     // Currency selection
  preferences,  // General preferences
  goals,        // Goal setting
  habits,       // Habit tracking
}
```

### AppLanguage

```dart
enum AppLanguage {
  en,  // English language
  bn,  // Bengali language
}
```

---

## 🎨 Theming Integration

All components integrate with the `AppColors` system:

```dart
// Primary colors
AppColors.primary(context)
AppColors.onPrimary(context)

// Semantic colors
AppColors.success(context)
AppColors.error(context)
AppColors.warning(context)

// Text colors
AppColors.textPrimary(context)
AppColors.textSecondary(context)

// Surface colors
AppColors.surface(context)
AppColors.surfaceElevated(context)
```

## 📱 Responsive Design

Components automatically adapt to screen sizes:

```dart
// Responsive sizing
layout.responsiveSize(
  phone: 20,
  tablet: 24,
  desktop: 28,
)

// Responsive spacing
layout.insetsAll(2)  // Adapts to screen size
```

## ⚡ Performance Features

- **RepaintBoundary**: All heavy widgets are wrapped
- **Caching**: Colors and expensive computations are cached
- **Optimization**: Unnecessary rebuilds are prevented
- **Memory Management**: Proper disposal of resources
