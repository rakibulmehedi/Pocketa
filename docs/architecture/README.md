# Architecture Documentation

This document provides comprehensive architecture documentation for the Pocketa application.

## Table of Contents

- [Overview](#overview)
- [Clean Architecture](#clean-architecture)
- [Project Structure](#project-structure)
- [Design Patterns](#design-patterns)
- [State Management](#state-management)
- [Data Flow](#data-flow)
- [Dependency Injection](#dependency-injection)
- [Error Handling](#error-handling)
- [Performance Considerations](#performance-considerations)

## Overview

Pocketa is a Flutter-based personal finance management application built using Clean Architecture principles. The application follows a layered architecture with clear separation of concerns, making it maintainable, testable, and scalable.

### Key Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Testability**: Easy to unit test each component

## Clean Architecture

The application follows Clean Architecture with three main layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   UI Widgets    │  │   ViewModels    │  │  Providers   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Entities      │  │   Use Cases     │  │ Repositories│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Data Sources  │  │   Models        │  │  Services   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer
- **UI Widgets**: Flutter widgets for user interface
- **ViewModels**: State management and business logic coordination
- **Providers**: Riverpod providers for dependency injection

#### Domain Layer
- **Entities**: Core business objects
- **Use Cases**: Business logic implementation
- **Repository Interfaces**: Data access contracts

#### Data Layer
- **Data Sources**: Local and remote data sources
- **Models**: Data transfer objects
- **Services**: External service integrations

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── analytics/          # Analytics service
│   ├── cache/              # Caching system
│   ├── constants/          # App constants
│   ├── db/                 # Database configuration
│   ├── error_handling/     # Error handling system
│   ├── locale/             # Localization
│   ├── providers/          # Core providers
│   ├── responsive/         # Responsive design
│   ├── routing/            # Navigation
│   ├── sync/               # Data synchronization
│   ├── theme/              # Theme configuration
│   └── usecase/            # Use case base classes
├── features/               # Feature modules
│   ├── onboarding/         # Onboarding feature
│   │   ├── data/          # Data layer
│   │   ├── domain/        # Domain layer
│   │   └── presentation/  # Presentation layer
│   ├── transaction/        # Transaction feature
│   ├── category/           # Category feature
│   ├── wallet/             # Wallet feature
│   └── dashboard/          # Dashboard feature
├── shared/                 # Shared components
│   ├── services/           # Shared services
│   └── widgets/            # Shared widgets
└── l10n/                   # Localization files
```

## Design Patterns

### Repository Pattern

The Repository pattern abstracts data access and provides a clean interface for data operations.

```dart
abstract class TransactionRepository {
  Future<void> upsert(TransactionEntity entity);
  Future<TransactionEntity?> getById(String id);
  Future<List<TransactionEntity>> getAll();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> _box;
  
  TransactionRepositoryImpl(this._box);
  
  @override
  Future<void> upsert(TransactionEntity entity) async {
    // Implementation
  }
}
```

### Use Case Pattern

Use cases encapsulate business logic and provide a clean interface for operations.

```dart
class UpsertTransactionUseCase implements UseCase<TransactionEntity, TransactionEntity> {
  final TransactionRepository repository;
  
  UpsertTransactionUseCase(this.repository);
  
  @override
  Future<Result<TransactionEntity>> call(TransactionEntity params) async {
    // Business logic implementation
  }
}
```

### Provider Pattern

Riverpod providers manage dependencies and state.

```dart
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepositoryImpl(box);
});

final upsertTransactionUseCaseProvider = Provider<UpsertTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return UpsertTransactionUseCase(repository);
});
```

### Observer Pattern

The application uses streams and providers for reactive programming.

```dart
final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});
```

## State Management

The application uses Riverpod for state management with the following patterns:

### StateNotifier

For complex state management with business logic:

```dart
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier(this._repository, this._analytics);
  
  Future<void> updateStep(OnboardingStep step) async {
    // Update logic
  }
}
```

### Provider

For simple state and dependencies:

```dart
final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  final analytics = ref.watch(analyticsProvider);
  return OnboardingNotifier(repository, analytics);
});
```

### StreamProvider

For reactive data streams:

```dart
final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});
```

## Data Flow

The application follows a unidirectional data flow:

```
User Action → ViewModel → Use Case → Repository → Data Source
     ↑                                                      ↓
     └─────────────── UI Update ← State ← Result ←──────────┘
