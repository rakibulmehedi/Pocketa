# 🎨 Pocketa UI Components

A comprehensive collection of performance-optimized, responsive UI components for the Pocketa app.

## 🚀 Quick Start

```dart
import 'package:pocketa/shared/widgets/widgets.dart';
// or
import 'package:pocketa/shared/ui_components/ui_components.dart';
```

## 📋 Component Categories

### 🏗️ App Bars
- **CustomAppBar** - Enhanced app bar with premium fintech design
- **CustomSliverAppBar** - Collapsible sliver app bar with flexible space

### 🔘 Buttons
- **AppButton** - Performance-optimized button with multiple styles
- **QuickButton** - Quick action buttons for common tasks
- **ResponsiveIconButton** - Responsive icon button that adapts to screen size

### 🃏 Cards
- **SectionCard** - Consistent section card with header
- **InteractiveCard** - Reusable interactive card with micro-interactions
- **PersonalizationCard** - Specialized card for personalization options
- **ResponsiveGrid** - Auto-responsive grid component

### 💬 Dialogs
- **AppDialog** - Premium interactive dialog component
- **AppConfirmationDialog** - Standard confirmation dialog

### 📋 Lists
- **AppListTile** - Premium interactive list tile
- **OptimizedListView** - Performance-optimized list view
- **OptimizedGridView** - Performance-optimized grid view

### 📊 Indicators
- **AppLoadingIndicator** - Premium loading indicator
- **EmptyState** - Enhanced empty state component

### 🎨 Chips
- **FeatureChip** - Feature selection chips
- **OptionChip** - Option selection chips
- **IncomeOptionChip** - Income type chips

### 📝 Forms
- **AppTextFormField** - Enhanced text form field
- **AmountField** - Amount input with currency formatting
- **AppDateTimeField** - Date and time picker
- **AppDropdownField** - Dropdown field
- **NoteField** - Note input field

### 🎛️ Menus
- **MoreMenu** - More options menu
- **LanguageToggleButton** - Language selection button

### ⚡ Performance
- **OptimizedWidget** - Prevents unnecessary rebuilds
- **MemoizedWidget** - Caches expensive computations
- **InteractiveWrapper** - Haptic feedback and animations

### 📈 Summary
- **SummaryHeader** - Summary header with gradient
- **SummaryRow** - Summary row with glass cards

## 🎯 Essential Examples

### App Bar
```dart
CustomAppBar(
  title: 'Dashboard',
  subtitle: 'Welcome back',
  trailingPillText: '৳ 12,450',
  actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
)
```

### Button
```dart
AppButton(
  text: 'Save',
  icon: Icons.save,
  style: AppButtonStyle.primary,
  size: AppButtonSize.large,
  onPressed: () {},
)
```

### Card
```dart
SectionCard(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  children: [
    ListTile(title: Text('Option 1')),
    ListTile(title: Text('Option 2')),
  ],
)
```

### Dialog
```dart
AppDialog(
  title: 'Confirm Action',
  content: Text('Are you sure?'),
  actions: [
    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Confirm')),
  ],
)
```

## 🎨 Design System

### Colors
```dart
AppColors.primary(context)      // Primary color
AppColors.success(context)      // Success color
AppColors.error(context)        // Error color
AppColors.warning(context)      // Warning color
```

### Responsive Sizing
```dart
layout.responsiveSize(
  phone: 20,
  tablet: 24,
  desktop: 28,
)
```

## ⚡ Performance Features

- **RepaintBoundary**: All heavy widgets are wrapped
- **Caching**: Colors and expensive computations are cached
- **Optimization**: Unnecessary rebuilds are prevented
- **Memory Management**: Proper disposal of resources

## 📚 Detailed Documentation

For comprehensive documentation, see:
- [Component API Reference](docs/API_REFERENCE.md)
- [Advanced Examples](docs/EXAMPLES.md)
- [Performance Guide](docs/PERFORMANCE.md)

## 🔧 Services

### Snackbar Service
```dart
SnackbarService.showSuccess(context, message: 'Success!');
SnackbarService.showError(context, message: 'Error occurred');
SnackbarService.showWarning(context, message: 'Warning message');
SnackbarService.showInfo(context, message: 'Information');
```

### Loading Service
```dart
LoadingService.show(context, message: 'Loading...');
LoadingService.hide(context);
LoadingService.showWithSuccess(context, operation: () async {
  // Your operation
});
```

## 🚀 Best Practices

1. **Use RepaintBoundary** for heavy widgets
2. **Use responsive sizing** for different screen sizes
3. **Use AppColors** for consistent theming
4. **Enable haptic feedback** for better UX
5. **Test on multiple screen sizes**

---

**Built with ❤️ for the Pocketa app**
