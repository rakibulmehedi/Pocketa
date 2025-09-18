# 🔧 UI Components API Reference

Complete API reference for all UI components in the Pocketa app.

## 📋 Contents

- [CustomAppBar](#customappbar)
- [CustomSliverAppBar](#customsliverappbar)
- [AppButton](#appbutton)
- [AppCard](#appcard)
- [QuickButton](#quickbutton)
- [AppDialog](#appdialog)
- [AppConfirmationDialog](#appconfirmationdialog)
- [AppSnackbar](#appsnackbar)
- [AppListTile](#applisttile)
- [OptimizedListView](#optimizedlistview)
- [OptimizedGridView](#optimizedgridview)
- [SectionCard](#sectioncard)
- [ResponsiveGrid](#responsivegrid)
- [AppLoadingIndicator](#apploadingindicator)
- [EmptyState](#emptystate)
- [OptimizedWidget](#optimizedwidget)
- [MemoizedWidget](#memoizedwidget)
- [Enums](#enums)

---

## CustomAppBar

Enhanced app bar with premium fintech design.

### Constructor

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

### Properties

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

### Example

```dart
CustomAppBar(
  title: 'Dashboard',
  subtitle: 'Welcome back, John',
  showBack: true,
  trailingPillText: '৳ 12,450',
  trailingPillIcon: Icons.trending_up,
  trailingPillColor: AppColors.success(context),
  actions: [
    IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ],
)
```

---

## CustomSliverAppBar

Enhanced sliver app bar with collapsible design.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | **required** | Main title text |
| `subtitle` | `String?` | `null` | Optional subtitle |
| `flexibleSpace` | `Widget?` | `null` | Custom flexible space content |
| `pinned` | `bool` | `true` | Pin app bar when scrolling |
| `floating` | `bool` | `false` | Float app bar when scrolling up |
| `snap` | `bool` | `false` | Snap app bar when scrolling |
| `expandedHeight` | `double` | `200.0` | Height when expanded |
| `collapsedHeight` | `double` | `kToolbarHeight` | Height when collapsed |
| `actions` | `List<Widget>?` | `null` | Action buttons |
| `trailingPillText` | `String?` | `null` | Trailing pill text |
| `trailingPillIcon` | `IconData?` | `null` | Trailing pill icon |
| `trailingPillColor` | `Color?` | `null` | Trailing pill color |
| `accentColor` | `Color?` | `null` | Accent color |
| `showBack` | `bool` | `false` | Show back button |
| `onBackTap` | `VoidCallback?` | `null` | Back button handler |
| `onMenuTap` | `VoidCallback?` | `null` | Menu button handler |
| `bottom` | `PreferredSizeWidget?` | `null` | Bottom widget |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |
| `animationDuration` | `Duration` | `300ms` | Animation duration |

---

## AppButton

Performance-optimized button with multiple styles.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `String` | **required** | Button text |
| `onPressed` | `VoidCallback?` | `null` | Press handler |
| `style` | `AppButtonStyle` | `primary` | Button style |
| `size` | `AppButtonSize` | `medium` | Button size |
| `icon` | `IconData?` | `null` | Optional icon |
| `isLoading` | `bool` | `false` | Show loading state |
| `isFullWidth` | `bool` | `false` | Full width button |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |
| `animationDuration` | `Duration` | `150ms` | Animation duration |

### Styles

- `AppButtonStyle.primary` - Primary action button
- `AppButtonStyle.secondary` - Secondary action button  
- `AppButtonStyle.outline` - Outlined button
- `AppButtonStyle.text` - Text-only button

### Sizes

- `AppButtonSize.small` - Compact button
- `AppButtonSize.medium` - Standard button
- `AppButtonSize.large` - Prominent button

---

## AppCard

Premium interactive card with hover effects.

### Constructor

```dart
const AppCard({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  EdgeInsetsGeometry? padding,
  double? elevation,
  bool enableHover = true,
  Duration animationDuration = const Duration(milliseconds: 200),
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | **required** | Card content |
| `onTap` | `VoidCallback?` | `null` | Tap handler |
| `padding` | `EdgeInsetsGeometry?` | `null` | Card padding |
| `elevation` | `double?` | `null` | Card elevation |
| `enableHover` | `bool` | `true` | Enable hover effects |
| `animationDuration` | `Duration` | `200ms` | Animation duration |

---

## QuickButton

Quick action buttons for common tasks.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | **required** | Button label |
| `icon` | `IconData?` | `null` | Optional icon |
| `onPressed` | `VoidCallback` | **required** | Press handler |
| `isPositive` | `bool` | `true` | Positive/negative styling |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |

---

## AppDialog

Premium interactive dialog component.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String?` | `null` | Dialog title |
| `content` | `Widget` | **required** | Dialog content |
| `actions` | `List<Widget>?` | `null` | Action buttons |
| `showCloseButton` | `bool` | `true` | Show close button |
| `maxWidth` | `double?` | `null` | Maximum width |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Content padding |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |

---

## AppConfirmationDialog

Confirmation dialog with standard actions.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | **required** | Dialog title |
| `message` | `String` | **required** | Dialog message |
| `confirmText` | `String?` | `null` | Confirm button text |
| `cancelText` | `String?` | `null` | Cancel button text |
| `onConfirm` | `VoidCallback?` | `null` | Confirm handler |
| `onCancel` | `VoidCallback?` | `null` | Cancel handler |

---

## AppSnackbar

Premium interactive snackbar component.

### Constructor

```dart
const AppSnackbar({
  Key? key,
  required String message,
  AppSnackbarType type = AppSnackbarType.info,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? action,
  String? actionLabel,
  bool enableHaptic = true,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `message` | `String` | **required** | Snackbar message |
| `type` | `AppSnackbarType` | `info` | Snackbar type |
| `duration` | `Duration` | `3s` | Display duration |
| `action` | `VoidCallback?` | `null` | Action handler |
| `actionLabel` | `String?` | `null` | Action label |
| `enableHaptic` | `bool` | `true` | Enable haptic feedback |

### Types

- `AppSnackbarType.success` - Success messages
- `AppSnackbarType.error` - Error messages
- `AppSnackbarType.warning` - Warning messages
- `AppSnackbarType.info` - Information messages

---

## AppListTile

Premium interactive list tile.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `leading` | `Widget?` | `null` | Leading widget |
| `title` | `Widget` | **required** | Title widget |
| `subtitle` | `Widget?` | `null` | Subtitle widget |
| `trailing` | `Widget?` | `null` | Trailing widget |
| `onTap` | `VoidCallback?` | `null` | Tap handler |
| `enableHover` | `bool` | `true` | Enable hover effects |
| `animationDuration` | `Duration` | `150ms` | Animation duration |

---

## OptimizedListView

Performance-optimized list view.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | **required** | List children |
| `padding` | `EdgeInsetsGeometry?` | `null` | List padding |
| `controller` | `ScrollController?` | `null` | Scroll controller |
| `shrinkWrap` | `bool` | `false` | Shrink wrap |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `cacheKey` | `String?` | `null` | Cache key for performance |

---

## OptimizedGridView

Performance-optimized grid view.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | **required** | Grid children |
| `crossAxisCount` | `int` | **required** | Cross axis count |
| `mainAxisSpacing` | `double` | `8.0` | Main axis spacing |
| `crossAxisSpacing` | `double` | `8.0` | Cross axis spacing |
| `padding` | `EdgeInsetsGeometry?` | `null` | Grid padding |
| `controller` | `ScrollController?` | `null` | Scroll controller |
| `shrinkWrap` | `bool` | `false` | Shrink wrap |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `cacheKey` | `String?` | `null` | Cache key for performance |

---

## SectionCard

Consistent section card with header.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | **required** | Section title |
| `subtitle` | `String?` | `null` | Section subtitle |
| `trailing` | `Widget?` | `null` | Trailing widget |
| `children` | `List<Widget>` | **required** | Section content |
| `padding` | `EdgeInsetsGeometry?` | `null` | Card padding |
| `enableHover` | `bool` | `true` | Enable hover effects |
| `animationDuration` | `Duration` | `200ms` | Animation duration |

---

## ResponsiveGrid

Auto-responsive grid component.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | **required** | Grid children |
| `crossAxisCount` | `int?` | `null` | Override cross axis count |
| `mainAxisSpacing` | `double` | `8.0` | Main axis spacing |
| `crossAxisSpacing` | `double` | `8.0` | Cross axis spacing |
| `padding` | `EdgeInsetsGeometry?` | `null` | Grid padding |
| `controller` | `ScrollController?` | `null` | Scroll controller |
| `shrinkWrap` | `bool` | `false` | Shrink wrap |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `cacheKey` | `String?` | `null` | Cache key for performance |

### Responsive Behavior

- **Phone**: 1 column
- **Tablet**: 2 columns
- **Desktop**: 3 columns

---

## AppLoadingIndicator

Premium loading indicator.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `size` | `double` | `24.0` | Indicator size |
| `color` | `Color?` | `null` | Indicator color |
| `strokeWidth` | `double` | `2.0` | Stroke width |
| `message` | `String?` | `null` | Loading message |
| `showMessage` | `bool` | `false` | Show message |
| `animationDuration` | `Duration` | `1200ms` | Animation duration |

---

## EmptyState

Enhanced empty state component.

### Constructor

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

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `IconData` | **required** | Empty state icon |
| `title` | `String` | **required** | Empty state title |
| `subtitle` | `String?` | `null` | Empty state subtitle |
| `action` | `Widget?` | `null` | Action button |
| `iconColor` | `Color?` | `null` | Icon color |
| `iconSize` | `double` | `64.0` | Icon size |

---

## OptimizedWidget

Performance-optimized widget wrapper.

### Constructor

```dart
const OptimizedWidget({
  Key? key,
  required Widget child,
  String? cacheKey,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | **required** | Child widget |
| `cacheKey` | `String?` | `null` | Cache key for performance |

---

## MemoizedWidget

Memoized widget for expensive computations.

### Constructor

```dart
const MemoizedWidget({
  Key? key,
  required Widget Function() builder,
  required List<dynamic> dependencies,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `builder` | `Widget Function()` | **required** | Widget builder |
| `dependencies` | `List<dynamic>` | **required** | Dependencies to watch |

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