```

### Example Flow

1. **User Action**: User taps "Save Transaction" button
2. **ViewModel**: OnboardingNotifier receives the action
3. **Use Case**: UpsertTransactionUseCase processes the business logic
4. **Repository**: TransactionRepository saves the data
5. **Data Source**: Hive database stores the transaction
6. **State Update**: State is updated with the result
7. **UI Update**: UI reflects the new state

## Dependency Injection

The application uses Riverpod for dependency injection:

### Provider Hierarchy

```dart
// Core providers
final analyticsProvider = Provider<AnalyticsService>((ref) => ...);
final errorHandlerProvider = Provider<ErrorHandler>((ref) => ...);

// Data providers
final transactionBoxProvider = Provider<Box<Transaction>>((ref) => ...);
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) => ...);

// Use case providers
final upsertTransactionUseCaseProvider = Provider<UpsertTransactionUseCase>((ref) => ...);

// State providers
final transactionsStreamProvider = StreamProvider<List<TransactionEntity>>((ref) => ...);
```

### Provider Dependencies

Providers can depend on other providers:

```dart
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final box = ref.watch(transactionBoxProvider);
  return TransactionRepositoryImpl(box);
});
```

## Error Handling

The application implements a comprehensive error handling system:

### Error Types

```dart
enum ErrorType {
  flutter,
  async,
  isolate,
  operation,
  network,
  database,
  cache,
  validation,
  unknown,
}
```

### Error Severity

```dart
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}
```

### Error Handling Flow

1. **Error Occurs**: Exception is thrown
2. **Error Capture**: GlobalErrorHandler captures the error
3. **Error Processing**: Error is processed and categorized
4. **Error Notification**: UI is notified of the error
5. **User Feedback**: User sees appropriate error message

### Result Pattern

The application uses the Result pattern for error handling:

```dart
final result = await useCase.call(params);
result.when(
  ok: (data) => handleSuccess(data),
  err: (failure) => handleError(failure),
);
```

## Performance Considerations

### Widget Optimization

- **PerformanceOptimizedWidget**: Base class for complex widgets
- **PerformanceOptimizedMixin**: Automatic resource disposal
- **RepaintBoundary**: Isolate repaints for complex widgets

### State Management Optimization

- **select**: Use select to watch specific parts of state
- **autoDispose**: Automatically dispose providers when not needed
- **family**: Use family providers for parameterized providers

### Data Optimization

- **Pagination**: Implement pagination for large datasets
- **Caching**: Use caching for frequently accessed data
- **Lazy Loading**: Load data only when needed

### Memory Management

- **Disposal**: Properly dispose of resources
- **Streams**: Close streams when not needed
- **Controllers**: Dispose controllers properly

## Security Considerations

### Data Protection

- **Local Storage**: Sensitive data stored locally with encryption
- **Input Validation**: All inputs are validated
- **Error Handling**: Sensitive information not exposed in errors

### Authentication

- **Secure Storage**: Credentials stored securely
- **Session Management**: Proper session handling
- **Token Management**: Secure token storage and refresh

## Testing Strategy

### Unit Testing

- **Use Cases**: Test business logic in isolation
- **Repositories**: Test data access logic
- **Services**: Test service implementations

### Widget Testing

- **UI Components**: Test widget behavior
- **User Interactions**: Test user interactions
- **State Changes**: Test state management

### Integration Testing

- **Feature Flows**: Test complete feature flows
- **Data Persistence**: Test data persistence
- **Error Scenarios**: Test error handling

## Scalability Considerations

### Code Organization

- **Feature Modules**: Each feature is self-contained
- **Shared Components**: Reusable components in shared folder
- **Core Services**: Common services in core folder

### Performance Scaling

- **Database Optimization**: Efficient database queries
- **Memory Management**: Proper resource management
- **Caching Strategy**: Effective caching implementation

### Team Scalability

- **Clear Architecture**: Easy for new team members to understand
- **Documentation**: Comprehensive documentation
- **Code Standards**: Consistent coding standards
