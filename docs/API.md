# Pocketa API Documentation

## Overview

This document describes the internal API structure and external integrations for the Pocketa personal finance management app.

## Internal APIs

### Core Services

#### Database Service
```dart
abstract class DatabaseService {
  Future<void> initialize();
  Future<void> close();
  Future<void> clear();
}
```

#### Analytics Service
```dart
abstract class AnalyticsService {
  Future<void> trackEvent(String eventName, Map<String, dynamic> parameters);
  Future<void> setUserProperty(String key, String value);
  Future<void> logError(String error, StackTrace stackTrace);
}
```

#### Sync Service
```dart
abstract class SyncService {
  Future<void> syncData();
  Future<bool> isOnline();
  Stream<SyncStatus> get syncStatus;
}
```

### Repository APIs

#### Transaction Repository
```dart
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<TransactionEntity?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionEntity>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<TransactionEntity>> getTransactionsByCategory(String categoryId);
  Future<List<TransactionEntity>> getTransactionsByWallet(String walletId);
  Future<double> getTotalAmountByType(TransactionType type);
  Future<double> getTotalAmountByTypeInMonth(
    TransactionType type,
    int year,
    int month,
  );
}
```

#### Category Repository
```dart
abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity?> getCategoryById(String id);
  Future<void> saveCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Future<List<CategoryEntity>> getCategoriesByType(CategoryKind type);
  Future<bool> isDefaultCategory(String categoryId);
}
```

#### Wallet Repository
```dart
abstract class WalletRepository {
  Future<List<WalletEntity>> getWallets();
  Future<WalletEntity?> getWalletById(String id);
  Future<void> saveWallet(WalletEntity wallet);
  Future<void> updateWallet(WalletEntity wallet);
  Future<void> deleteWallet(String id);
  Future<WalletEntity?> getDefaultWallet();
  Future<void> setDefaultWallet(String walletId);
}
```

### Use Case APIs

#### Transaction Use Cases
```dart
class GetTransactionsUseCase {
  Future<List<TransactionEntity>> call();
}

class SaveTransactionUseCase {
  Future<void> call(TransactionEntity transaction);
}

class DeleteTransactionUseCase {
  Future<void> call(String transactionId);
}

class GetTransactionsByDateRangeUseCase {
  Future<List<TransactionEntity>> call(DateTime startDate, DateTime endDate);
}

class GetTotalAmountByTypeUseCase {
  Future<double> call(TransactionType type);
}
```

#### Category Use Cases
```dart
class GetCategoriesUseCase {
  Future<List<CategoryEntity>> call();
}

class SaveCategoryUseCase {
  Future<void> call(CategoryEntity category);
}

class DeleteCategoryUseCase {
  Future<void> call(String categoryId);
}
```

#### Wallet Use Cases
```dart
class GetWalletsUseCase {
  Future<List<WalletEntity>> call();
}

class SaveWalletUseCase {
  Future<void> call(WalletEntity wallet);
}

class SetDefaultWalletUseCase {
  Future<void> call(String walletId);
}
```

## Data Models

### Transaction Entity
```dart
@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required TransactionType type,
    required DateTime date,
    required String categoryId,
    required String walletId,
    String? description,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TransactionEntity;
}
```

### Category Entity
```dart
@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required CategoryKind type,
    required int colorHex,
    required int iconCodePoint,
    required String iconFontFamily,
    bool isDefault = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CategoryEntity;
}
```

### Wallet Entity
```dart
@freezed
class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String id,
    required String name,
    required String currency,
    required double balance,
    bool isDefault = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WalletEntity;
}
```

## Provider APIs

### Transaction Providers
```dart
// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

// State notifier provider
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionNotifier(repository);
});

// Computed providers
final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionNotifierProvider).transactions;
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyExpensesProvider = Provider.family<double, DateTime>((ref, date) {
  final transactions = ref.watch(transactionNotifierProvider).transactions;
  return transactions
      .where((t) => t.type == TransactionType.expense && 
                   t.date.year == date.year && 
                   t.date.month == date.month)
      .fold(0.0, (sum, t) => sum + t.amount);
});
```

### Category Providers
```dart
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});

final expenseCategoriesProvider = Provider<List<CategoryEntity>>((ref) {
  final categories = ref.watch(categoryNotifierProvider).categories;
  return categories.where((c) => c.type == CategoryKind.expense).toList();
});
```

