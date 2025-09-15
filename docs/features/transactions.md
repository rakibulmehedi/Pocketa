# Transaction Feature Documentation

This document provides comprehensive documentation for the Transaction feature in the Pocketa application.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Data Models](#data-models)
- [Business Logic](#business-logic)
- [User Interface](#user-interface)
- [API Reference](#api-reference)
- [Usage Examples](#usage-examples)
- [Testing](#testing)

## Overview

The Transaction feature is the core functionality of the Pocketa application, allowing users to manage their financial transactions including income, expenses, and transfers. It provides comprehensive CRUD operations, analytics, and reporting capabilities.

### Key Features

- **Transaction Management**: Create, read, update, and delete transactions
- **Categorization**: Organize transactions by categories
- **Wallet Integration**: Associate transactions with specific wallets
- **Analytics**: Track spending patterns and financial health
- **Search & Filter**: Find transactions quickly
- **Data Export**: Export transaction data
- **Offline Support**: Work without internet connection

## Architecture

The Transaction feature follows Clean Architecture principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                  Presentation Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   UI Screens    │  │   ViewModels    │  │  Providers   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Entities      │  │   Use Cases     │  │ Repositories│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Data Sources  │  │   Models        │  │  Services   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Data Models

### TransactionEntity

The core entity representing a financial transaction.

```dart
@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required TransactionType type,
    required String description,
    required String categoryId,
    required String walletId,
    required DateTime date,
    String? note,
    String? location,
    List<String>? tags,
    @Default(false) bool isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TransactionEntity;
}
```

**Properties:**
- `id` - Unique identifier for the transaction
- `amount` - Transaction amount (positive for income, negative for expenses)
- `type` - Type of transaction (income, expense, transfer)
- `description` - Human-readable description
- `categoryId` - Reference to the category
- `walletId` - Reference to the wallet
- `date` - Transaction date and time
- `note` - Additional notes
- `location` - Transaction location
- `tags` - Searchable tags
- `isDeleted` - Soft delete flag
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### TransactionType

Enumeration of transaction types.

```dart
enum TransactionType { 
  income,    // Money coming in
  expense,   // Money going out
  transfer   // Money moving between wallets
}
```

### TransactionModel

Data transfer object for persistence.

```dart
@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  double amount;
  
  @HiveField(2)
  TransactionType type;
  
  @HiveField(3)
  String description;
  
  @HiveField(4)
  String categoryId;
  
  @HiveField(5)
  String walletId;
  
  @HiveField(6)
  DateTime date;
  
  @HiveField(7)
  String? note;
  
  @HiveField(8)
  String? location;
  
  @HiveField(9)
  List<String>? tags;
  
  @HiveField(10)
  bool isDeleted;
  
  @HiveField(11)
  DateTime? createdAt;
  
  @HiveField(12)
  DateTime? updatedAt;
}
```

## Business Logic

### Use Cases

#### UpsertTransactionUseCase

Creates or updates a transaction.

```dart
class UpsertTransactionUseCase implements UseCase<TransactionEntity, TransactionEntity> {
  final TransactionRepository repository;
  
  UpsertTransactionUseCase(this.repository);
  
  @override
  Future<Result<TransactionEntity>> call(TransactionEntity params) async {
    try {
      // Validate transaction
      final validationResult = _validateTransaction(params);
      if (validationResult != null) {
        return Result.err(validationResult);
      }
      
      // Save transaction
      await repository.upsert(params);
      
      // Log analytics event
      await _logTransactionEvent(params);
      
      return Result.ok(params);
    } catch (e) {
      return Result.err(UnknownFailure(e.toString()));
    }
  }
  
  ValidationFailure? _validateTransaction(TransactionEntity transaction) {
    if (transaction.amount == 0) {
      return ValidationFailure('Amount cannot be zero');
    }
    
    if (transaction.description.isEmpty) {
      return ValidationFailure('Description is required');
    }
    
    if (transaction.categoryId.isEmpty) {
      return ValidationFailure('Category is required');
    }
    
    if (transaction.walletId.isEmpty) {
      return ValidationFailure('Wallet is required');
    }
    
    return null;
  }
}
```

#### GetTransactionsByMonthUseCase

Retrieves transactions for a specific month.

```dart
class GetTransactionsByMonthUseCase implements UseCase<List<TransactionEntity>, GetTransactionsByMonthParams> {
  final TransactionRepository repository;
  
  GetTransactionsByMonthUseCase(this.repository);
  
  @override
  Future<Result<List<TransactionEntity>>> call(GetTransactionsByMonthParams params) async {
    try {
      final transactions = repository.byMonth(
        params.year,
        params.month,
        walletId: params.walletId,
        includeDeleted: params.includeDeleted,
      );
      
      return Result.ok(transactions);
    } catch (e) {
      return Result.err(UnknownFailure(e.toString()));
    }
  }
}
```

#### DeleteTransactionUseCase

Soft deletes a transaction.

```dart
class DeleteTransactionUseCase implements UseCase<void, String> {
  final TransactionRepository repository;
  
  DeleteTransactionUseCase(this.repository);
  
  @override
  Future<Result<void>> call(String params) async {
    try {
      await repository.deleteSoft(params);
      return Result.ok(null);
    } catch (e) {
      return Result.err(UnknownFailure(e.toString()));
    }
  }
}
```

### Repository

#### TransactionRepository

Abstract repository interface for transaction data access.

```dart
abstract class TransactionRepository {
  // Mutations
  Future<void> upsert(TransactionEntity entity);
  Future<void> upsertMany(Iterable<TransactionEntity> entities);
  Future<void> deleteHard(String id);
  Future<void> deleteSoft(String id);

  // Reads
  TransactionEntity? getById(String id);
  List<TransactionEntity> all({bool includeDeleted = false});
  List<TransactionEntity> between(
    DateTime from,
    DateTime to, {
    String? walletId,
    String? categoryId,
    TransactionType? type,
    bool includeDeleted = false,
  });
  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // Aggregates
  double totalAmountByType(
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double balanceForWallet(String walletId, {bool includeDeleted = false});
  double netForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double netAll({bool includeDeleted = false});
  List<double> monthlyNetSeries(
    int monthsBack, {
    String? walletId,
    bool includeDeleted = false,
  });
  List<Map<String, dynamic>> dailyCashflow(
    DateTime month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // Category analytics
  double totalForCategory(
    String categoryId,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double totalForCategoryType(
    String categoryId,
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  Map<String, double> amountByCategory(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
}
```

#### TransactionRepositoryImpl

Hive-based implementation of the transaction repository.

```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> _box;
  
  TransactionRepositoryImpl(this._box);
  
  @override
  Future<void> upsert(TransactionEntity entity) async {
    final model = TransactionModel.fromEntity(entity);
    await _box.put(entity.id, model);
  }
  
  @override
  Future<TransactionEntity?> getById(String id) async {
    final model = _box.get(id);
    return model?.toEntity();
  }
  
  @override
  List<TransactionEntity> all({bool includeDeleted = false}) {
    return _box.values
        .where((model) => includeDeleted || !model.isDeleted)
        .map((model) => model.toEntity())
        .toList();
  }
  
  @override
  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);
    
    return _box.values
        .where((model) {
          if (!includeDeleted && model.isDeleted) return false;
          if (walletId != null && model.walletId != walletId) return false;
          
          final date = model.date;
          return date.isAfter(startDate) && date.isBefore(endDate);
        })
        .map((model) => model.toEntity())
        .toList();
  }
  
  // ... other methods
}
```

## User Interface

### Screens

#### TransactionListScreen

Main screen displaying a list of transactions.

```dart
class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: transactions.when(
        data: (transactionList) => TransactionList(transactions: transactionList),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### AddTransactionScreen

Screen for creating new transactions.

```dart
class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategoryId;
  String? _selectedWalletId;
  DateTime _selectedDate = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        actions: [
          TextButton(
            onPressed: _saveTransaction,
            child: Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Transaction type selector
            TransactionTypeSelector(
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
            ),
            
            SizedBox(height: 16),
            
            // Amount field
            AppTextFormField(
              controller: _amountController,
              label: 'Amount',
              hint: 'Enter amount',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            
            SizedBox(height: 16),
            
            // Description field
            AppTextFormField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter description',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            
            SizedBox(height: 16),
            
            // Category selector
            CategorySelector(
              selectedCategoryId: _selectedCategoryId,
              onCategoryChanged: (categoryId) => setState(() => _selectedCategoryId = categoryId),
            ),
            
            SizedBox(height: 16),
            
            // Wallet selector
            WalletSelector(
              selectedWalletId: _selectedWalletId,
              onWalletChanged: (walletId) => setState(() => _selectedWalletId = walletId),
            ),
            
            SizedBox(height: 16),
            
            // Date picker
            DatePicker(
              selectedDate: _selectedDate,
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
            
            SizedBox(height: 16),
            
            // Note field
            AppTextFormField(
              controller: _noteController,
              label: 'Note (Optional)',
              hint: 'Enter additional notes',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    
    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      amount: double.parse(_amountController.text),
      type: _selectedType,
      description: _descriptionController.text,
      categoryId: _selectedCategoryId!,
      walletId: _selectedWalletId!,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final result = await ref.read(upsertTransactionUseCaseProvider).call(transaction);
    
    result.when(
      ok: (_) {
        Navigator.pop(context);
        SnackbarService.showSuccess(context, message: 'Transaction saved successfully');
      },
      err: (failure) {
        SnackbarService.showError(context, message: failure.message);
      },
    );
  }
}
```

### Widgets

#### TransactionList

Widget for displaying a list of transactions.

```dart
class TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No transactions yet', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text('Tap the + button to add your first transaction'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionTile(transaction: transaction);
      },
    );
  }
}
```

#### TransactionTile

Individual transaction item widget.

```dart
class TransactionTile extends ConsumerWidget {
  final TransactionEntity transaction;
  
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryByIdProvider(transaction.categoryId));
    final wallet = ref.watch(walletByIdProvider(transaction.walletId));
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(transaction.type),
          child: Icon(_getTypeIcon(transaction.type)),
        ),
        title: Text(transaction.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category != null) Text(category.name),
            if (wallet != null) Text(wallet.name),
            Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatAmount(transaction.amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getAmountColor(transaction.amount),
              ),
            ),
            if (transaction.note != null)
              Text(
                transaction.note!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        onTap: () => _navigateToEditTransaction(context, transaction),
      ),
    );
  }
  
  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }
  
  IconData _getTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.arrow_downward;
      case TransactionType.expense:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }
  
  String _formatAmount(double amount) {
    return '${amount >= 0 ? '+' : ''}${NumberFormat.currency(symbol: '\$').format(amount)}';
  }
  
  Color _getAmountColor(double amount) {
    return amount >= 0 ? Colors.green : Colors.red;
  }
}
```

## API Reference

### Providers

#### Transaction Providers

```dart
// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepositoryImpl(box);
});

