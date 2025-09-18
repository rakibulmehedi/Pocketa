# 🎨 UI Components - Organized Structure

This directory contains all UI components organized by category for better maintainability and usage.

## 📁 Directory Structure

```
lib/shared/ui_components/
├── app_bars/           # App bar components
│   └── app_bars.dart   # CustomAppBar, CustomSliverAppBar
├── buttons/            # Button components
│   └── buttons.dart    # AppButton, QuickButton, enums
├── dialogs/            # Dialog components
│   └── dialogs.dart    # AppDialog, AppConfirmationDialog
├── lists/              # List components
│   └── lists.dart      # AppListTile, OptimizedListView, OptimizedGridView
├── performance/        # Performance utilities
│   ├── performance.dart    # OptimizedWidget, MemoizedWidget
│   └── interactive_wrapper.dart # InteractiveWrapper
├── cards/              # Card components
│   └── cards.dart      # SectionCard, ResponsiveGrid
├── indicators/         # Loading and state indicators
│   └── indicators.dart # AppLoadingIndicator, EmptyState
├── ui_components.dart  # Main export file
└── README.md          # This file
```

## 🚀 Usage

### Import All Components
```dart
import 'package:pocketa/shared/ui_components/ui_components.dart';
```

### Import Specific Categories
```dart
// Import only app bars
import 'package:pocketa/shared/ui_components/app_bars/app_bars.dart';

// Import only buttons
import 'package:pocketa/shared/ui_components/buttons/buttons.dart';

// Import only dialogs
import 'package:pocketa/shared/ui_components/dialogs/dialogs.dart';
```

## 📋 Component Categories

### 🏗️ App Bars
- **CustomAppBar** - Enhanced app bar with premium fintech design
- **CustomSliverAppBar** - Collapsible sliver app bar with flexible space

### 🔘 Buttons
- **AppButton** - Performance-optimized button with multiple styles
- **QuickButton** - Quick action buttons for common tasks
- **Enums**: `AppButtonStyle`, `AppButtonSize`

### 💬 Dialogs
- **AppDialog** - Premium interactive dialog component
- **AppConfirmationDialog** - Standard confirmation dialog

### 📋 Lists
- **AppListTile** - Premium interactive list tile
- **OptimizedListView** - Performance-optimized list view
- **OptimizedGridView** - Performance-optimized grid view

### ⚡ Performance
- **OptimizedWidget** - Prevents unnecessary rebuilds
- **MemoizedWidget** - Caches expensive computations
- **InteractiveWrapper** - Haptic feedback and animations

### 🃏 Cards
- **SectionCard** - Consistent section card with header
- **ResponsiveGrid** - Auto-responsive grid component

### 📊 Indicators
- **AppLoadingIndicator** - Premium loading indicator
- **EmptyState** - Enhanced empty state component

## ✨ Benefits

1. **Better Organization** - Components grouped by functionality
2. **Easier Maintenance** - Each component in its own file
3. **Selective Imports** - Import only what you need
4. **Clear Dependencies** - Easy to see component relationships
5. **Scalability** - Easy to add new components to appropriate categories

## 🔧 Development Guidelines

### Adding New Components
1. Choose the appropriate category folder
2. Add the component to the existing file or create a new one
3. Export the component in the category's main file
4. Update the main `ui_components.dart` if needed

### File Naming
- Use descriptive names: `app_bars.dart`, `buttons.dart`
- Keep related components in the same file
- Use snake_case for file names

### Component Organization
- Group related components together
- Keep enums with their related components
- Separate performance utilities into their own category

## 📚 Examples

### Using App Bars
```dart
import 'package:pocketa/shared/ui_components/app_bars/app_bars.dart';

CustomAppBar(
  title: 'Dashboard',
  subtitle: 'Welcome back',
  trailingPillText: '৳ 12,450',
  actions: [
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

### Using Buttons
```dart
import 'package:pocketa/shared/ui_components/buttons/buttons.dart';

AppButton(
  text: 'Save',
  icon: Icons.save,
  style: AppButtonStyle.primary,
  size: AppButtonSize.large,
  onPressed: () {},
)
```

### Using Performance Components
```dart
import 'package:pocketa/shared/ui_components/performance/performance.dart';

OptimizedWidget(
  cacheKey: 'expensive_widget',
  child: ExpensiveWidget(),
)

MemoizedWidget(
  dependencies: [data, filter],
  builder: () => ExpensiveComputation(data, filter),
)
```

---

**Built with ❤️ for the Pocketa app**
