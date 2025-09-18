# 🚀 UI Components Examples

Comprehensive examples showing how to use Pocketa UI Components in real-world scenarios.

## 📋 Table of Contents

- [Complete Screens](#complete-screens)
- [Component Combinations](#component-combinations)
- [Advanced Patterns](#advanced-patterns)
- [Performance Examples](#performance-examples)
- [Responsive Examples](#responsive-examples)

---

## Complete Screens

### Transaction Management Screen

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
            onPressed: () => _showFilters(context),
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
                      isPositive: true,
                      onPressed: () => _addIncome(context),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: QuickButton(
                      label: 'Add Expense',
                      icon: Icons.arrow_upward,
                      isPositive: false,
                      onPressed: () => _addExpense(context),
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
                    onPressed: () => _addTransaction(context),
                  ),
                )
              else
                ...transactions.map((tx) => AppListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.receipt),
                  ),
                  title: Text(tx.title),
                  subtitle: Text('৳ ${tx.amount}'),
                  trailing: MoreMenu(
                    onDelete: () => _deleteTransaction(tx),
                    extraItems: [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _editTransaction(tx),
                )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTransaction(context),
        icon: Icon(Icons.add),
        label: Text('Add Transaction'),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Filter Transactions',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropdownField<String>(
              label: 'Category',
              initialValue: 'All',
              items: [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Transport', child: Text('Transport')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            AppDateTimeField(
              label: 'From Date',
              valueUtc: DateTime.now().subtract(Duration(days: 30)),
              onChanged: (date) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _addTransaction(BuildContext context) {
    Navigator.pushNamed(context, '/add_transaction');
  }

  void _addIncome(BuildContext context) {
    Navigator.pushNamed(context, '/add_transaction', arguments: {'type': 'income'});
  }

  void _addExpense(BuildContext context) {
    Navigator.pushNamed(context, '/add_transaction', arguments: {'type': 'expense'});
  }

  void _editTransaction(Transaction tx) {
    Navigator.pushNamed(context, '/edit_transaction', arguments: tx);
  }

  void _deleteTransaction(Transaction tx) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete Transaction',
        message: 'Are you sure you want to delete this transaction?',
        onConfirm: () {
          // Delete logic
          Navigator.pop(context);
          SnackbarService.showTransactionDeleted(context);
        },
      ),
    );
  }
}
```

### Settings Screen with Sliver App Bar

```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Settings',
            subtitle: 'Customize your experience',
            expandedHeight: 200.0,
            pinned: true,
            floating: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary(context),
                    AppColors.primary(context).withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SectionCard(
                title: 'Appearance',
                children: [
                  AppListTile(
                    leading: Icon(Icons.palette),
                    title: Text('Theme'),
                    subtitle: Text('Dark mode'),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  AppListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    subtitle: Text('English'),
                    trailing: LanguageToggleButton(),
                  ),
                ],
              ),
              SectionCard(
                title: 'Notifications',
                children: [
                  AppListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Push Notifications'),
                    subtitle: Text('Receive app notifications'),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  AppListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email Updates'),
                    subtitle: Text('Weekly summary emails'),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                ],
              ),
              SectionCard(
                title: 'Data & Privacy',
                children: [
                  AppListTile(
                    leading: Icon(Icons.backup),
                    title: Text('Backup Data'),
                    subtitle: Text('Last backup: 2 hours ago'),
                    onTap: () => _backupData(context),
                  ),
                  AppListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete Account'),
                    subtitle: Text('Permanently delete your account'),
                    onTap: () => _deleteAccount(context),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _backupData(BuildContext context) {
    LoadingService.showWithSuccess(
      context,
      operation: () async {
        // Backup logic
        await Future.delayed(Duration(seconds: 2));
      },
      loadingMessage: 'Backing up data...',
      successMessage: 'Data backed up successfully!',
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete Account',
        message: 'This action cannot be undone. All your data will be permanently deleted.',
        confirmText: 'Delete Account',
        onConfirm: () {
          Navigator.pop(context);
          SnackbarService.showError(
            context,
            message: 'Account deletion initiated',
          );
        },
      ),
    );
  }
}
```

---

## Component Combinations

### Form with Validation

```dart
class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Transaction',
        subtitle: 'Enter transaction details',
        showBack: true,
        trailingPillText: '৳ ${_amountController.text.isEmpty ? '0' : _amountController.text}',
        trailingPillIcon: Icons.account_balance_wallet,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SectionCard(
              title: 'Amount',
              children: [
                AmountField(
                  controller: _amountController,
                  label: 'Amount',
                  currencySymbol: '৳',
                  onChanged: (value) => setState(() {}),
                ),
              ],
            ),
            SectionCard(
              title: 'Category',
              children: [
                AppDropdownField<String>(
                  label: 'Category',
                  initialValue: _selectedCategory,
                  items: [
                    DropdownMenuItem(value: 'Food', child: Text('Food')),
                    DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                    DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                    DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                  ],
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
              ],
            ),
            SectionCard(
              title: 'Date & Time',
              children: [
                AppDateTimeField(
                  label: 'Date & Time',
                  valueUtc: _selectedDate,
                  onChanged: (date) => setState(() => _selectedDate = date),
                ),
              ],
            ),
            SectionCard(
              title: 'Additional Details',
              children: [
                NoteField(controller: _noteController),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: AppButton(
            text: 'Save Transaction',
            icon: Icons.save,
            isFullWidth: true,
            onPressed: _saveTransaction,
          ),
        ),
      ),
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      LoadingService.showWithSuccess(
        context,
        operation: () async {
          // Save transaction logic
          await Future.delayed(Duration(seconds: 1));
        },
        loadingMessage: 'Saving transaction...',
        successMessage: 'Transaction saved successfully!',
      );
    }
  }
}
```

### Dashboard with Summary Cards

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        subtitle: 'Your financial overview',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshData(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SummaryHeader(
              title: 'This Month',
              subtitle: 'December 2024',
              trailing: Text('View Details'),
            ),
          ),
          SliverToBoxAdapter(
            child: SummaryRow(
              income: 50000,
              expense: 35000,
              net: 15000,
              currencySymbol: '৳',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ResponsiveGrid(
                children: [
                  InteractiveCard(
                    title: 'Quick Add',
                    subtitle: 'Add transaction quickly',
                    onTap: () => _addTransaction(context),
                    child: Column(
                      children: [
                        Icon(Icons.add_circle, size: 48),
                        SizedBox(height: 8),
                        Text('Add Transaction'),
                      ],
                    ),
                  ),
                  InteractiveCard(
                    title: 'Reports',
                    subtitle: 'View your reports',
                    onTap: () => _viewReports(context),
                    child: Column(
                      children: [
                        Icon(Icons.analytics, size: 48),
                        SizedBox(height: 8),
                        Text('Reports'),
                      ],
                    ),
                  ),
                  InteractiveCard(
                    title: 'Goals',
                    subtitle: 'Track your goals',
                    onTap: () => _viewGoals(context),
                    child: Column(
                      children: [
                        Icon(Icons.flag, size: 48),
                        SizedBox(height: 8),
                        Text('Goals'),
                      ],
                    ),
                  ),
                  InteractiveCard(
                    title: 'Settings',
                    subtitle: 'App settings',
                    onTap: () => _openSettings(context),
                    child: Column(
                      children: [
                        Icon(Icons.settings, size: 48),
                        SizedBox(height: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Recent Transactions',
              trailing: TextButton(
                onPressed: () => _viewAllTransactions(context),
                child: Text('View All'),
              ),
              children: [
                if (recentTransactions.isEmpty)
                  EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No recent transactions',
                    subtitle: 'Your recent transactions will appear here',
                  )
                else
                  ...recentTransactions.take(5).map((tx) => AppListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(tx.category),
                      child: Icon(_getCategoryIcon(tx.category)),
                    ),
                    title: Text(tx.title),
                    subtitle: Text(tx.category),
                    trailing: Text(
                      '৳ ${tx.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tx.type == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                    onTap: () => _viewTransaction(tx),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData(BuildContext context) {
    LoadingService.show(context, message: 'Refreshing data...');
    // Refresh logic
    Future.delayed(Duration(seconds: 2), () {
      LoadingService.hide(context);
      SnackbarService.showSuccess(context, message: 'Data refreshed');
    });
  }

  void _addTransaction(BuildContext context) {
    Navigator.pushNamed(context, '/add_transaction');
  }

  void _viewReports(BuildContext context) {
    Navigator.pushNamed(context, '/reports');
  }

  void _viewGoals(BuildContext context) {
    Navigator.pushNamed(context, '/goals');
  }

  void _openSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  void _viewAllTransactions(BuildContext context) {
    Navigator.pushNamed(context, '/transactions');
  }

  void _viewTransaction(Transaction tx) {
    Navigator.pushNamed(context, '/transaction_details', arguments: tx);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.blue;
      case 'Entertainment': return Colors.purple;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Entertainment': return Icons.movie;
      default: return Icons.category;
    }
  }
}
```

