# Budgeting Implementation Guide

## Overview
Empathetic budgeting system with festival awareness and cultural insights.

## Core Components

### BudgetEntity/Model
```dart
class BudgetEntity {
  final String id;
  final String name;
  final double amount;
  final double spent;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFestival;
  final CulturalContext context;
  
  double get remaining => amount - spent;
  double get percentage => (spent / amount) * 100;
  bool get isOverBudget => spent > amount;
}
```

### BudgetCreationScreen
```dart
class BudgetCreationScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<BudgetCreationScreen> createState() => _BudgetCreationScreenState();
}

class _BudgetCreationScreenState extends ConsumerState<BudgetCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  bool _isFestival = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'নতুন বাজেট তৈরি করুন',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'বাজেটের নাম',
                  hintText: 'যেমন: ঈদের জন্য বাজেট',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'বাজেটের নাম প্রয়োজন';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'বাজেটের পরিমাণ',
                  hintText: '০',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'বাজেটের পরিমাণ প্রয়োজন';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'সঠিক পরিমাণ লিখুন';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'ক্যাটাগরি',
                ),
                items: CulturalCategories.getBengaliCategories().map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'শুরু তারিখ',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectStartDate(),
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy', 'bn').format(_startDate),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'শেষ তারিখ',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectEndDate(),
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy', 'bn').format(_endDate),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('উৎসবের বাজেট'),
                subtitle: Text('ঈদ, পূজা, বা অন্যান্য উৎসবের জন্য'),
                value: _isFestival,
                onChanged: (value) {
                  setState(() {
                    _isFestival = value;
                  });
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createBudget,
                  child: Text('বাজেট তৈরি করুন'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### BudgetProgressDisplay
```dart
class BudgetProgressDisplay extends ConsumerWidget {
  final BudgetEntity budget;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: budget.isOverBudget ? AppColors.danger : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                budget.name,
                style: AppTypography.heading(context),
              ),
              if (budget.isFestival)
                Icon(Icons.celebration, color: AppColors.warning),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${budget.category} • ${DateFormat('dd/MM/yyyy', 'bn').format(budget.startDate)} - ${DateFormat('dd/MM/yyyy', 'bn').format(budget.endDate)}',
            style: AppTypography.caption(context),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'খরচ: ${BengaliNumeralConverter.toBengali(budget.spent.toString())} ৳',
                style: AppTypography.body(context),
              ),
              Text(
                'বাজেট: ${BengaliNumeralConverter.toBengali(budget.amount.toString())} ৳',
                style: AppTypography.body(context),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: budget.percentage / 100,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              budget.isOverBudget ? AppColors.danger : AppColors.success,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${BengaliNumeralConverter.toBengali(budget.percentage.toStringAsFixed(1))}% ব্যবহার হয়েছে',
            style: AppTypography.caption(context),
          ),
          if (budget.isOverBudget) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'বাজেট ছাড়িয়ে গেছে। কোনো সমস্যা নেই—কখনো কখনো হয়।',
                style: AppTypography.caption(context).copyWith(
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

### Festival Budget Templates
```dart
class FestivalBudgetTemplates {
  static List<BudgetTemplate> getTemplates() => [
    BudgetTemplate(
      name: 'ঈদ-উল-ফিতর',
      description: 'ঈদের জন্য সম্পূর্ণ বাজেট',
      categories: [
        'নতুন পোশাক',
        'খাবার',
        'উপহার',
        'যাতায়াত',
      ],
      totalAmount: 50000,
      duration: 30,
    ),
    BudgetTemplate(
      name: 'দুর্গাপূজা',
      description: 'পূজার জন্য সম্পূর্ণ বাজেট',
      categories: [
        'পূজার সামগ্রী',
        'খাবার',
        'উপহার',
        'যাতায়াত',
      ],
      totalAmount: 30000,
      duration: 15,
    ),
    BudgetTemplate(
      name: 'বিয়ে',
      description: 'বিয়ের জন্য সম্পূর্ণ বাজেট',
      categories: [
        'পোশাক',
        'খাবার',
        'উপহার',
        'যাতায়াত',
        'অন্যান্য',
      ],
      totalAmount: 100000,
      duration: 60,
    ),
  ];
}
```

### Empathetic Budget Alerts
```dart
class EmpatheticBudgetAlerts {
  static String getAlertMessage(BudgetEntity budget) {
    final percentage = budget.percentage;
    
    if (percentage >= 100) {
      return '${budget.category} এ বাজেট শেষ হয়ে গেছে। কোনো সমস্যা নেই—কখনো কখনো হয়।';
    } else if (percentage >= 90) {
      return '${budget.category} এ ৯০% ব্যবহার হয়েছে। সাবধান!';
    } else if (percentage >= 75) {
      return '${budget.category} এ ৭৫% ব্যবহার হয়েছে। প্ল্যান টিউন করবেন?';
    } else if (percentage >= 50) {
      return '${budget.category} এ অর্ধেক ব্যবহার হয়েছে। ভালো চলছে!';
    } else {
      return '${budget.category} এ ভালো চলছে। এভাবেই চালিয়ে যান!';
    }
  }
  
  static Color getAlertColor(BudgetEntity budget) {
    final percentage = budget.percentage;
    
    if (percentage >= 100) return AppColors.danger;
    if (percentage >= 90) return AppColors.warning;
    if (percentage >= 75) return AppColors.warning;
    if (percentage >= 50) return AppColors.success;
    return AppColors.success;
  }
}
```

### Budget Insights and Recommendations
```dart
class BudgetInsights extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
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
            'বাজেট বিশ্লেষণ',
            style: AppTypography.sectionHeading(context),
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            'মোট বাজেট',
            BengaliNumeralConverter.toBengali(
              budgets.fold(0.0, (sum, b) => sum + b.amount).toString()
            ),
            Icons.account_balance_wallet,
          ),
          SizedBox(height: 12),
          _buildInsightCard(
            'মোট খরচ',
            BengaliNumeralConverter.toBengali(
              budgets.fold(0.0, (sum, b) => sum + b.spent).toString()
            ),
            Icons.shopping_cart,
          ),
          SizedBox(height: 12),
          _buildInsightCard(
            'সবচেয়ে বেশি খরচ',
            _getHighestSpendingCategory(budgets),
            Icons.trending_up,
          ),
          SizedBox(height: 12),
          _buildInsightCard(
            'সবচেয়ে কম খরচ',
            _getLowestSpendingCategory(budgets),
            Icons.trending_down,
          ),
        ],
      ),
    );
  }
}
```

## Cultural Intelligence Features

### Festival Awareness
```dart
class FestivalAwareness {
  static bool isFestivalPeriod() {
    final now = DateTime.now();
    final eidDate = DateTime(now.year, 4, 15); // Approximate Eid date
    final pujaDate = DateTime(now.year, 10, 15); // Approximate Puja date
    
    return now.isAfter(eidDate.subtract(Duration(days: 30))) && 
           now.isBefore(eidDate.add(Duration(days: 7))) ||
           now.isAfter(pujaDate.subtract(Duration(days: 30))) && 
           now.isBefore(pujaDate.add(Duration(days: 7)));
  }
  
  static String getFestivalMessage() {
    if (isFestivalPeriod()) {
      return 'উৎসবের সময়! বাজেট মেনে চলুন।';
    }
    return 'সাধারণ সময়। বাজেট মেনে চলুন।';
  }
}
```

### Cultural Budget Categories
```dart
class CulturalBudgetCategories {
  static List<String> getFestivalCategories() => [
    'নতুন পোশাক',
    'খাবার',
    'উপহার',
    'যাতায়াত',
    'পূজার সামগ্রী',
    'অন্যান্য',
  ];
  
  static List<String> getRegularCategories() => [
    'চা-নাশতা',
    'রিকশা ও যাতায়াত',
    'মোবাইল রিচার্জ',
    'পারিবারিক সহায়তা',
    'স্বাস্থ্য',
    'শিক্ষা',
    'বিনোদন',
    'অন্যান্য',
  ];
}
```

## Performance Optimization

### State Management
```dart
final budgetsProvider = StateNotifierProvider<BudgetsNotifier, List<BudgetEntity>>((ref) {
  return BudgetsNotifier();
});

class BudgetsNotifier extends StateNotifier<List<BudgetEntity>> {
  BudgetsNotifier() : super([]);
  
  Future<void> addBudget(BudgetEntity budget) async {
    // Add budget logic
    state = [...state, budget];
  }
  
  Future<void> updateBudget(BudgetEntity budget) async {
    // Update budget logic
    state = state.map((b) => b.id == budget.id ? budget : b).toList();
  }
}
```

## Success Metrics
- 60% budget creation rate
- 70% budget adherence
- 80% festival budget usage
- 85% empathetic alert effectiveness
- 75% budget insights usage