// Use case providers
final upsertTransactionUseCaseProvider = Provider<UpsertTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return UpsertTransactionUseCase(repository);
});

final getTransactionsByMonthUseCaseProvider = Provider<GetTransactionsByMonthUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsByMonthUseCase(repository);
});

// Stream providers
final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

final monthlyTransactionsProvider = StreamProvider.family.autoDispose<List<TransactionEntity>, MonthlyTransactionsParams>((ref, params) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchByMonth(params.year, params.month, walletId: params.walletId);
});
```

### State Management

#### Transaction State

```dart
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default([]) List<TransactionEntity> transactions,
    @Default(false) bool isLoading,
    String? error,
    @Default(TransactionFilter()) TransactionFilter filter,
    @Default(TransactionSort()) TransactionSort sort,
  }) = _TransactionState;
}
```

#### Transaction Filter

```dart
@freezed
class TransactionFilter with _$TransactionFilter {
  const factory TransactionFilter({
    DateTime? startDate,
    DateTime? endDate,
    String? walletId,
    String? categoryId,
    TransactionType? type,
    String? searchQuery,
    @Default(false) bool includeDeleted,
  }) = _TransactionFilter;
}
```

#### Transaction Sort

```dart
@freezed
class TransactionSort with _$TransactionSort {
  const factory TransactionSort({
    @Default(TransactionSortField.date) TransactionSortField field,
    @Default(SortOrder.descending) SortOrder order,
  }) = _TransactionSort;
}

