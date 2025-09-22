# Wallet Implementation Guide

## Overview
Wallet management system with local payment methods and cultural intelligence.

## Core Components

### WalletEntity/Model
```dart
class WalletEntity {
  final String id;
  final String name;
  final double balance;
  final String type; // 'cash', 'bkash', 'nagad', 'rocket', 'bank'
  final String color;
  final String icon;
  final bool isDefault;
  final CulturalContext context;
}
```

### WalletListScreen
```dart
class WalletListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'আপনার ওয়ালেট',
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddWalletSheet(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          return WalletCard(wallet: wallet);
        },
      ),
    );
  }
}
```

### WalletBalanceDisplay with Bengali Numerals
```dart
class WalletBalanceDisplay extends StatelessWidget {
  final WalletEntity wallet;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(wallet.color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(IconData(wallet.icon), color: Colors.white),
              SizedBox(width: 8),
              Text(
                wallet.name,
                style: AppTypography.heading(context).copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            BengaliNumeralConverter.toBengali(wallet.balance.toString()),
            style: AppTypography.balance(context).copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
```

### AddWalletSheet with Local Payment Methods
```dart
class AddWalletSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends ConsumerState<AddWalletSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'cash';
  double _initialBalance = 0.0;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'নতুন ওয়ালেট যোগ করুন',
              style: AppTypography.heading(context),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ওয়ালেটের নাম',
                hintText: 'যেমন: আমার bKash',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ওয়ালেটের নাম প্রয়োজন';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'ওয়ালেটের ধরন',
              ),
              items: LocalPaymentMethods.getBangladeshMethods().map((method) {
                return DropdownMenuItem(
                  value: method.id,
                  child: Row(
                    children: [
                      Icon(method.icon, color: method.color),
                      SizedBox(width: 8),
                      Text(method.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'প্রাথমিক ব্যালেন্স',
                hintText: '০',
              ),
              onChanged: (value) {
                _initialBalance = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('বাতিল'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveWallet,
                    child: Text('সংরক্ষণ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Local Payment Methods Integration
```dart
class LocalPaymentMethods {
  static List<PaymentMethod> getBangladeshMethods() => [
    PaymentMethod(
      id: 'cash',
      name: 'নগদ টাকা',
      icon: Icons.money,
      color: Color(0xFF4CAF50),
    ),
    PaymentMethod(
      id: 'bkash',
      name: 'bKash',
      icon: Icons.phone_android,
      color: Color(0xFFE2136E),
    ),
    PaymentMethod(
      id: 'nagad',
      name: 'নগদ',
      icon: Icons.account_balance_wallet,
      color: Color(0xFFFF6B35),
    ),
    PaymentMethod(
      id: 'rocket',
      name: 'রকেট',
      icon: Icons.rocket_launch,
      color: Color(0xFF8E44AD),
    ),
    PaymentMethod(
      id: 'bank',
      name: 'ব্যাংক',
      icon: Icons.account_balance,
      color: Color(0xFF2196F3),
    ),
  ];
}
```

### Wallet Transfer Functionality
```dart
class WalletTransferDialog extends ConsumerStatefulWidget {
  final List<WalletEntity> wallets;
  
  @override
  ConsumerState<WalletTransferDialog> createState() => _WalletTransferDialogState();
}

class _WalletTransferDialogState extends ConsumerState<WalletTransferDialog> {
  WalletEntity? _fromWallet;
  WalletEntity? _toWallet;
  double _amount = 0.0;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ওয়ালেট থেকে টাকা স্থানান্তর'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<WalletEntity>(
            value: _fromWallet,
            decoration: InputDecoration(labelText: 'থেকে'),
            items: widget.wallets.map((wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(wallet.name),
              );
            }).toList(),
            onChanged: (value) => setState(() => _fromWallet = value),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<WalletEntity>(
            value: _toWallet,
            decoration: InputDecoration(labelText: 'প্রতি'),
            items: widget.wallets.map((wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(wallet.name),
              );
            }).toList(),
            onChanged: (value) => setState(() => _toWallet = value),
          ),
          SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'পরিমাণ'),
            onChanged: (value) => _amount = double.tryParse(value) ?? 0.0,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('বাতিল'),
        ),
        ElevatedButton(
          onPressed: _transfer,
          child: Text('স্থানান্তর'),
        ),
      ],
    );
  }
}
```

### Wallet Insights and Analytics
```dart
class WalletInsights extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);
    final transactions = ref.watch(transactionsProvider);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ওয়ালেট বিশ্লেষণ',
            style: AppTypography.sectionHeading(context),
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            'মোট ব্যালেন্স',
            BengaliNumeralConverter.toBengali(
              wallets.fold(0.0, (sum, w) => sum + w.balance).toString()
            ),
            Icons.account_balance_wallet,
          ),
          SizedBox(height: 12),
          _buildInsightCard(
            'সবচেয়ে ব্যবহৃত',
            _getMostUsedWallet(transactions),
            Icons.trending_up,
          ),
          SizedBox(height: 12),
          _buildInsightCard(
            'এই মাসে খরচ',
            BengaliNumeralConverter.toBengali(
              _getMonthlySpending(transactions).toString()
            ),
            Icons.shopping_cart,
          ),
        ],
      ),
    );
  }
}
```

## Cultural Intelligence Features

### Bengali Wallet Names
```dart
class WalletLocalization {
  static String getLocalizedName(String type) {
    switch (type) {
      case 'cash': return 'নগদ টাকা';
      case 'bkash': return 'bKash';
      case 'nagad': return 'নগদ';
      case 'rocket': return 'রকেট';
      case 'bank': return 'ব্যাংক';
      default: return type;
    }
  }
}
```

### Cultural Wallet Icons
```dart
class CulturalWalletIcons {
  static IconData getIcon(String type) {
    switch (type) {
      case 'cash': return Icons.money;
      case 'bkash': return Icons.phone_android;
      case 'nagad': return Icons.account_balance_wallet;
      case 'rocket': return Icons.rocket_launch;
      case 'bank': return Icons.account_balance;
      default: return Icons.wallet;
    }
  }
}
```

## Performance Optimization

### State Management
```dart
final walletsProvider = StateNotifierProvider<WalletsNotifier, List<WalletEntity>>((ref) {
  return WalletsNotifier();
});

class WalletsNotifier extends StateNotifier<List<WalletEntity>> {
  WalletsNotifier() : super([]);
  
  Future<void> addWallet(WalletEntity wallet) async {
    // Add wallet logic
    state = [...state, wallet];
  }
  
  Future<void> updateWallet(WalletEntity wallet) async {
    // Update wallet logic
    state = state.map((w) => w.id == wallet.id ? wallet : w).toList();
  }
}
```

## Success Metrics
- 80% wallet creation rate
- 70% local payment method adoption
- 90% wallet balance accuracy
- 85% transfer success rate
- 75% wallet insights usage
