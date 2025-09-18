# 🚀 UI Components Quick Start Guide

Get up and running with the Pocketa UI Components in minutes!

## 📦 Import

```dart
import 'package:pocketa/shared/widgets/ui_components.dart';
```

## 🎯 Essential Components

### 1. App Bar

```dart
// Basic app bar
CustomAppBar(
  title: 'Dashboard',
  showBack: true,
)

// Advanced app bar with pill
CustomAppBar(
  title: 'Transactions',
  subtitle: 'Your recent activity',
  trailingPillText: '৳ 12,450',
  trailingPillIcon: Icons.trending_up,
  actions: [
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () {},
    ),
  ],
)
```

### 2. Buttons

```dart
// Primary button
AppButton(
  text: 'Save',
  onPressed: () {},
)

// Button with icon
AppButton(
  text: 'Add Transaction',
  icon: Icons.add,
  style: AppButtonStyle.primary,
  size: AppButtonSize.large,
  isFullWidth: true,
  onPressed: () {},
)

// Quick action button
QuickButton(
  label: 'Quick Action',
  icon: Icons.bolt,
  onPressed: () {},
)
```

### 3. Cards

```dart
// Basic card
AppCard(
  child: Text('Card content'),
)

// Interactive card
AppCard(
  onTap: () {},
  child: Column(
    children: [
      Text('Title'),
      Text('Description'),
    ],
  ),
)

// Section card
SectionCard(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  trailing: IconButton(
    icon: Icon(Icons.settings),
    onPressed: () {},
  ),
  children: [
    ListTile(title: Text('Option 1')),
    ListTile(title: Text('Option 2')),
  ],
)
```

### 4. Lists

```dart
// Optimized list
OptimizedListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
  ],
  cacheKey: 'my_list',
)

// Responsive grid
ResponsiveGrid(
  children: [
    Card(child: Text('Grid Item 1')),
    Card(child: Text('Grid Item 2')),
  ],
)
```

### 5. Dialogs

```dart
// Basic dialog
AppDialog(
  title: 'Confirm Action',
  content: Text('Are you sure?'),
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

// Confirmation dialog
AppConfirmationDialog(
  title: 'Delete Item',
  message: 'This action cannot be undone.',
  onConfirm: () {
    // Delete logic
    Navigator.pop(context);
  },
)
```

### 6. Snackbars

```dart
// Success snackbar
AppSnackbar(
  message: 'Transaction saved!',
  type: AppSnackbarType.success,
)

// Error snackbar with action
AppSnackbar(
  message: 'Failed to save',
  type: AppSnackbarType.error,
  action: () {},
  actionLabel: 'Retry',
)
```

### 7. Empty States

```dart
// Basic empty state
EmptyState(
  icon: Icons.receipt_long_outlined,
  title: 'No transactions yet',
  subtitle: 'Start by adding your first transaction',
)

// Empty state with action
EmptyState(
  icon: Icons.inbox_outlined,
  title: 'Inbox empty',
  subtitle: 'All caught up!',
  action: AppButton(
    text: 'Refresh',
    onPressed: () {},
  ),
)
```

## 🏗️ Complete Example

Here's a complete screen using multiple components:

