# Dashboard Implementation Guide

## Overview
Cultural intelligence dashboard with Bengali-first design and real-time insights.

## Core Components

### DashboardScreen
```dart
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CulturalGreetings.getGreeting(context),
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BalanceDisplay(),
            RecentTransactionsList(),
            QuickAddSection(),
            StreakDisplay(),
            CulturalInsights(),
            OfflineIndicator(),
          ],
        ),
      ),
    );
  }
}
```

### BalanceDisplay with Bengali Numerals
```dart
class BalanceDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.trustBlue, AppColors.mintTeal],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'মোট ব্যালেন্স',
            style: AppTypography.heading(context),
          ),
          Text(
            BengaliNumeralConverter.toBengali(balance.toString()),
            style: AppTypography.balance(context),
          ),
        ],
      ),
    );
  }
}
```

### RecentTransactionsList with Cultural Formatting
```dart
class RecentTransactionsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(recentTransactionsProvider);
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionTile(
          transaction: transaction,
          showCulturalFormatting: true,
        );
      },
    );
  }
}
```

### QuickAddSection with Speed-Optimized Buttons
```dart
class QuickAddSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'দ্রুত যোগ করুন',
          style: AppTypography.sectionHeading(context),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            QuickAddButton(
              amount: 50,
              category: 'চা-নাশতা',
              paymentMethod: 'bKash',
              onTap: () => _addQuickExpense(50, 'tea_snacks', 'bkash'),
            ),
            SizedBox(width: 12),
            QuickAddButton(
              amount: 100,
              category: 'রিকশা',
              paymentMethod: 'নগদ',
              onTap: () => _addQuickExpense(100, 'transport', 'cash'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### StreakDisplay with Celebration
```dart
class StreakDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(expenseStreakProvider);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmSand,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: AppColors.warning),
          SizedBox(width: 8),
          Text(
            '${streak} দিন ধারাবাহিক',
            style: AppTypography.body(context),
          ),
          if (streak >= 7) ...[
            SizedBox(width: 8),
            Icon(Icons.celebration, color: AppColors.success),
          ],
        ],
      ),
    );
  }
}
```

### CulturalInsights Widget
```dart
class CulturalInsights extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(culturalInsightsProvider);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আপনার আর্থিক স্বাস্থ্য',
            style: AppTypography.sectionHeading(context),
          ),
          SizedBox(height: 12),
          ...insights.map((insight) => InsightCard(insight: insight)),
        ],
      ),
    );
  }
}
```

### OfflineIndicator
```dart
class OfflineIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    
    if (isOnline) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: AppColors.warning),
          SizedBox(width: 8),
          Text(
            'অফলাইনে কাজ করছেন',
            style: AppTypography.caption(context),
          ),
        ],
      ),
    );
  }
}
```

## Cultural Intelligence Features

### Cultural Greetings
```dart
class CulturalGreetings {
  static String getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final culturalContext = context.read(culturalContextProvider);
    
    switch (culturalContext.locale.languageCode) {
      case 'bn':
        if (hour < 12) return 'সুপ্রভাত';
        if (hour < 18) return 'শুভ বিকাল';
        return 'শুভ সন্ধ্যা';
      default:
        if (hour < 12) return 'Good Morning';
        if (hour < 18) return 'Good Afternoon';
        return 'Good Evening';
    }
  }
}
```

### Bengali Numeral Display
```dart
class BengaliNumeralConverter {
  static String toBengali(double amount) {
    final formatted = NumberFormat.currency(
      locale: 'bn_BD',
      symbol: '৳',
      decimalDigits: 0,
    ).format(amount);
    
    return formatted
        .replaceAll('0', '০')
        .replaceAll('1', '১')
        .replaceAll('2', '২')
        .replaceAll('3', '৩')
        .replaceAll('4', '৪')
        .replaceAll('5', '৫')
        .replaceAll('6', '৬')
        .replaceAll('7', '৭')
        .replaceAll('8', '৮')
        .replaceAll('9', '৯');
  }
}
```

## Performance Optimization

### State Management
```dart
// Use Riverpod select for narrow rebuilds
final balanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.fold(0.0, (sum, t) => sum + t.amount);
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.take(5).toList();
});
```

### Caching
```dart
class DashboardCache {
  static final Map<String, dynamic> _cache = {};
  
  static T get<T>(String key, T Function() builder) {
    if (_cache.containsKey(key)) {
      return _cache[key] as T;
    }
    
    final value = builder();
    _cache[key] = value;
    return value;
  }
}
```

## Success Metrics
- 90% dashboard load time <3 seconds
- 80% cultural insight accuracy
- 70% quick add usage rate
- 85% user engagement
- 95% offline functionality
