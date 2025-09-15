# Core Services API Documentation

This document provides comprehensive API documentation for all core services in the Pocketa application.

## Table of Contents

- [Analytics Service](#analytics-service)
- [Error Handling](#error-handling)
- [Database (Hive)](#database-hive)
- [Routing](#routing)
- [Cache Management](#cache-management)
- [Sync Services](#sync-services)
- [Use Cases](#use-cases)

## Analytics Service

The analytics service provides event logging with batching for performance optimization.

### AnalyticsService

```dart
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? params});
}
```

**Methods:**

- `logEvent(String name, {Map<String, dynamic>? params})` - Logs an event with optional parameters

**Implementations:**

#### DebugAnalyticsService

```dart
class DebugAnalyticsService implements AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    if (kDebugMode) {
      _logger.i('[ANALYTICS] $name ${params ?? {}}');
    }
  }
}
```

#### BatchingAnalyticsService

```dart
class BatchingAnalyticsService implements AnalyticsService {
  BatchingAnalyticsService(
    this._sink, {
    this.maxItems = 10,
    Duration? maxDelay,
  });
}
```

**Configuration:**
- `maxItems`: Maximum number of events to batch (default: 10)
- `maxDelay`: Maximum delay before flushing batch (default: 2 seconds)

**Usage Example:**

```dart
// Get the analytics service
final analytics = ref.read(analyticsProvider);

// Log a simple event
await analytics.logEvent('user_login');

// Log an event with parameters
await analytics.logEvent('transaction_created', params: {
  'amount': 100.0,
  'category': 'food',
  'wallet_id': 'wallet_123'
});
```

## Error Handling

The error handling system provides centralized error management with different severity levels and recovery mechanisms.

### GlobalErrorHandler

```dart
class GlobalErrorHandler {
  static Future<void> initialize();
  static void addHandler(ErrorHandler handler);
  static void removeHandler(ErrorHandler handler);
  static void emitError(AppError error);
  static Future<T?> safeExecute<T>(Future<T> Function() operation, {
    String? operationName,
    T? fallbackValue,
    BuildContext? context,
  });
}
```

### AppError

```dart
class AppError {
  final ErrorType type;
  final String message;
  final StackTrace? stackTrace;
  final String? context;
  final String? library;
  final String? operation;
  final DateTime timestamp;
  final ErrorSeverity severity;
}
```

**Error Types:**
- `flutter` - Flutter framework errors
- `async` - Asynchronous operation errors
- `isolate` - Isolate-related errors
- `operation` - General operation errors
- `network` - Network-related errors
- `database` - Database operation errors
- `cache` - Cache-related errors
- `validation` - Input validation errors
- `unknown` - Unknown error types

**Error Severity Levels:**
- `low` - Low priority errors
- `medium` - Medium priority errors
- `high` - High priority errors
- `critical` - Critical errors requiring immediate attention

**Usage Example:**

```dart
// Initialize error handling
await GlobalErrorHandler.initialize();

// Add custom error handler
GlobalErrorHandler.addHandler(MyCustomErrorHandler());

// Safe execution with error handling
final result = await GlobalErrorHandler.safeExecute(
  () => riskyOperation(),
  operationName: 'risky_operation',
  fallbackValue: 'default_value',
  context: context,
);

// Emit custom error
GlobalErrorHandler.emitError(AppError(
  type: ErrorType.validation,
  message: 'Invalid input provided',
  severity: ErrorSeverity.medium,
));
```

### ErrorHandler (Interface)

```dart
abstract class ErrorHandler {
  void handleError(AppError error);
}
```

## Database (Hive)

The database service provides Hive-based local storage with automatic adapter registration and corruption recovery.

### HiveBootstrap

```dart
Future<void> hiveBootstrap() async {
  await Hive.initFlutter('pocketa_db');
  Hive
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(TransactionTypeAdapter())
    ..registerAdapter(WalletModelAdapter())
    ..registerAdapter(WalletTypeDtoAdapter())
    ..registerAdapter(CategoryModelAdapter());

  await _safeOpen<Transaction>(HiveBoxes.transactions);
  await _safeOpen<WalletModel>(HiveBoxes.wallets);
  await _safeOpen<CategoryModel>(HiveBoxes.categories);
  await _safeOpen<dynamic>(HiveBoxes.prefs);
}
```

**Features:**
- Automatic adapter registration for all models
- Safe box opening with corruption recovery
- Automatic database compaction for large datasets
- Support for multiple data types

**Usage Example:**

```dart
// Initialize database
await hiveBootstrap();

// Access boxes
final transactionBox = Hive.box<Transaction>(HiveBoxes.transactions);
final walletBox = Hive.box<WalletModel>(HiveBoxes.wallets);
final categoryBox = Hive.box<CategoryModel>(HiveBoxes.categories);
final prefsBox = Hive.box<dynamic>(HiveBoxes.prefs);
```

## Routing

The routing system uses GoRouter for navigation with automatic redirects based on onboarding status.

### Router Configuration

```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final onboardingCompleted = ref.read(onboardingCompletedProvider);
    final location = state.location;
    
    if (!onboardingCompleted && location != '/onboarding') {
      return '/onboarding';
    }
    
    if (onboardingCompleted && location == '/onboarding') {
      return '/dashboard';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/dashboard',
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    // ... more routes
  ],
);
```

**Features:**
- Automatic redirects based on onboarding status
- Nested routing support
- State management integration
- Error handling for invalid routes

## Cache Management

The cache system provides advanced caching with TTL, size limits, and automatic cleanup.

### AdvancedCache

```dart
class AdvancedCache<T> {
  AdvancedCache({
    required this.maxSize,
    this.defaultTtl = const Duration(hours: 1),
    this.cleanupInterval = const Duration(minutes: 5),
  });
  
  Future<void> put(String key, T value, {Duration? ttl});
  Future<T?> get(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<void> cleanup();
}
```

**Features:**
- Time-to-live (TTL) support
- Size-based eviction
- Automatic cleanup
- Type-safe caching

**Usage Example:**

```dart
// Create cache instance
final cache = AdvancedCache<String>(
  maxSize: 100,
  defaultTtl: Duration(hours: 2),
);

// Store data
await cache.put('user_data', 'cached_value');

// Retrieve data
final value = await cache.get('user_data');

// Remove data
await cache.remove('user_data');
```

## Sync Services

The sync system provides data synchronization with remote servers and conflict resolution.

### SyncQueue

```dart
class SyncQueue {
  Future<void> enqueue(SyncOperation operation);
  Future<void> processQueue();
  Future<void> clearQueue();
  Stream<SyncStatus> get statusStream;
}
```

**Features:**
- Queue-based synchronization
- Conflict resolution
- Retry mechanisms
- Status monitoring

## Use Cases

The use case pattern provides a clean interface for business logic operations.

### UseCase

```dart
abstract class UseCase<Out, In> {
  Future<Result<Out>> call(In params);
}

class NoParams {
  const NoParams();
}
```

**Features:**
- Generic input/output types
- Result-based error handling
- Clean separation of concerns
- Testable business logic

**Usage Example:**

```dart
class GetTransactionByIdUseCase implements UseCase<TransactionEntity, String> {
  final TransactionRepository repository;
  
  GetTransactionByIdUseCase(this.repository);
  
  @override
  Future<Result<TransactionEntity>> call(String params) async {
    try {
      final transaction = repository.getById(params);
      if (transaction == null) {
        return Result.err(NotFoundFailure('Transaction not found'));
      }
      return Result.ok(transaction);
    } catch (e) {
      return Result.err(UnknownFailure(e.toString()));
    }
  }
}
```

## Best Practices

1. **Error Handling**: Always use the GlobalErrorHandler for centralized error management
2. **Analytics**: Use descriptive event names and include relevant parameters
3. **Database**: Always use the safe open methods to handle corruption
4. **Caching**: Set appropriate TTL values based on data freshness requirements
5. **Use Cases**: Keep business logic in use cases, not in UI components
6. **Async Operations**: Use Result types for better error handling
7. **Resource Management**: Always dispose of resources properly
8. **Testing**: Mock services for unit testing

## Performance Considerations

1. **Analytics Batching**: Reduces I/O operations and improves performance
2. **Database Compaction**: Automatically handles large datasets
3. **Cache Cleanup**: Prevents memory leaks in long-running applications
4. **Error Recovery**: Graceful handling of corrupted data
5. **Resource Disposal**: Proper cleanup prevents memory leaks