```dart
class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transactions',
        subtitle: 'Manage your expenses',
        trailingPillText: '৳ 1,234',
        trailingPillIcon: Icons.account_balance_wallet,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          SectionCard(
            title: 'Quick Actions',
            children: [
              Row(
                children: [
                  Expanded(
                    child: QuickButton(
                      label: 'Add Income',
                      icon: Icons.arrow_downward,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: QuickButton(
                      label: 'Add Expense',
                      icon: Icons.arrow_upward,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          SectionCard(
            title: 'Recent Transactions',
            children: [
              if (transactions.isEmpty)
                EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No transactions yet',
                  subtitle: 'Start by adding your first transaction',
                  action: AppButton(
                    text: 'Add Transaction',
                    onPressed: () {},
                  ),
                )
              else
                ...transactions.map((tx) => AppListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.receipt),
                  ),
                  title: Text(tx.title),
                  subtitle: Text(tx.amount.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => _showOptions(context, tx),
                  ),
                  onTap: () => _editTransaction(tx),
                )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTransaction(),
        icon: Icon(Icons.add),
        label: Text('Add Transaction'),
      ),
    );
  }

  void _showOptions(BuildContext context, Transaction tx) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Transaction Options',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editTransaction(tx);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteTransaction(tx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTransaction() {
    // Navigate to add transaction screen
  }

  void _editTransaction(Transaction tx) {
    // Navigate to edit transaction screen
  }

  void _deleteTransaction(Transaction tx) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete Transaction',
        message: 'Are you sure you want to delete this transaction?',
        onConfirm: () {
          // Delete logic
          Navigator.pop(context);
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackbar(
              message: 'Transaction deleted',
              type: AppSnackbarType.success,
            ),
          );
        },
      ),
    );
  }
}
```

## 🎨 Styling

### Using AppColors

```dart
// Theme-aware colors
Container(
  color: AppColors.primary(context),
  child: Text(
    'Hello',
    style: TextStyle(
      color: AppColors.onPrimary(context),
    ),
  ),
)
```

### Responsive Design

```dart
// Responsive sizing
Container(
  width: layout.responsiveSize(
    phone: 200,
    tablet: 300,
    desktop: 400,
  ),
  height: layout.responsiveSize(
    phone: 100,
    tablet: 150,
    desktop: 200,
  ),
  child: content,
)
```

## ⚡ Performance Tips

### 1. Use RepaintBoundary

```dart
RepaintBoundary(
  child: ExpensiveWidget(),
)
```

### 2. Use OptimizedWidget

```dart
OptimizedWidget(
  cacheKey: 'expensive_computation',
  child: ExpensiveComputationWidget(),
)
```

### 3. Use MemoizedWidget

```dart
MemoizedWidget(
  dependencies: [data, filter],
  builder: () => ExpensiveFilteredList(data, filter),
)
```

### 4. Use Cache Keys

```dart
OptimizedListView(
  cacheKey: 'transaction_list',
  children: transactionTiles,
)
```

## 🔧 Customization

### Custom Button Style

```dart
AppButton(
  text: 'Custom Button',
  style: AppButtonStyle.outline,
  size: AppButtonSize.large,
  enableHaptic: true,
  animationDuration: Duration(milliseconds: 300),
)
```

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

## 🐛 Common Issues

### 1. Performance Issues

**Problem**: Slow scrolling or animations
**Solution**: Use `RepaintBoundary` and `OptimizedWidget`

```dart
RepaintBoundary(
  child: OptimizedWidget(
    cacheKey: 'heavy_widget',
    child: HeavyWidget(),
  ),
)
```

### 2. Responsive Issues

**Problem**: Components don't adapt to screen size
**Solution**: Use responsive utilities

```dart
// Instead of fixed sizes
width: 200,

// Use responsive sizes
width: layout.responsiveSize(
  phone: 200,
  tablet: 300,
  desktop: 400,
),
```

### 3. Theme Issues

**Problem**: Colors don't match theme
**Solution**: Use `AppColors` instead of hardcoded colors

```dart
// Instead of hardcoded colors
color: Colors.blue,

// Use theme-aware colors
color: AppColors.primary(context),
```

## 📚 Next Steps

1. **Read the full documentation**: [README_ui_components.md](README_ui_components.md)
2. **Check the API reference**: [API_REFERENCE.md](API_REFERENCE.md)
3. **Explore examples**: Look at existing screens in the app
4. **Customize components**: Modify styles and behaviors as needed

## 🤝 Getting Help

- Check the component documentation
- Look at existing usage in the codebase
- Test on different screen sizes
- Use the performance tools to optimize

---

**Happy coding! 🚀**
