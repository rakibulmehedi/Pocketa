# 🎨 UI Components Documentation

A comprehensive collection of performance-optimized, responsive UI components for the Pocketa app. Built with Material 3 design principles, haptic feedback, and advanced performance optimizations.

## 📋 Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Core Components](#core-components)
- [Layout Components](#layout-components)
- [Interactive Components](#interactive-components)
- [Performance Features](#performance-features)
- [Responsive Design](#responsive-design)
- [Theming](#theming)
- [Examples](#examples)
- [Best Practices](#best-practices)

## 🚀 Overview

The UI Components library provides a complete set of premium, performance-optimized widgets designed specifically for fintech applications. All components are built with:

- **Material 3 Design System**
- **Performance Optimizations** (RepaintBoundary, caching)
- **Responsive Design** (phone/tablet/desktop)
- **Haptic Feedback** integration
- **AppColors** theme integration
- **Accessibility** support

## 📦 Installation

```dart
import 'package:pocketa/shared/widgets/ui_components.dart';
```

## 🎯 Core Components

### CustomAppBar

A premium app bar with fintech-focused design and advanced features.

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

**Features:**
- Smart back/menu handling with haptic feedback
- Optional subtitle and trailing metric pill
- Responsive typography and spacing
- Performance-optimized with RepaintBoundary
- Material 3 design with subtle animations

**Properties:**
- `title` (String, required): Main title text
- `subtitle` (String?): Optional subtitle under title
- `showBack` (bool): Show back button instead of menu
- `trailingPillText` (String?): Text for trailing metric pill
- `trailingPillIcon` (IconData?): Icon for trailing pill
- `trailingPillColor` (Color?): Color for trailing pill
- `actions` (List<Widget>?): Additional action buttons
- `enableHaptic` (bool): Enable haptic feedback
- `animationDuration` (Duration): Animation duration

### CustomSliverAppBar

Enhanced sliver app bar with collapsible design and flexible space.

```dart
CustomSliverAppBar(
  title: 'Transactions',
  subtitle: 'Your recent activity',
  expandedHeight: 200.0,
  pinned: true,
  floating: true,
  flexibleSpace: CustomFlexibleSpace(),
)
```

**Features:**
- Collapsible design with smooth animations
- Flexible space with custom content
- Performance-optimized scrolling
- Responsive design for all screen sizes

### AppButton

Performance-optimized button with multiple styles and states.

```dart
AppButton(
  text: 'Add Transaction',
  icon: Icons.add,
  style: AppButtonStyle.primary,
  size: AppButtonSize.large,
  onPressed: () {},
  isLoading: false,
  isFullWidth: true,
)
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

### AppCard

Premium interactive card with subtle hover effects.

```dart
AppCard(
  onTap: () {},
  padding: EdgeInsets.all(16),
  elevation: 4,
  child: Column(
    children: [
      Text('Card Content'),
      // ... more content
    ],
  ),
)
```

## 🏗️ Layout Components

### SectionCard

Consistent section card with header and content.

```dart
SectionCard(
  title: 'Quick Actions',
  subtitle: 'Tap to perform common tasks',
  trailing: IconButton(
    icon: Icon(Icons.settings),
    onPressed: () {},
  ),
  children: [
    QuickButton(label: 'Add Transaction', onPressed: () {}),
    QuickButton(label: 'View Reports', onPressed: () {}),
  ],
)
```

### ResponsiveGrid

Auto-responsive grid that adapts to device size.

```dart
ResponsiveGrid(
  children: transactionCards,
  cacheKey: 'transactions',
  mainAxisSpacing: 16.0,
  crossAxisSpacing: 16.0,
)
```

**Responsive Behavior:**
- **Phone**: 1 column
- **Tablet**: 2 columns  
- **Desktop**: 3 columns

### EmptyState

Enhanced empty state with customizable content.

```dart
EmptyState(
  icon: Icons.receipt_long_outlined,
  title: 'No transactions yet',
  subtitle: 'Start by adding your first transaction',
  action: AppButton(
    text: 'Add Transaction',
    onPressed: () {},
  ),
)
```

## 🎮 Interactive Components

### QuickButton

Quick action buttons for common tasks.

```dart
QuickButton(
  label: 'Quick Action',
  icon: Icons.add,
  isPositive: true,
  onPressed: () {},
)
```

### AppDialog

Premium interactive dialog component.

```dart
AppDialog(
  title: 'Confirm Action',
  content: Text('Are you sure you want to proceed?'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel'),
    ),
    ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Confirm'),
    ),
  ],
)
```

### AppSnackbar

Premium interactive snackbar with multiple types.

```dart
AppSnackbar(
  message: 'Transaction added successfully',
  type: AppSnackbarType.success,
  action: () {},
  actionLabel: 'Undo',
)
```

**Types:**
- `AppSnackbarType.success` - Success messages
- `AppSnackbarType.error` - Error messages
- `AppSnackbarType.warning` - Warning messages
- `AppSnackbarType.info` - Information messages

## ⚡ Performance Features

### RepaintBoundary

All heavy widgets are wrapped with `RepaintBoundary` for optimal performance.

```dart
RepaintBoundary(
  child: CustomAppBar(
    title: 'Dashboard',
    // ... other properties
  ),
)
```

### OptimizedWidget

Prevents unnecessary rebuilds by isolating widget updates.

```dart
OptimizedWidget(
  cacheKey: 'transaction_list',
  child: ListView.builder(
    itemBuilder: (context, index) => TransactionTile(),
  ),
)
```

### MemoizedWidget

Caches expensive computations to avoid recalculation.

```dart
MemoizedWidget(
  dependencies: [transactionList, filterOptions],
  builder: () => ExpensiveComputationWidget(),
)
```

## 📱 Responsive Design

All components automatically adapt to different screen sizes:

### Device Sizes
- **Phone**: Compact layout, single column
- **Tablet**: Medium layout, two columns
- **Desktop**: Spacious layout, three columns

### Responsive Utilities
```dart
// Typography scales with device
Text(
  'Title',
  style: theme.textTheme.titleLarge?.copyWith(
    fontSize: layout.responsiveSize(
      phone: 20,
      tablet: 24,
      desktop: 28,
    ),
  ),
)

// Spacing adapts to screen size
Padding(
  padding: layout.insetsAll(2), // Responsive padding
  child: content,
)
```

## 🎨 Theming

All components integrate with the `AppColors` system for consistent theming:

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

## 📚 Examples

### Complete Transaction Form

```dart
class TransactionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Transaction',
        subtitle: 'Enter transaction details',
        showBack: true,
        trailingPillText: '৳ 0',
        trailingPillIcon: Icons.account_balance_wallet,
      ),
      body: ListView(
        children: [
          SectionCard(
            title: 'Amount',
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '৳ ',
                ),
              ),
            ],
          ),
          SectionCard(
            title: 'Category',
            children: [
              CategoryChipsPicker(),
            ],
          ),
          SectionCard(
            title: 'Details',
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: AppButton(
            text: 'Save Transaction',
            icon: Icons.save,
            isFullWidth: true,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
```

### Transaction List with Sliver App Bar

```dart
class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Transactions',
            subtitle: 'Your recent activity',
            expandedHeight: 200.0,
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => TransactionTile(
                transaction: transactions[index],
              ),
              childCount: transactions.length,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Empty State with Action

```dart
class EmptyTransactionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No transactions yet',
      subtitle: 'Start by adding your first transaction to track your expenses',
      action: AppButton(
        text: 'Add Transaction',
        icon: Icons.add,
        onPressed: () => Navigator.pushNamed(context, '/add_transaction'),
      ),
    );
  }
}
```

## ✅ Best Practices

### 1. Performance
- Always use `RepaintBoundary` for heavy widgets
- Use `OptimizedWidget` for complex layouts
- Implement `MemoizedWidget` for expensive computations
- Cache colors with `AppColors` system

### 2. Responsive Design
- Use `layout.responsiveSize()` for responsive dimensions
- Test on different screen sizes
- Use `ResponsiveGrid` for adaptive layouts
- Leverage device-specific breakpoints

### 3. Accessibility
- Provide meaningful tooltips
- Use semantic labels
- Ensure proper contrast ratios
- Test with screen readers

### 4. Theming
- Use `AppColors` for consistent theming
- Avoid hardcoded colors
- Test in both light and dark modes
- Use theme-aware colors

### 5. User Experience
- Enable haptic feedback for interactions
- Use appropriate animation durations
- Provide loading states
- Handle empty states gracefully

## 🔧 Customization

### Custom App Bar

```dart
CustomAppBar(
  title: 'Custom Title',
  subtitle: 'Custom subtitle',
  trailingPillText: 'Custom metric',
  trailingPillColor: Colors.blue,
  accentColor: Colors.green,
  enableHaptic: true,
  animationDuration: Duration(milliseconds: 300),
)
```

### Custom Button Styles

```dart
AppButton(
  text: 'Custom Button',
  style: AppButtonStyle.outline,
  size: AppButtonSize.large,
  enableHaptic: true,
  animationDuration: Duration(milliseconds: 200),
)
```

### Custom Snackbar

```dart
AppSnackbar(
  message: 'Custom message',
  type: AppSnackbarType.info,
  duration: Duration(seconds: 5),
  action: () {},
  actionLabel: 'Custom Action',
  enableHaptic: true,
)
```

## 🐛 Troubleshooting

### Common Issues

1. **Performance Issues**
   - Ensure `RepaintBoundary` is used on heavy widgets
   - Check for unnecessary rebuilds
   - Use `OptimizedWidget` for complex layouts

2. **Responsive Issues**
   - Test on different screen sizes
   - Use `layout.responsiveSize()` for dimensions
   - Check device breakpoints

3. **Theme Issues**
   - Use `AppColors` instead of hardcoded colors
   - Check theme context availability
   - Ensure proper color contrast

4. **Animation Issues**
   - Check animation duration settings
   - Ensure proper animation controllers
   - Test haptic feedback settings

## 📄 License

This UI Components library is part of the Pocketa app and follows the same licensing terms.

## 🤝 Contributing

When contributing to UI components:

1. Follow the existing code style
2. Add comprehensive documentation
3. Include performance optimizations
4. Test on multiple screen sizes
5. Ensure accessibility compliance

---

**Built with ❤️ for the Pocketa app**