enum TransactionSortField { date, amount, description, category }
enum SortOrder { ascending, descending }
```

## Usage Examples

### Creating a Transaction

```dart
// Create a new transaction
final transaction = TransactionEntity(
  id: const Uuid().v4(),
  amount: 100.0,
  type: TransactionType.expense,
  description: 'Coffee',
  categoryId: 'cat_food',
  walletId: 'wallet_1',
  date: DateTime.now(),
  note: 'Morning coffee',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Save the transaction
final result = await ref.read(upsertTransactionUseCaseProvider).call(transaction);
result.when(
  ok: (savedTransaction) => print('Transaction saved: ${savedTransaction.id}'),
  err: (failure) => print('Error: ${failure.message}'),
);
```

### Retrieving Monthly Transactions

```dart
// Get transactions for January 2024
final result = await ref.read(getTransactionsByMonthUseCaseProvider).call(
  GetTransactionsByMonthParams(
    year: 2024,
    month: 1,
    walletId: 'wallet_1',
  ),
);

result.when(
  ok: (transactions) => print('Found ${transactions.length} transactions'),
  err: (failure) => print('Error: ${failure.message}'),
);
```

### Watching Transaction Stream

```dart
// Watch all transactions
final transactionsAsync = ref.watch(transactionsStreamProvider);

transactionsAsync.when(
  data: (transactions) => print('Total transactions: ${transactions.length}'),
  loading: () => print('Loading transactions...'),
  error: (error, stack) => print('Error: $error'),
);
```

### Filtering Transactions

```dart
// Filter transactions by type and date range
final filteredTransactions = transactions.where((transaction) {
  if (transaction.type != TransactionType.expense) return false;
  if (transaction.date.isBefore(DateTime(2024, 1, 1))) return false;
  if (transaction.date.isAfter(DateTime(2024, 1, 31))) return false;
  return true;
}).toList();
```

## Testing

### Unit Tests

#### Use Case Tests

```dart
void main() {
  group('UpsertTransactionUseCase', () {
    late MockTransactionRepository mockRepository;
    late UpsertTransactionUseCase useCase;
    
    setUp(() {
      mockRepository = MockTransactionRepository();
      useCase = UpsertTransactionUseCase(mockRepository);
    });
    
    test('should save transaction when valid', () async {
      // Arrange
      final transaction = TransactionEntity(
        id: 'test_id',
        amount: 100.0,
        type: TransactionType.expense,
        description: 'Test transaction',
        categoryId: 'cat_1',
        walletId: 'wallet_1',
        date: DateTime.now(),
      );
      
      when(mockRepository.upsert(any)).thenAnswer((_) async {});
      
      // Act
      final result = await useCase.call(transaction);
      
      // Assert
      expect(result.isOk, true);
      verify(mockRepository.upsert(transaction)).called(1);
    });
    
    test('should return validation error when amount is zero', () async {
      // Arrange
      final transaction = TransactionEntity(
        id: 'test_id',
        amount: 0.0,
        type: TransactionType.expense,
        description: 'Test transaction',
        categoryId: 'cat_1',
        walletId: 'wallet_1',
        date: DateTime.now(),
      );
      
      // Act
      final result = await useCase.call(transaction);
      
      // Assert
      expect(result.isErr, true);
      expect(result.err, isA<ValidationFailure>());
      verifyNever(mockRepository.upsert(any));
    });
  });
}
```

#### Repository Tests

```dart
void main() {
  group('TransactionRepositoryImpl', () {
    late Box<Transaction> mockBox;
    late TransactionRepositoryImpl repository;
    
    setUp(() {
      mockBox = MockBox<Transaction>();
      repository = TransactionRepositoryImpl(mockBox);
    });
    
    test('should save transaction', () async {
      // Arrange
      final transaction = TransactionEntity(
        id: 'test_id',
        amount: 100.0,
        type: TransactionType.expense,
        description: 'Test transaction',
        categoryId: 'cat_1',
        walletId: 'wallet_1',
        date: DateTime.now(),
      );
      
      when(mockBox.put(any, any)).thenAnswer((_) async {});
      
      // Act
      await repository.upsert(transaction);
      
      // Assert
      verify(mockBox.put(transaction.id, any)).called(1);
    });
    
    test('should retrieve transaction by id', () {
      // Arrange
      final transactionModel = TransactionModel()
        ..id = 'test_id'
        ..amount = 100.0
        ..type = TransactionType.expense
        ..description = 'Test transaction'
        ..categoryId = 'cat_1'
        ..walletId = 'wallet_1'
        ..date = DateTime.now();
      
      when(mockBox.get('test_id')).thenReturn(transactionModel);
      
      // Act
      final result = repository.getById('test_id');
      
      // Assert
      expect(result, isNotNull);
      expect(result!.id, 'test_id');
      expect(result.amount, 100.0);
    });
  });
}
```

### Widget Tests

```dart
void main() {
  group('TransactionTile', () {
    testWidgets('should display transaction information', (tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: 'test_id',
        amount: 100.0,
        type: TransactionType.expense,
        description: 'Test transaction',
        categoryId: 'cat_1',
        walletId: 'wallet_1',
        date: DateTime.now(),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: TransactionTile(transaction: transaction),
        ),
      );
      
      // Assert
      expect(find.text('Test transaction'), findsOneWidget);
      expect(find.text('\$100.00'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });
  });
}
```

## Best Practices

1. **Data Validation**: Always validate transaction data before saving
2. **Error Handling**: Use Result types for proper error handling
3. **State Management**: Use reactive state management with streams
4. **Performance**: Implement pagination for large transaction lists
5. **Testing**: Write comprehensive unit and widget tests
6. **Accessibility**: Ensure all UI components are accessible
7. **Localization**: Support multiple languages and currencies
8. **Offline Support**: Handle offline scenarios gracefully
