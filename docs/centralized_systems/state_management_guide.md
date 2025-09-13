# State Management System Guide
## PocketA - Comprehensive Riverpod State Management

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Provider Types](#provider-types)
4. [State Management Patterns](#state-management-patterns)
5. [Data Flow Architecture](#data-flow-architecture)
6. [Implementation Examples](#implementation-examples)
7. [Performance Optimization](#performance-optimization)
8. [Testing State Management](#testing-state-management)
9. [Migration Guide](#migration-guide)
10. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA State Management System provides a comprehensive solution using Riverpod for managing application state, data flow, and side effects. It follows clean architecture principles with clear separation of concerns and optimized performance patterns.

### Key Features
- **Riverpod Integration**: Modern, type-safe state management with excellent performance
- **Clean Architecture**: Clear separation between presentation, domain, and data layers
- **Reactive Programming**: Stream-based data flow with automatic UI updates
- **Performance Optimized**: Selective updates and efficient state management
- **Testing Support**: Comprehensive testing utilities and patterns
- **Offline-First**: Hive integration for local data persistence
- **Error Handling**: Centralized error management with user-friendly messages

---

## 🏗️ System Architecture

### Core Components

```dart
// lib/core/providers/app_providers.dart
final appProviders = [
  // Core providers
  themeProvider,
  localeProvider,
  celebrationPreferencesProvider,
  
  // Feature providers
  ...onboardingProviders,
  ...transactionProviders,
  ...walletProviders,
  ...categoryProviders,
  ...budgetProviders,
];
```

### Provider Hierarchy

```dart
// Provider dependency hierarchy
final dataSourceProvider = Provider<DataSource>((ref) => DataSourceImpl());
final repositoryProvider = Provider<Repository>((ref) => 
  RepositoryImpl(ref.watch(dataSourceProvider))
);
final useCaseProvider = Provider<UseCase>((ref) => 
  UseCaseImpl(ref.watch(repositoryProvider))
);
final stateNotifierProvider = StateNotifierProvider<StateNotifier, State>((ref) => 
  StateNotifierImpl(ref.watch(useCaseProvider))
);
```

---

## 🔧 Provider Types

### Basic Providers

```dart
// Simple value provider
final appVersionProvider = Provider<String>((ref) => '1.0.0');

// Computed provider
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});

// Family provider for parameterized values
final userByIdProvider = Provider.family<User?, String>((ref, id) {
  final users = ref.watch(usersProvider);
  return users.firstWhere((user) => user.id == id, orElse: () => null);
});
```

### State Notifier Providers

```dart
// State notifier for complex state management
final onboardingStateProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingNotifier(repository);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;
  
  OnboardingNotifier(this._repository) : super(const OnboardingState()) {
    _loadOnboardingData();
  }
  
  Future<void> _loadOnboardingData() async {
    try {
      state = state.copyWith(isLoading: true);
      final data = await _repository.getOnboardingData();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  void updateLanguage(String language) {
    state = state.copyWith(
      data: state.data.copyWith(language: language),
    );
  }
}
```

### Stream Providers

```dart
// Stream provider for reactive data
final walletsStreamProvider = StreamProvider.autoDispose<List<WalletEntity>>((ref) async* {
  final box = ref.watch(walletBoxProvider);
  
  List<WalletEntity> snapshot() => box.values
    .map((m) => m.toEntity())
    .toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  
  yield snapshot();
  await for (final _ in box.watch()) {
    yield snapshot();
  }
});

// Computed stream provider
final totalBalanceProvider = Provider<double>((ref) {
  final wallets = ref.watch(walletsStreamProvider).value ?? [];
  return wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);
});
```

### Future Providers

```dart
// Future provider for async operations
final userProfileProvider = FutureProvider.autoDispose<UserProfile>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserProfile(userId);
});

// Family future provider
final transactionByIdProvider = FutureProvider.family<TransactionEntity?, String>((ref, id) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getTransactionById(id);
});
```

---

## 🎨 State Management Patterns

### Repository Pattern

```dart
// Repository interface
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getAllTransactions();
  Future<TransactionEntity?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Stream<List<TransactionEntity>> watchTransactions();
}

// Repository implementation
class TransactionRepositoryImpl implements TransactionRepository {
  final Box<TransactionModel> _box;
  
  TransactionRepositoryImpl(this._box);
  
  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    return _box.values.map((model) => model.toEntity()).toList();
  }
  
  @override
  Stream<List<TransactionEntity>> watchTransactions() async* {
    yield getAllTransactions();
    await for (final _ in _box.watch()) {
      yield getAllTransactions();
    }
  }
}

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepositoryImpl(box);
});
```

### Use Case Pattern

```dart
// Use case interface
abstract class GetTransactionsUseCase {
  Future<List<TransactionEntity>> call();
}

// Use case implementation
class GetTransactionsUseCaseImpl implements GetTransactionsUseCase {
  final TransactionRepository _repository;
  
  GetTransactionsUseCaseImpl(this._repository);
  
  @override
  Future<List<TransactionEntity>> call() async {
    return await _repository.getAllTransactions();
  }
}

// Use case provider
final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCaseImpl(repository);
});
```

### State Notifier Pattern

```dart
// State class
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default([]) List<TransactionEntity> transactions,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? error,
  }) = _TransactionState;
}

// State notifier
class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository _repository;
  
  TransactionNotifier(this._repository) : super(const TransactionState()) {
    _loadTransactions();
  }
  
  Future<void> _loadTransactions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final transactions = await _repository.getAllTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      state = state.copyWith(isSaving: true, error: null);
      await _repository.saveTransaction(transaction);
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isSaving: false);
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// State notifier provider
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
```

---

## 🔄 Data Flow Architecture

### Clean Architecture Data Flow

```dart
// Presentation Layer
class TransactionListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);
    
    return transactionState.when(
      data: (transactions) => ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(transaction: transactions[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}

// Domain Layer
abstract class TransactionEntity {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  
  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
}

// Data Layer
@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  double amount;
  
  @HiveField(2)
  String category;
  
  @HiveField(3)
  DateTime date;
  
  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
  
  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    category: category,
    date: date,
  );
}
```

### Reactive Data Flow

```dart
// Data source changes trigger UI updates
final transactionBoxProvider = Provider<Box<TransactionModel>>((ref) {
  return Hive.box<TransactionModel>(HiveBoxes.transactions);
});

// Stream provider watches for changes
final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) async* {
  final box = ref.watch(transactionBoxProvider);
  
  List<TransactionEntity> snapshot() => box.values
    .map((model) => model.toEntity())
    .toList();
  
  yield snapshot();
  await for (final _ in box.watch()) {
    yield snapshot();
  }
});

// Computed providers react to changes
final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions
    .where((t) => t.amount < 0)
    .fold(0.0, (sum, t) => sum + t.amount.abs());
});

final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions
    .where((t) => t.amount > 0)
    .fold(0.0, (sum, t) => sum + t.amount);
});
```

---

## 🚀 Implementation Examples

### Complete Feature Implementation

```dart
// lib/features/transactions/presentation/viewmodels/transaction_providers.dart

// Data source
final transactionBoxProvider = Provider<Box<TransactionModel>>((ref) {
  return Hive.box<TransactionModel>(HiveBoxes.transactions);
});

// Repository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepositoryImpl(box);
});

// Use cases
final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCaseImpl(repository);
});

final saveTransactionUseCaseProvider = Provider<SaveTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return SaveTransactionUseCaseImpl(repository);
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return DeleteTransactionUseCaseImpl(repository);
});

// State notifier
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final getTransactions = ref.watch(getTransactionsUseCaseProvider);
  final saveTransaction = ref.watch(saveTransactionUseCaseProvider);
  final deleteTransaction = ref.watch(deleteTransactionUseCaseProvider);
  
  return TransactionNotifier(getTransactions, saveTransaction, deleteTransaction);
});

// Stream provider for reactive updates
final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) async* {
  final repository = ref.watch(transactionRepositoryProvider);
  
  yield* repository.watchTransactions();
});

// Computed providers
final totalBalanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions.fold(0.0, (sum, t) => sum + t.amount);
});

final transactionsByCategoryProvider = Provider<Map<String, List<TransactionEntity>>>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  final grouped = <String, List<TransactionEntity>>{};
  
  for (final transaction in transactions) {
    grouped.putIfAbsent(transaction.category, () => []).add(transaction);
  }
  
  return grouped;
});
```

### State Notifier Implementation

```dart
// lib/features/transactions/presentation/viewmodels/transaction_notifier.dart
class TransactionNotifier extends StateNotifier<TransactionState> {
  final GetTransactionsUseCase _getTransactions;
  final SaveTransactionUseCase _saveTransaction;
  final DeleteTransactionUseCase _deleteTransaction;
  
  TransactionNotifier(
    this._getTransactions,
    this._saveTransaction,
    this._deleteTransaction,
  ) : super(const TransactionState()) {
    _loadTransactions();
  }
  
  Future<void> _loadTransactions() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final transactions = await _getTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      state = state.copyWith(isSaving: true, error: null);
      await _saveTransaction(transaction);
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isSaving: false);
    }
  }
  
  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      state = state.copyWith(isSaving: true, error: null);
      await _saveTransaction(transaction);
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isSaving: false);
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    try {
      await _deleteTransaction(id);
      await _loadTransactions();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}
```

### Widget Integration

```dart
// lib/features/transactions/presentation/widgets/transaction_list_widget.dart
class TransactionListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTransactionDialog(context, ref),
          ),
        ],
      ),
      body: transactionState.when(
        data: (transactions) => transactions.isEmpty
            ? Center(child: Text('No transactions yet'))
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) => TransactionTile(
                  transaction: transactions[index],
                  onEdit: (transaction) => _showEditTransactionDialog(context, ref, transaction),
                  onDelete: (id) => notifier.deleteTransaction(id),
                ),
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => notifier.clearError(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(
        onSave: (transaction) {
          ref.read(transactionNotifierProvider.notifier).addTransaction(transaction);
        },
      ),
    );
  }
}
```

---

## ⚡ Performance Optimization

### Selective Updates

```dart
// Watch only specific parts of state
class TransactionTile extends ConsumerWidget {
  final String transactionId;
  
  const TransactionTile({required this.transactionId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild when this specific transaction changes
    final transaction = ref.watch(
      transactionNotifierProvider.select((state) => 
        state.transactions.firstWhere((t) => t.id == transactionId)
      ),
    );
    
    return ListTile(
      title: Text(transaction.amount.toString()),
      subtitle: Text(transaction.category),
    );
  }
}
```

### Provider Optimization

```dart
// Use autoDispose for temporary providers
final temporaryDataProvider = Provider.autoDispose<String>((ref) {
  // This provider will be disposed when no longer watched
  return 'Temporary data';
});

// Use family providers for parameterized data
final transactionByIdProvider = Provider.family<TransactionEntity?, String>((ref, id) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions.firstWhere((t) => t.id == id, orElse: () => null);
});

// Use select for computed values
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(transactionNotifierProvider.select((state) => state.isLoading));
});
```

### Memory Management

```dart
// Dispose resources properly
class TransactionNotifier extends StateNotifier<TransactionState> {
  final StreamSubscription? _subscription;
  
  TransactionNotifier() : super(const TransactionState()) {
    _subscription = _watchTransactions();
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Use autoDispose for temporary state
final temporaryStateProvider = StateNotifierProvider.autoDispose<TemporaryNotifier, TemporaryState>((ref) {
  return TemporaryNotifier();
});
```

---

## 🧪 Testing State Management

### Provider Testing

```dart
// test/providers/transaction_providers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transactions/presentation/viewmodels/transaction_providers.dart';

void main() {
  group('Transaction Providers', () {
    test('transactionNotifierProvider initial state is correct', () {
      final container = ProviderContainer();
      final state = container.read(transactionNotifierProvider);
      
      expect(state.transactions, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });
    
    test('totalBalanceProvider calculates correctly', () {
      final container = ProviderContainer(
        overrides: [
          transactionsStreamProvider.overrideWith((ref) => Stream.value([
            TransactionEntity(id: '1', amount: 100.0, category: 'Income', date: DateTime.now()),
            TransactionEntity(id: '2', amount: -50.0, category: 'Food', date: DateTime.now()),
          ])),
        ],
      );
      
      final totalBalance = container.read(totalBalanceProvider);
      expect(totalBalance, 50.0);
    });
  });
}
```

### State Notifier Testing

```dart
// test/notifiers/transaction_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transactions/presentation/viewmodels/transaction_notifier.dart';

void main() {
  group('TransactionNotifier', () {
    late ProviderContainer container;
    late TransactionNotifier notifier;
    
    setUp(() {
      container = ProviderContainer();
      notifier = container.read(transactionNotifierProvider.notifier);
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('addTransaction updates state correctly', () async {
      final transaction = TransactionEntity(
        id: '1',
        amount: 100.0,
        category: 'Income',
        date: DateTime.now(),
      );
      
      await notifier.addTransaction(transaction);
      
      final state = container.read(transactionNotifierProvider);
      expect(state.transactions.length, 1);
      expect(state.transactions.first.id, '1');
    });
    
    test('deleteTransaction removes transaction', () async {
      // Add transaction first
      final transaction = TransactionEntity(
        id: '1',
        amount: 100.0,
        category: 'Income',
        date: DateTime.now(),
      );
      
      await notifier.addTransaction(transaction);
      await notifier.deleteTransaction('1');
      
      final state = container.read(transactionNotifierProvider);
      expect(state.transactions, isEmpty);
    });
  });
}
```

### Widget Testing

```dart
// test/widgets/transaction_list_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transactions/presentation/widgets/transaction_list_widget.dart';

void main() {
  group('TransactionListWidget', () {
    testWidgets('displays transactions correctly', (tester) async {
      final container = ProviderContainer(
        overrides: [
          transactionNotifierProvider.overrideWith((ref) => TransactionState(
            transactions: [
              TransactionEntity(
                id: '1',
                amount: 100.0,
                category: 'Income',
                date: DateTime.now(),
              ),
            ],
          )),
        ],
      );
      
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: TransactionListWidget(),
          ),
        ),
      );
      
      expect(find.text('100.0'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
    });
    
    testWidgets('shows loading indicator when loading', (tester) async {
      final container = ProviderContainer(
        overrides: [
          transactionNotifierProvider.overrideWith((ref) => TransactionState(
            isLoading: true,
          )),
        ],
      );
      
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: TransactionListWidget(),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## 🔄 Migration Guide

### From StatefulWidget to Riverpod

```dart
// Before - StatefulWidget
class TransactionListWidget extends StatefulWidget {
  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }
  
  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _repository.getAllTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) => TransactionTile(_transactions[index]),
          );
  }
}

// After - Riverpod
class TransactionListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);
    
    return transactionState.when(
      data: (transactions) => ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(transactions[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### From Provider to Riverpod

```dart
// Before - Provider
final transactionProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).getAllTransactions();
});

// After - Riverpod
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_state_management/
├── lib/
│   ├── state_management.dart      # Main export
│   ├── providers/
│   │   ├── base_providers.dart
│   │   ├── repository_providers.dart
│   │   └── use_case_providers.dart
│   ├── notifiers/
│   │   ├── base_notifier.dart
│   │   └── state_notifier.dart
│   ├── models/
│   │   ├── base_state.dart
│   │   └── state_mixin.dart
│   └── utils/
│       ├── provider_utils.dart
│       └── state_utils.dart
├── test/
│   ├── providers/
│   ├── notifiers/
│   └── utils/
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_state_management
description: Comprehensive state management system for Flutter applications
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  freezed_annotation: ^2.4.1
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  freezed: ^2.4.7

flutter:
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_state_management:
    git:
      url: https://github.com/your-org/pocketa_state_management.git
      ref: main

// In your app
import 'package:pocketa_state_management/state_management.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

// In your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myStateProvider);
    
    return Text(state.toString());
  }
}
```

---

This comprehensive state management guide provides everything needed to implement, maintain, and extend state management across multiple projects. The system is designed to be scalable, performant, and easy to use while providing powerful state management capabilities.
