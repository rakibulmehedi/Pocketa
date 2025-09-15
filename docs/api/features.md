# Features API Documentation

This document provides comprehensive API documentation for all feature modules in the Pocketa application.

## Table of Contents

- [Onboarding Feature](#onboarding-feature)
- [Transaction Feature](#transaction-feature)
- [Category Feature](#category-feature)
- [Wallet Feature](#wallet-feature)
- [Dashboard Feature](#dashboard-feature)

## Onboarding Feature

The onboarding feature provides a multi-step user onboarding experience with personalization and feature awareness.

### Entities

#### OnboardingData

```dart
@freezed
class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    @Default(OnboardingStep.featureAwareness1) OnboardingStep currentStep,
    @Default('bn') String language,
    @Default(UserType.student) UserType userType,
    @Default('BDT') String currency,
    @Default(SpendingFrequency.daily) SpendingFrequency spendingFrequency,
    @Default(false) bool dailyReminder,
    @Default(false) bool onboardingCompleted,
    @Default({}) Map<String, dynamic> preferences,
  }) = _OnboardingData;
}
```

**Properties:**
- `currentStep` - Current onboarding step
- `language` - Selected language code
- `userType` - Type of user (student, freelancer, family)
- `currency` - Selected currency code
- `spendingFrequency` - How often user spends money
- `dailyReminder` - Whether daily reminders are enabled
- `onboardingCompleted` - Whether onboarding is complete
- `preferences` - Additional user preferences

#### OnboardingStep

```dart
enum OnboardingStep { 
  featureAwareness1,  // Emotional hook
  featureAwareness2,  // Core features  
  featureAwareness3,  // Trust & security
  personalization,    // Language, income, currency, habits
  seedMotivation,     // Plant your seed
  authentication,     // Login/signup
  completed
}
```

#### UserType

```dart
enum UserType { student, freelancer, family }
```

#### SpendingFrequency

```dart
enum SpendingFrequency { daily, weekly, monthly }
```

### Repository

#### OnboardingRepository

```dart
abstract class OnboardingRepository {
  Future<void> saveOnboardingData(OnboardingData data);
  Future<OnboardingData?> getOnboardingData();
  Future<void> completeOnboarding();
  Future<void> resetOnboarding();
}
```

**Methods:**
- `saveOnboardingData(OnboardingData data)` - Save onboarding data
- `getOnboardingData()` - Retrieve current onboarding data
- `completeOnboarding()` - Mark onboarding as complete
- `resetOnboarding()` - Reset onboarding data

### Providers

#### OnboardingNotifier

```dart
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._repository, this._analytics);
  
  Future<void> updateStep(OnboardingStep step);
  Future<void> updateLanguage(String language);
  Future<void> updateUserType(UserType userType);
  Future<void> updateCurrency(String currency);
  Future<void> updateSpendingFrequency(SpendingFrequency frequency);
  Future<void> updateDailyReminder(bool enabled);
  Future<void> completeOnboarding();
  Future<void> resetOnboarding();
}
```

**Usage Example:**

```dart
// Watch onboarding state
final onboardingState = ref.watch(onboardingNotifierProvider);

// Update onboarding step
ref.read(onboardingNotifierProvider.notifier).updateStep(OnboardingStep.personalization);

// Complete onboarding
ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
```

## Transaction Feature

The transaction feature manages financial transactions with CRUD operations and analytics.

### Entities

#### TransactionEntity

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
- `id` - Unique transaction identifier
- `amount` - Transaction amount
- `type` - Transaction type (income, expense, transfer)
- `description` - Transaction description
- `categoryId` - Associated category ID
- `walletId` - Associated wallet ID
- `date` - Transaction date
- `note` - Additional notes
- `location` - Transaction location
- `tags` - Transaction tags
- `isDeleted` - Soft delete flag

#### TransactionType

```dart
enum TransactionType { income, expense, transfer }
```

### Repository

#### TransactionRepository

```dart
abstract class TransactionRepository {
  // Mutations
  Future<void> upsert(TransactionEntity e);
  Future<void> upsertMany(Iterable<TransactionEntity> list);
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

### Use Cases

#### UpsertTransactionUseCase

```dart
class UpsertTransactionUseCase implements UseCase<TransactionEntity, TransactionEntity> {
  final TransactionRepository repository;
  
  UpsertTransactionUseCase(this.repository);
  
  @override
  Future<Result<TransactionEntity>> call(TransactionEntity params) async {
    try {
      await repository.upsert(params);
      return Result.ok(params);
    } catch (e) {
      return Result.err(UnknownFailure(e.toString()));
    }
  }
}
```

#### GetTransactionsByMonthUseCase

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

**Usage Example:**

```dart
// Create transaction
final transaction = TransactionEntity(
  id: 'tx_123',
  amount: 100.0,
  type: TransactionType.expense,
  description: 'Coffee',
  categoryId: 'cat_food',
  walletId: 'wallet_1',
  date: DateTime.now(),
);

// Save transaction
final result = await ref.read(upsertTransactionUseCaseProvider).call(transaction);
result.when(
  ok: (savedTransaction) => print('Transaction saved: ${savedTransaction.id}'),
  err: (failure) => print('Error: ${failure.message}'),
);

// Get monthly transactions
final monthlyResult = await ref.read(getTransactionsByMonthUseCaseProvider).call(
  GetTransactionsByMonthParams(
    year: 2024,
    month: 1,
    walletId: 'wallet_1',
  ),
);
```

## Category Feature

The category feature manages transaction categories with hierarchical organization.

### Entities

#### CategoryEntity

```dart
@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required String icon,
    required CategoryType type,
    String? parentId,
    String? color,
    int? sortOrder,
    @Default(false) bool isDefault,
    @Default(false) bool isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CategoryEntity;
}
```

**Properties:**
- `id` - Unique category identifier
- `name` - Category name
- `icon` - Category icon identifier
- `type` - Category type (income, expense, transfer)
- `parentId` - Parent category ID for hierarchical organization
- `color` - Category color
- `sortOrder` - Display order
- `isDefault` - Whether it's a default category
- `isDeleted` - Soft delete flag

#### CategoryType

```dart
enum CategoryType { income, expense, transfer }
```

### Repository

#### CategoryRepository

```dart
abstract class CategoryRepository {
  Future<void> upsert(CategoryEntity category);
  Future<void> delete(String id);
  Future<CategoryEntity?> getById(String id);
  Future<List<CategoryEntity>> getAll();
  Future<List<CategoryEntity>> getByType(CategoryType type);
  Future<List<CategoryEntity>> getByParent(String? parentId);
  Stream<List<CategoryEntity>> watchAll();
}
```

**Usage Example:**

```dart
// Create category
final category = CategoryEntity(
  id: 'cat_food',
  name: 'Food & Dining',
  icon: 'restaurant',
  type: CategoryType.expense,
  color: '#FF5722',
);

// Save category
await ref.read(saveCategoryProvider).call(category);

// Get categories by type
final expenseCategories = await ref.read(categoryRepoProvider).getByType(CategoryType.expense);
```

## Wallet Feature

The wallet feature manages user wallets and accounts.

### Entities

#### WalletEntity

```dart
@freezed
class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String id,
    required String name,
    required WalletType type,
    required String currency,
    double? balance,
    String? description,
    String? color,
    @Default(false) bool isDefault,
    @Default(false) bool isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WalletEntity;
}
```

**Properties:**
- `id` - Unique wallet identifier
- `name` - Wallet name
- `type` - Wallet type (cash, bank, credit, investment)
- `currency` - Wallet currency
- `balance` - Current balance
- `description` - Wallet description
- `color` - Wallet color
- `isDefault` - Whether it's the default wallet
- `isDeleted` - Soft delete flag

#### WalletType

```dart
enum WalletType { cash, bank, credit, investment }
```

### Repository

#### WalletRepository

```dart
abstract class WalletRepository {
  Future<void> upsert(WalletEntity wallet);
  Future<void> delete(String id);
  Future<WalletEntity?> getById(String id);
  Future<List<WalletEntity>> getAll();
  Future<WalletEntity?> getDefault();
  Stream<List<WalletEntity>> watchAll();
}
```

**Usage Example:**

```dart
// Create wallet
final wallet = WalletEntity(
  id: 'wallet_1',
  name: 'Main Account',
  type: WalletType.bank,
  currency: 'BDT',
  balance: 1000.0,
  color: '#2196F3',
);

// Save wallet
await ref.read(saveWalletProvider).call(wallet);

// Get all wallets
final wallets = await ref.read(walletRepoProvider).getAll();
```

## Dashboard Feature

The dashboard feature provides an overview of financial data and navigation.

### DashboardScreen

```dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Implementation
  }
}
```

**Features:**
- Bottom navigation bar
- Responsive layout
- Analytics tracking
- Navigation state management

### Navigation

#### navIndexProvider

```dart
final navIndexProvider = StateProvider<int>((ref) => 0);
```

**Navigation Destinations:**
- Dashboard (Home)
- Transactions
- Budgets
- Wallets

**Usage Example:**

```dart
// Watch navigation index
final navIndex = ref.watch(navIndexProvider);

// Update navigation index
ref.read(navIndexProvider.notifier).state = 1; // Navigate to transactions
```

## Best Practices

1. **Entity Design**: Use freezed for immutable entities with proper serialization
2. **Repository Pattern**: Implement repositories for data access abstraction
3. **Use Cases**: Keep business logic in use cases, not in UI components
4. **State Management**: Use Riverpod providers for reactive state management
5. **Error Handling**: Use Result types for better error handling
6. **Validation**: Implement proper validation for all inputs
7. **Testing**: Write unit tests for use cases and repositories
8. **Performance**: Use streams for reactive data updates

## Performance Considerations

1. **Data Loading**: Use pagination for large datasets
2. **Caching**: Implement proper caching strategies
3. **Streams**: Use streams for real-time data updates
4. **Memory**: Dispose of resources properly
5. **Database**: Use efficient database queries
6. **UI Updates**: Minimize unnecessary widget rebuilds
7. **Analytics**: Batch analytics events for better performance
8. **Error Recovery**: Implement graceful error recovery mechanisms
