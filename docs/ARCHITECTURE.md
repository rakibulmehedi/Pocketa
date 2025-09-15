# Pocketa Architecture Documentation

## Overview

Pocketa follows Clean Architecture principles with a clear separation of concerns across multiple layers. The architecture is designed to be maintainable, testable, and scalable.

## Architecture Layers

### 1. Domain Layer (`lib/features/*/domain/`)

The innermost layer containing business logic and entities.

#### Components:
- **Entities**: Core business objects (TransactionEntity, CategoryEntity, WalletEntity)
- **Use Cases**: Business logic operations (GetTransactions, SaveTransaction, etc.)
- **Repositories**: Abstract interfaces for data access
- **Failures**: Error handling with sealed classes

#### Example Structure:
```
lib/features/transaction/domain/
├── entities/
│   ├── transaction_entity.dart
│   └── transaction_type.dart
├── repositories/
│   └── transaction_repository.dart
├── usecases/
│   ├── get_transactions.dart
│   ├── save_transaction.dart
│   └── delete_transaction.dart
└── failures/
    └── transaction_failures.dart
```

### 2. Data Layer (`lib/features/*/data/`)

Handles data persistence and external API calls.

#### Components:
- **Models**: Data transfer objects with serialization
- **Data Sources**: Hive boxes, API clients
- **Repository Implementations**: Concrete implementations of domain repositories
- **Mappers**: Convert between entities and models

#### Example Structure:
```
lib/features/transaction/data/
├── models/
│   └── transaction_model.dart
├── datasources/
│   └── transaction_local_datasource.dart
├── repositories/
│   └── transaction_repository_impl.dart
└── mappers/
    └── transaction_mapper.dart
```

### 3. Presentation Layer (`lib/features/*/presentation/`)

Handles UI and user interactions.

#### Components:
- **Pages**: Full-screen widgets
- **Widgets**: Reusable UI components
- **ViewModels**: State management with Riverpod
- **Providers**: Dependency injection

#### Example Structure:
```
lib/features/transaction/presentation/
├── pages/
│   ├── transaction_list_screen.dart
│   └── add_edit_transaction_screen.dart
├── widgets/
│   ├── transaction_tile.dart
│   └── transaction_form/
├── viewmodels/
│   ├── transaction_providers.dart
│   └── transaction_form_notifier.dart
└── providers/
    └── transaction_providers.dart
```

## State Management

### Riverpod Architecture

Pocketa uses Riverpod for state management with the following patterns:

#### 1. StateNotifier Pattern
```dart
class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier(this._repository) : super(const TransactionState());
  
  final TransactionRepository _repository;
  
  Future<void> addTransaction(TransactionEntity transaction) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.save(transaction);
      state = state.copyWith(
        isLoading: false,
        transactions: [...state.transactions, transaction],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
```

#### 2. Provider Pattern
```dart
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});
```

#### 3. Computed Providers
```dart
final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionNotifierProvider).transactions;
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});
```

## Data Flow

### 1. User Interaction Flow
```
User Action → Widget → ViewModel → Use Case → Repository → Data Source
```

### 2. State Update Flow
```
Data Source → Repository → Use Case → ViewModel → Widget → UI Update
```

### 3. Error Handling Flow
```
Error → Repository → Use Case → ViewModel → Error State → UI Error Display
```

## Dependency Injection

### Provider Hierarchy
```
App Level
├── Core Services (Database, Network, etc.)
├── Repository Providers
├── Use Case Providers
└── ViewModel Providers
```

### Example Provider Setup
```dart
void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Override for testing
        transactionRepositoryProvider.overrideWithValue(MockTransactionRepository()),
      ],
      child: MyApp(),
    ),
  );
}
```

## Design Patterns

### 1. Repository Pattern
Abstracts data access and provides a uniform interface.

```dart
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  
  TransactionRepositoryImpl(this._localDataSource);
  
  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await _localDataSource.getTransactions();
    return models.map((model) => model.toEntity()).toList();
  }
}
```

### 2. Use Case Pattern
Encapsulates business logic and coordinates between repositories.

```dart
class GetTransactionsUseCase {
  final TransactionRepository _repository;
  
  GetTransactionsUseCase(this._repository);
  
  Future<List<TransactionEntity>> call() async {
    return await _repository.getTransactions();
  }
}
```

### 3. Mapper Pattern
Converts between different data representations.

```dart
extension TransactionModelMapper on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      type: type,
      date: date,
      // ... other fields
    );
  }
}
```

## Error Handling

### Failure Classes
```dart
@freezed
class TransactionFailure with _$TransactionFailure {
  const factory TransactionFailure.network(String message) = NetworkFailure;
  const factory TransactionFailure.storage(String message) = StorageFailure;
  const factory TransactionFailure.validation(String message) = ValidationFailure;
}
```

### Error Handling in ViewModels
```dart
Future<void> addTransaction(TransactionEntity transaction) async {
  state = state.copyWith(isLoading: true);
  
  final result = await _addTransactionUseCase(transaction);
  
  result.fold(
    (failure) => state = state.copyWith(
      isLoading: false,
      error: failure.message,
    ),
    (success) => state = state.copyWith(
      isLoading: false,
      transactions: [...state.transactions, success],
    ),
  );
}
```

## Testing Strategy

### 1. Unit Tests
- Test business logic in use cases
- Test repository implementations
- Test utility functions

### 2. Widget Tests
- Test UI components in isolation
- Test user interactions
- Test state changes

### 3. Integration Tests
- Test complete user flows
- Test data persistence
- Test navigation

### 4. Golden Tests
- Test visual regression
- Test responsive design
- Test theme changes

## Performance Considerations

### 1. State Management
- Use `select` to minimize rebuilds
- Implement proper disposal
- Avoid unnecessary state updates

### 2. UI Optimization
- Use `const` constructors
- Implement `RepaintBoundary`
- Optimize list rendering

### 3. Memory Management
- Dispose controllers properly
- Clear caches when needed
- Monitor memory usage

## Security

### 1. Data Protection
- Encrypt sensitive data
- Use secure storage
- Implement proper authentication

### 2. Input Validation
- Validate all user inputs
- Sanitize data before storage
- Implement proper error handling

## Scalability

### 1. Modular Architecture
- Feature-based organization
- Loose coupling between modules
- Clear interfaces

### 2. Code Organization
- Consistent naming conventions
- Proper documentation
- Regular refactoring

### 3. Testing Coverage
- Comprehensive test coverage
- Automated testing
- Continuous integration

## Future Enhancements

### 1. Backend Integration
- REST API integration
- Real-time synchronization
- Cloud backup

### 2. Advanced Features
- AI-powered insights
- Budget recommendations
- Investment tracking

### 3. Platform Expansion
- Web application
- Desktop application
- Wearable integration