---

## Advanced Patterns

### Performance-Optimized List

```dart
class OptimizedTransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final ScrollController? controller;

  const OptimizedTransactionList({
    Key? key,
    required this.transactions,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptimizedListView(
      controller: controller,
      cacheKey: 'transaction_list',
      children: transactions.map((tx) => OptimizedWidget(
        cacheKey: 'transaction_${tx.id}',
        child: TransactionTile(transaction: tx),
      )).toList(),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: MemoizedWidget(
        dependencies: [transaction.category],
        builder: () => CircleAvatar(
          backgroundColor: _getCategoryColor(transaction.category),
          child: Icon(_getCategoryIcon(transaction.category)),
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(transaction.category),
      trailing: Text('৳ ${transaction.amount}'),
      onTap: () => _viewTransaction(transaction),
    );
  }

  void _viewTransaction(Transaction tx) {
    // Navigation logic
  }

  Color _getCategoryColor(String category) {
    // Color logic
    return Colors.blue;
  }

  IconData _getCategoryIcon(String category) {
    // Icon logic
    return Icons.category;
  }
}
```

### Responsive Layout

```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        subtitle: 'Responsive layout example',
      ),
      body: device == DeviceSize.desktop
          ? _buildDesktopLayout(context, layout)
          : _buildMobileLayout(context, layout),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppSize layout) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SummaryHeader(
                title: 'Financial Overview',
                subtitle: 'This month',
              ),
              SummaryRow(
                income: 50000,
                expense: 35000,
                net: 15000,
              ),
            ],
          ),
        ),
        SizedBox(width: layout.spaceL),
        Expanded(
          flex: 3,
          child: ResponsiveGrid(
            crossAxisCount: 2,
            children: _buildDashboardCards(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppSize layout) {
    return ListView(
      children: [
        SummaryHeader(
          title: 'Financial Overview',
          subtitle: 'This month',
        ),
        SummaryRow(
          income: 50000,
          expense: 35000,
          net: 15000,
        ),
        SizedBox(height: layout.spaceL),
        ResponsiveGrid(
          children: _buildDashboardCards(context),
        ),
      ],
    );
  }

  List<Widget> _buildDashboardCards(BuildContext context) {
    return [
      InteractiveCard(
        title: 'Quick Add',
        onTap: () {},
        child: Column(
          children: [
            Icon(Icons.add, size: 48),
            Text('Add Transaction'),
          ],
        ),
      ),
      InteractiveCard(
        title: 'Reports',
        onTap: () {},
        child: Column(
          children: [
            Icon(Icons.analytics, size: 48),
            Text('Reports'),
          ],
        ),
      ),
      InteractiveCard(
        title: 'Goals',
        onTap: () {},
        child: Column(
          children: [
            Icon(Icons.flag, size: 48),
            Text('Goals'),
          ],
        ),
      ),
      InteractiveCard(
        title: 'Settings',
        onTap: () {},
        child: Column(
          children: [
            Icon(Icons.settings, size: 48),
            Text('Settings'),
          ],
        ),
      ),
    ];
  }
}
```

