# Clean Architecture Implementation Guide
## PocketA - Comprehensive Clean Architecture System

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture Principles](#architecture-principles)
3. [Layer Structure](#layer-structure)
4. [Dependency Rules](#dependency-rules)
5. [Implementation Patterns](#implementation-patterns)
6. [Feature Organization](#feature-organization)
7. [Data Flow](#data-flow)
8. [Testing Strategy](#testing-strategy)
9. [Performance Considerations](#performance-considerations)
10. [Migration Guide](#migration-guide)
11. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA Clean Architecture System provides a comprehensive, scalable approach to building maintainable Flutter applications. It follows Uncle Bob's Clean Architecture principles with clear separation of concerns, dependency inversion, and testability as core tenets.

### Key Features
- **Clear Separation of Concerns**: Distinct layers with specific responsibilities
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Testability**: Each layer can be tested independently
- **Maintainability**: Easy to modify and extend features
- **Scalability**: Supports growth and team collaboration
- **Platform Independence**: Business logic is independent of UI framework

---

## 🏗️ Architecture Principles

### Core Principles

1. **Independence**: Business logic is independent of frameworks, UI, database, and external agencies
2. **Testability**: Business logic can be tested without UI, database, web server, or any external element
3. **UI Independence**: UI can change easily without changing the rest of the system
4. **Database Independence**: Business logic is not bound to the database
5. **External Agency Independence**: Business logic doesn't know about external agencies

### Dependency Rule

```
Dependencies can only point inward
┌─────────────────────────────────────┐
│           Presentation              │
│         (UI, Controllers)           │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│             Domain                  │
│        (Entities, Use Cases)        │
└─────────────▲───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│              Data                   │
│    (Repositories, Data Sources)     │
└─────────────────────────────────────┘
```

---

## 🏛️ Layer Structure

### Presentation Layer

```dart
// lib/features/transactions/presentation/
├── pages/
│   ├── transaction_list_page.dart
│   ├── add_transaction_page.dart
│   └── edit_transaction_page.dart
├── widgets/
│   ├── transaction_tile.dart
│   ├── transaction_form.dart
│   └── transaction_filters.dart
├── viewmodels/
│   ├── transaction_list_viewmodel.dart
│   ├── transaction_form_viewmodel.dart
│   └── transaction_providers.dart
└── mappers/
    └── transaction_ui_mapper.dart
```

### Domain Layer

```dart
// lib/features/transactions/domain/
├── entities/
│   ├── transaction_entity.dart
│   └── transaction_type_entity.dart
├── repositories/
│   └── transaction_repository.dart
├── usecases/
│   ├── get_transactions_usecase.dart
│   ├── add_transaction_usecase.dart
│   ├── update_transaction_usecase.dart
│   └── delete_transaction_usecase.dart
└── value_objects/
    ├── amount_value_object.dart
    └── transaction_date_value_object.dart
```

### Data Layer

```dart
// lib/features/transactions/data/
├── models/
│   ├── transaction_model.dart
│   └── transaction_type_model.dart
├── repositories/
│   └── transaction_repository_impl.dart
├── datasources/
│   ├── local/
│   │   └── transaction_local_datasource.dart
│   └── remote/
│       └── transaction_remote_datasource.dart
└── mappers/
    └── transaction_data_mapper.dart
```

---

## 🔄 Dependency Rules

### Entity Layer (Innermost)

```dart
// lib/features/transactions/domain/entities/transaction_entity.dart
class TransactionEntity {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  
  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });
  
  // Business logic methods
  bool get isIncome => amount > 0;
  bool get isExpense => amount < 0;
  
  TransactionEntity copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
```

### Use Case Layer

```dart
// lib/features/transactions/domain/usecases/get_transactions_usecase.dart
abstract class GetTransactionsUseCase {
  Future<List<TransactionEntity>> call();
}

class GetTransactionsUseCaseImpl implements GetTransactionsUseCase {
  final TransactionRepository _repository;
  
  GetTransactionsUseCaseImpl(this._repository);
  
  @override
  Future<List<TransactionEntity>> call() async {
    return await _repository.getAllTransactions();
  }
}

// lib/features/transactions/domain/usecases/add_transaction_usecase.dart
abstract class AddTransactionUseCase {
  Future<void> call(TransactionEntity transaction);
}

class AddTransactionUseCaseImpl implements AddTransactionUseCase {
  final TransactionRepository _repository;
  
  AddTransactionUseCaseImpl(this._repository);
  
  @override
  Future<void> call(TransactionEntity transaction) async {
    // Business logic validation
    if (transaction.amount == 0) {
      throw InvalidAmountException('Amount cannot be zero');
    }
    
    if (transaction.category.isEmpty) {
      throw InvalidCategoryException('Category cannot be empty');
    }
    
    await _repository.saveTransaction(transaction);
  }
}
```

### Repository Interface (Domain)

```dart
// lib/features/transactions/domain/repositories/transaction_repository.dart
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getAllTransactions();
  Future<TransactionEntity?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Stream<List<TransactionEntity>> watchTransactions();
}
```

### Repository Implementation (Data)

```dart
// lib/features/transactions/data/repositories/transaction_repository_impl.dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionDataMapper _mapper;
  
  TransactionRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._mapper,
  );
  
  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    try {
      // Try to get from local first
      final localModels = await _localDataSource.getAllTransactions();
      return localModels.map((model) => _mapper.toEntity(model)).toList();
    } catch (e) {
      // Fallback to remote
      final remoteModels = await _remoteDataSource.getAllTransactions();
      return remoteModels.map((model) => _mapper.toEntity(model)).toList();
    }
  }
  
  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final model = _mapper.toModel(transaction);
    
    // Save to local first
    await _localDataSource.saveTransaction(model);
    
    // Sync to remote in background
    _syncToRemote(model);
  }
  
  Future<void> _syncToRemote(TransactionModel model) async {
    try {
      await _remoteDataSource.saveTransaction(model);
    } catch (e) {
      // Handle sync error (could queue for later)
      print('Sync failed: $e');
    }
  }
}
```

---

## 🎨 Implementation Patterns

### Value Objects

```dart
// lib/features/transactions/domain/value_objects/amount_value_object.dart
class AmountValueObject {
  final double _value;
  
  AmountValueObject(this._value) {
    if (_value == 0) {
      throw InvalidAmountException('Amount cannot be zero');
    }
  }
  
  double get value => _value;
  
  bool get isPositive => _value > 0;
  bool get isNegative => _value < 0;
  
  AmountValueObject operator +(AmountValueObject other) {
    return AmountValueObject(_value + other._value);
  }
  
  AmountValueObject operator -(AmountValueObject other) {
    return AmountValueObject(_value - other._value);
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AmountValueObject && other._value == _value;
  }
  
  @override
  int get hashCode => _value.hashCode;
  
  @override
  String toString() => _value.toString();
}
```

### Mappers

```dart
// lib/features/transactions/data/mappers/transaction_data_mapper.dart
class TransactionDataMapper {
  TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      amount: model.amount,
      category: model.category,
      date: model.date,
      note: model.note,
    );
  }
  
  TransactionModel toModel(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      note: entity.note,
    );
  }
  
  List<TransactionEntity> toEntityList(List<TransactionModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
  
  List<TransactionModel> toModelList(List<TransactionEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
```

### Data Sources

```dart
// lib/features/transactions/data/datasources/local/transaction_local_datasource.dart
abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Stream<List<TransactionModel>> watchTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> _box;
  
  TransactionLocalDataSourceImpl(this._box);
  
  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return _box.values.toList();
  }
  
  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }
  
  @override
  Stream<List<TransactionModel>> watchTransactions() async* {
    yield _box.values.toList();
    await for (final _ in _box.watch()) {
      yield _box.values.toList();
    }
  }
}
```

---

## 🏢 Feature Organization

### Feature Structure

```
lib/features/
├── transactions/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   ├── usecases/
│   │   └── value_objects/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── datasources/
│   │   └── mappers/
│   └── presentation/
│       ├── pages/
│       ├── widgets/
│       ├── viewmodels/
│       └── mappers/
├── wallets/
│   └── [same structure]
├── categories/
│   └── [same structure]
└── budgets/
    └── [same structure]
```

### Cross-Feature Dependencies

```dart
// lib/core/domain/entities/base_entity.dart
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}

// lib/core/domain/repositories/base_repository.dart
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> save(T entity);
  Future<void> update(T entity);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
}
```

---

## 🔄 Data Flow

### Request Flow

```
UI → ViewModel → UseCase → Repository → DataSource → Database
```

### Response Flow

```
Database → DataSource → Repository → UseCase → ViewModel → UI
```

### Implementation Example

```dart
// lib/features/transactions/presentation/viewmodels/transaction_list_viewmodel.dart
class TransactionListViewModel extends StateNotifier<TransactionListState> {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  
  TransactionListViewModel(
    this._getTransactionsUseCase,
    this._addTransactionUseCase,
    this._deleteTransactionUseCase,
  ) : super(const TransactionListState.initial());
  
  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final transactions = await _getTransactionsUseCase();
      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      await _addTransactionUseCase(transaction);
      await loadTransactions(); // Refresh list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  Future<void> deleteTransaction(String id) async {
    try {
      await _deleteTransactionUseCase(id);
      await loadTransactions(); // Refresh list
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
```

---

## 🧪 Testing Strategy

### Unit Testing

```dart
// test/features/transactions/domain/usecases/get_transactions_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocketa/features/transactions/domain/usecases/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('GetTransactionsUseCase', () {
    late GetTransactionsUseCase useCase;
    late MockTransactionRepository mockRepository;
    
    setUp(() {
      mockRepository = MockTransactionRepository();
      useCase = GetTransactionsUseCaseImpl(mockRepository);
    });
    
    test('should return list of transactions when repository call is successful', () async {
      // Arrange
      final transactions = [
        TransactionEntity(id: '1', amount: 100.0, category: 'Income', date: DateTime.now()),
        TransactionEntity(id: '2', amount: -50.0, category: 'Food', date: DateTime.now()),
      ];
      when(mockRepository.getAllTransactions()).thenAnswer((_) async => transactions);
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result, equals(transactions));
      verify(mockRepository.getAllTransactions()).called(1);
    });
    
    test('should throw exception when repository call fails', () async {
      // Arrange
      when(mockRepository.getAllTransactions()).thenThrow(Exception('Database error'));
      
      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}
```

### Integration Testing

```dart
// test/features/transactions/data/repositories/transaction_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pocketa/features/transactions/data/repositories/transaction_repository_impl.dart';

void main() {
  group('TransactionRepositoryImpl Integration Tests', () {
    late Box<TransactionModel> box;
    late TransactionRepositoryImpl repository;
    
    setUp(() async {
      Hive.init('test');
      box = await Hive.openBox<TransactionModel>('test_transactions');
      repository = TransactionRepositoryImpl(box, null, TransactionDataMapper());
    });
    
    tearDown(() async {
      await box.clear();
      await box.close();
    });
    
    test('should save and retrieve transaction', () async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        amount: 100.0,
        category: 'Income',
        date: DateTime.now(),
      );
      
      // Act
      await repository.saveTransaction(transaction);
      final result = await repository.getTransactionById('1');
      
      // Assert
      expect(result, equals(transaction));
    });
  });
}
```

### Widget Testing

```dart
// test/features/transactions/presentation/widgets/transaction_tile_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transactions/presentation/widgets/transaction_tile.dart';

void main() {
  group('TransactionTile', () {
    testWidgets('displays transaction information correctly', (tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        amount: 100.0,
        category: 'Income',
        date: DateTime.now(),
      );
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: TransactionTile(transaction: transaction),
        ),
      );
      
      // Assert
      expect(find.text('100.0'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
    });
  });
}
```

---

## ⚡ Performance Considerations

### Lazy Loading

```dart
// lib/features/transactions/domain/usecases/get_transactions_usecase.dart
class GetTransactionsUseCaseImpl implements GetTransactionsUseCase {
  final TransactionRepository _repository;
  
  GetTransactionsUseCaseImpl(this._repository);
  
  @override
  Future<List<TransactionEntity>> call() async {
    // Implement pagination for large datasets
    return await _repository.getTransactions(
      limit: 50,
      offset: 0,
    );
  }
}
```

### Caching Strategy

```dart
// lib/features/transactions/data/repositories/transaction_repository_impl.dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;
  final Map<String, TransactionEntity> _cache = {};
  
  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    // Check cache first
    if (_cache.containsKey(id)) {
      return _cache[id];
    }
    
    // Load from local data source
    final model = await _localDataSource.getTransactionById(id);
    if (model != null) {
      final entity = _mapper.toEntity(model);
      _cache[id] = entity;
      return entity;
    }
    
    return null;
  }
}
```

### Memory Management

```dart
// lib/features/transactions/presentation/viewmodels/transaction_list_viewmodel.dart
class TransactionListViewModel extends StateNotifier<TransactionListState> {
  StreamSubscription? _subscription;
  
  TransactionListViewModel() : super(const TransactionListState.initial()) {
    _startWatchingTransactions();
  }
  
  void _startWatchingTransactions() {
    _subscription = _repository.watchTransactions().listen((transactions) {
      state = state.copyWith(transactions: transactions);
    });
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

---

## 🔄 Migration Guide

### From MVC to Clean Architecture

```dart
// Before - MVC
class TransactionController {
  List<Transaction> _transactions = [];
  
  Future<void> loadTransactions() async {
    _transactions = await _database.getTransactions();
    notifyListeners();
  }
  
  Future<void> addTransaction(Transaction transaction) async {
    await _database.saveTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }
}

// After - Clean Architecture
class TransactionListViewModel extends StateNotifier<TransactionListState> {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final AddTransactionUseCase _addTransactionUseCase;
  
  TransactionListViewModel(
    this._getTransactionsUseCase,
    this._addTransactionUseCase,
  ) : super(const TransactionListState.initial());
  
  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);
    try {
      final transactions = await _getTransactionsUseCase();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

### From Direct Database Access to Repository Pattern

```dart
// Before - Direct database access
class TransactionService {
  final Database _database;
  
  TransactionService(this._database);
  
  Future<List<Transaction>> getTransactions() async {
    return await _database.query('transactions');
  }
}

// After - Repository pattern
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getAllTransactions();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;
  
  TransactionRepositoryImpl(this._localDataSource, this._remoteDataSource);
  
  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    try {
      return await _localDataSource.getAllTransactions();
    } catch (e) {
      return await _remoteDataSource.getAllTransactions();
    }
  }
}
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_clean_architecture/
├── lib/
│   ├── clean_architecture.dart    # Main export
│   ├── domain/
│   │   ├── entities/
│   │   │   └── base_entity.dart
│   │   ├── repositories/
│   │   │   └── base_repository.dart
│   │   └── usecases/
│   │       └── base_usecase.dart
│   ├── data/
│   │   ├── models/
│   │   │   └── base_model.dart
│   │   ├── repositories/
│   │   │   └── base_repository_impl.dart
│   │   └── datasources/
│   │       └── base_datasource.dart
│   └── presentation/
│       ├── viewmodels/
│       │   └── base_viewmodel.dart
│       └── mappers/
│           └── base_mapper.dart
├── test/
│   ├── domain/
│   ├── data/
│   └── presentation/
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_clean_architecture
description: Clean Architecture implementation for Flutter applications
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
  mockito: ^5.4.0

flutter:
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_clean_architecture:
    git:
      url: https://github.com/your-org/pocketa_clean_architecture.git
      ref: main

// In your app
import 'package:pocketa_clean_architecture/clean_architecture.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

// In your features
class TransactionEntity extends BaseEntity {
  final double amount;
  final String category;
  
  const TransactionEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.amount,
    required this.category,
  });
}
```

---

This comprehensive clean architecture guide provides everything needed to implement, maintain, and extend clean architecture across multiple projects. The system is designed to be scalable, maintainable, and easy to understand while providing powerful architectural capabilities.