### Wallet Providers
```dart
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl();
});

final walletNotifierProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return WalletNotifier(repository);
});

final defaultWalletProvider = Provider<WalletEntity?>((ref) {
  final wallets = ref.watch(walletNotifierProvider).wallets;
  return wallets.firstWhereOrNull((w) => w.isDefault);
});
```

## External APIs

### Supabase Integration

#### Authentication
```dart
class SupabaseAuthService {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
```

#### Database Operations
```dart
class SupabaseDatabaseService {
  Future<List<Map<String, dynamic>>> getTransactions(String userId);
  Future<Map<String, dynamic>> insertTransaction(Map<String, dynamic> data);
  Future<void> updateTransaction(String id, Map<String, dynamic> data);
  Future<void> deleteTransaction(String id);
}
```

### Analytics APIs

#### Firebase Analytics
```dart
class FirebaseAnalyticsService implements AnalyticsService {
  @override
  Future<void> trackEvent(String eventName, Map<String, dynamic> parameters) async {
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
  
  @override
  Future<void> setUserProperty(String key, String value) async {
    await FirebaseAnalytics.instance.setUserProperty(
      name: key,
      value: value,
    );
  }
}
```

## Error Handling

### Failure Types
```dart
@freezed
class AppFailure with _$AppFailure {
  const factory AppFailure.network(String message) = NetworkFailure;
  const factory AppFailure.storage(String message) = StorageFailure;
  const factory AppFailure.validation(String message) = ValidationFailure;
  const factory AppFailure.authentication(String message) = AuthenticationFailure;
  const factory AppFailure.permission(String message) = PermissionFailure;
  const factory AppFailure.unknown(String message) = UnknownFailure;
}
```

### Error Handling Service
```dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Show user-friendly message
    // Handle different error types
  }
  
  static String getErrorMessage(AppFailure failure) {
    return failure.when(
      network: (message) => 'Network error: $message',
      storage: (message) => 'Storage error: $message',
      validation: (message) => 'Validation error: $message',
      authentication: (message) => 'Authentication error: $message',
      permission: (message) => 'Permission error: $message',
      unknown: (message) => 'Unknown error: $message',
    );
  }
}
```

## Configuration

### Environment Variables
```dart
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: false);
}
```

### Feature Flags
```dart
class FeatureFlags {
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableSync = true;
  static const bool enableOfflineMode = true;
}
```

## Testing APIs

### Mock Services
```dart
class MockTransactionRepository implements TransactionRepository {
  final List<TransactionEntity> _transactions = [];
  
  @override
  Future<List<TransactionEntity>> getTransactions() async {
    return _transactions;
  }
  
  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    _transactions.add(transaction);
  }
  
  // ... other methods
}
```

### Test Utilities
```dart
class TestDataFactory {
  static TransactionEntity createTransaction({
    String? id,
    double? amount,
    TransactionType? type,
  }) {
    return TransactionEntity(
      id: id ?? 'test-id',
      amount: amount ?? 100.0,
      type: type ?? TransactionType.expense,
      date: DateTime.now(),
      categoryId: 'test-category',
      walletId: 'test-wallet',
    );
  }
  
  static CategoryEntity createCategory({
    String? id,
    String? name,
    CategoryKind? type,
  }) {
    return CategoryEntity(
      id: id ?? 'test-category-id',
      name: name ?? 'Test Category',
      type: type ?? CategoryKind.expense,
      colorHex: 0xFF2196F3,
      iconCodePoint: Icons.category.codePoint,
      iconFontFamily: Icons.category.fontFamily!,
    );
  }
}
```

## Performance Monitoring

### Metrics Collection
```dart
class PerformanceMonitor {
  static void trackPageLoad(String pageName, Duration loadTime) {
    FirebaseAnalytics.instance.logEvent(
      name: 'page_load',
      parameters: {
        'page_name': pageName,
        'load_time_ms': loadTime.inMilliseconds,
      },
    );
  }
  
  static void trackUserAction(String action, Map<String, dynamic> parameters) {
    FirebaseAnalytics.instance.logEvent(
      name: 'user_action',
      parameters: {
        'action': action,
        ...parameters,
      },
    );
  }
}
```

## Security

### Data Encryption
```dart
class EncryptionService {
  static String encrypt(String data) {
    // Implement encryption logic
  }
  
  static String decrypt(String encryptedData) {
    // Implement decryption logic
  }
}
```

### Input Validation
```dart
class ValidationService {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Amount must be positive';
    }
    
    return null;
  }
  
  static String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category name is required';
    }
    
    if (value.length < 2) {
      return 'Category name must be at least 2 characters';
    }
    
    return null;
  }
}