---

## Performance Examples

### Memoized Expensive Widget

```dart
class ExpensiveChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String filter;

  const ExpensiveChart({
    Key? key,
    required this.transactions,
    required this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MemoizedWidget(
      dependencies: [transactions, filter],
      builder: () => _buildChart(transactions, filter),
    );
  }

  Widget _buildChart(List<Transaction> transactions, String filter) {
    // Expensive chart building logic
    return Container(
      height: 200,
      child: CustomPaint(
        painter: ChartPainter(
          data: _processData(transactions, filter),
        ),
      ),
    );
  }

  List<ChartData> _processData(List<Transaction> transactions, String filter) {
    // Expensive data processing
    return transactions
        .where((tx) => tx.category == filter)
        .map((tx) => ChartData(tx.amount, tx.date))
        .toList();
  }
}
```

### Optimized Grid with Caching

```dart
class OptimizedProductGrid extends StatelessWidget {
  final List<Product> products;
  final String searchQuery;

  const OptimizedProductGrid({
    Key? key,
    required this.products,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredProducts = useMemoized(() {
      return products.where((product) =>
          product.name.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }, [products, searchQuery]);

    return ResponsiveGrid(
      cacheKey: 'product_grid_$searchQuery',
      children: filteredProducts.map((product) => 
        OptimizedWidget(
          cacheKey: 'product_${product.id}',
          child: ProductCard(product: product),
        )
      ).toList(),
    );
  }
}
```

---

## Responsive Examples

### Responsive Form Layout

```dart
class ResponsiveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Responsive Form',
        subtitle: 'Adapts to screen size',
      ),
      body: device == DeviceSize.desktop
          ? _buildDesktopForm(context, layout)
          : _buildMobileForm(context, layout),
    );
  }

  Widget _buildDesktopForm(BuildContext context, AppSize layout) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 800),
        child: Row(
          children: [
            Expanded(
              child: SectionCard(
                title: 'Basic Information',
                children: [
                  AppTextFormField(
                    label: 'Name',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: layout.spaceM),
                  AppTextFormField(
                    label: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            SizedBox(width: layout.spaceL),
            Expanded(
              child: SectionCard(
                title: 'Additional Details',
                children: [
                  AppTextFormField(
                    label: 'Phone',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: layout.spaceM),
                  AppDateTimeField(
                    label: 'Birth Date',
                    valueUtc: DateTime.now(),
                    onChanged: (date) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileForm(BuildContext context, AppSize layout) {
    return ListView(
      children: [
        SectionCard(
          title: 'Basic Information',
          children: [
            AppTextFormField(
              label: 'Name',
              prefixIcon: Icons.person,
            ),
            SizedBox(height: layout.spaceM),
            AppTextFormField(
              label: 'Email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        SectionCard(
          title: 'Additional Details',
          children: [
            AppTextFormField(
              label: 'Phone',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: layout.spaceM),
            AppDateTimeField(
              label: 'Birth Date',
              valueUtc: DateTime.now(),
              onChanged: (date) {},
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Best Practices

### 1. Use Appropriate Components

```dart
// ✅ Good: Use specific components for specific needs
AppButton(
  text: 'Save',
  style: AppButtonStyle.primary,
  onPressed: () {},
)

// ❌ Avoid: Using generic components when specific ones exist
ElevatedButton(
  onPressed: () {},
  child: Text('Save'),
)
```

### 2. Leverage Performance Features

```dart
// ✅ Good: Use performance optimizations
OptimizedWidget(
  cacheKey: 'expensive_widget',
  child: ExpensiveWidget(),
)

// ❌ Avoid: Not using performance features for heavy widgets
ExpensiveWidget()
```

### 3. Use Responsive Design

```dart
// ✅ Good: Use responsive sizing
Container(
  width: layout.responsiveSize(
    phone: 200,
    tablet: 300,
    desktop: 400,
  ),
)

// ❌ Avoid: Fixed sizes
Container(
  width: 200,
)
```

### 4. Proper State Management

```dart
// ✅ Good: Use appropriate state management
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Click me',
      onPressed: () => setState(() {
        // Update state
      }),
    );
  }
}
```

---

**Built with ❤️ for the Pocketa app**
