# Pocketa Testing Guide

## Overview

This document outlines the testing strategy, guidelines, and best practices for the Pocketa personal finance management app.

## Testing Strategy

### 1. Testing Pyramid

```
    /\
   /  \
  /    \
 /      \
/________\
E2E Tests
Widget Tests
Unit Tests
```

- **Unit Tests (70%)**: Test business logic, use cases, and utilities
- **Widget Tests (20%)**: Test UI components and user interactions
- **Integration Tests (10%)**: Test complete user flows and data persistence

### 2. Testing Goals

- **Reliability**: Ensure the app works consistently across different scenarios
- **Performance**: Verify the app meets performance requirements
- **Accessibility**: Ensure the app is accessible to all users
- **Maintainability**: Make tests easy to understand and maintain

## Unit Testing

### 1. Test Structure

```dart
void main() {
  group('TransactionNotifier', () {
    late TransactionNotifier notifier;
    late MockTransactionRepository mockRepository;
    
    setUp(() {
      mockRepository = MockTransactionRepository();
      notifier = TransactionNotifier(mockRepository);
    });
    
    tearDown(() {
      notifier.dispose();
    });
    
    group('loadTransactions', () {
      test('should load transactions successfully', () async {
        // Arrange
        final transactions = [createTestTransaction()];
        when(() => mockRepository.getTransactions())
            .thenAnswer((_) async => transactions);
        
        // Act
        await notifier.loadTransactions();
        
        // Assert
        expect(notifier.state.transactions, equals(transactions));
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isNull);
      });
      
      test('should handle error when loading transactions fails', () async {
        // Arrange
        final error = Exception('Failed to load transactions');
        when(() => mockRepository.getTransactions())
            .thenThrow(error);
        
        // Act
        await notifier.loadTransactions();
        
        // Assert
        expect(notifier.state.transactions, isEmpty);
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, equals(error.toString()));
      });
    });
  });
}
```

### 2. Test Categories

#### Business Logic Tests
```dart
group('TransactionUseCase', () {
  test('should calculate total expenses correctly', () {
    // Arrange
    final transactions = [
      createTransaction(amount: 100, type: TransactionType.expense),
      createTransaction(amount: 200, type: TransactionType.expense),
      createTransaction(amount: 50, type: TransactionType.income),
    ];
    
    // Act
    final total = calculateTotalExpenses(transactions);
    
    // Assert
    expect(total, equals(300));
  });
});
```

#### Repository Tests
```dart
group('TransactionRepositoryImpl', () {
  test('should save transaction to local storage', () async {
    // Arrange
    final transaction = createTestTransaction();
    final mockBox = MockBox<TransactionModel>();
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    
    // Act
    await repository.saveTransaction(transaction);
    
    // Assert
    verify(() => mockBox.put(transaction.id, any())).called(1);
  });
});
```

#### Utility Tests
```dart
group('CurrencyUtils', () {
  test('should format currency correctly', () {
    expect(CurrencyUtils.format(1000, 'USD'), equals('\$1,000.00'));
    expect(CurrencyUtils.format(1000, 'BDT'), equals('৳1,000.00'));
  });
  
  test('should parse currency string correctly', () {
    expect(CurrencyUtils.parse('\$1,000.00'), equals(1000.0));
    expect(CurrencyUtils.parse('৳1,000.00'), equals(1000.0));
  });
});
```

### 3. Mocking

#### Mock Classes
```dart
class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockTransactionNotifier extends Mock implements TransactionNotifier {}

class MockBox<T> extends Mock implements Box<T> {}
```

#### Mock Setup
```dart
setUp(() {
  mockRepository = MockTransactionRepository();
  when(() => mockRepository.getTransactions())
      .thenAnswer((_) async => []);
});
```

## Widget Testing

### 1. Basic Widget Tests

```dart
void main() {
  group('TransactionTile', () {
    testWidgets('should display transaction information', (tester) async {
      // Arrange
      final transaction = createTestTransaction(
        description: 'Coffee',
        amount: 5.50,
        type: TransactionType.expense,
      );
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TransactionTile(transaction: transaction),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('\$5.50'), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
    
    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      final transaction = createTestTransaction();
      bool wasTapped = false;
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TransactionTile(
              transaction: transaction,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(TransactionTile));
      await tester.pump();
      
      // Assert
      expect(wasTapped, isTrue);
    });
  });
}
```

### 2. Form Testing

```dart
group('TransactionForm', () {
  testWidgets('should validate required fields', (tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: TransactionForm(formKey: formKey),
        ),
      ),
    );
    
    await tester.tap(find.text('Save'));
    await tester.pump();
    
    // Assert
    expect(find.text('Amount is required'), findsOneWidget);
    expect(find.text('Category is required'), findsOneWidget);
  });
  
  testWidgets('should submit form with valid data', (tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    final mockNotifier = MockTransactionNotifier();
    
    when(() => mockNotifier.addTransaction(any()))
        .thenAnswer((_) async {});
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionNotifierProvider.overrideWithValue(mockNotifier),
        ],
        child: MaterialApp(
          home: TransactionForm(formKey: formKey),
        ),
      ),
    );
    
    await tester.enterText(find.byType(TextField).first, '100');
    await tester.tap(find.text('Save'));
    await tester.pump();
    
    // Assert
    verify(() => mockNotifier.addTransaction(any())).called(1);
  });
});
```

### 3. State Testing

```dart
group('TransactionList', () {
  testWidgets('should display loading state', (tester) async {
    // Arrange
    final mockNotifier = MockTransactionNotifier();
    when(() => mockNotifier.state)
        .thenReturn(const TransactionState(isLoading: true));
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionNotifierProvider.overrideWithValue(mockNotifier),
        ],
        child: MaterialApp(
          home: TransactionList(),
        ),
      ),
    );
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('should display error state', (tester) async {
    // Arrange
    final mockNotifier = MockTransactionNotifier();
    when(() => mockNotifier.state)
        .thenReturn(const TransactionState(error: 'Failed to load'));
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionNotifierProvider.overrideWithValue(mockNotifier),
        ],
        child: MaterialApp(
          home: TransactionList(),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Failed to load'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
});
```

## Integration Testing

### 1. End-to-End Tests

```dart
void main() {
  group('Transaction Flow', () {
    testWidgets('should add new transaction', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      
      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byType(TextField).first, '100');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('100'), findsOneWidget);
    });
    
    testWidgets('should edit existing transaction', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      
      // Act
      await tester.tap(find.byType(TransactionTile).first);
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byType(TextField).first, '200');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('200'), findsOneWidget);
    });
  });
}
```

### 2. Database Tests

```dart
group('Database Integration', () {
  testWidgets('should persist transactions', (tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // Act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byType(TextField).first, '100');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    
    // Restart app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('100'), findsOneWidget);
  });
});
```

## Performance Testing

### 1. Widget Performance

```dart
group('Performance Tests', () {
  testWidgets('should render large list efficiently', (tester) async {
    // Arrange
    final transactions = List.generate(1000, (index) => createTestTransaction());
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: TransactionList(transactions: transactions),
        ),
      ),
    );
    
    // Assert
    expect(tester.binding.transientCallbackCount, equals(0));
  });
});
```

### 2. Memory Testing

```dart
group('Memory Tests', () {
  test('should not leak memory', () {
    // Arrange
    final notifier = TransactionNotifier(MockTransactionRepository());
    
    // Act
    notifier.dispose();
    
    // Assert
    expect(notifier.state, isA<TransactionState>());
  });
});
```

## Accessibility Testing

### 1. Screen Reader Tests

```dart
group('Accessibility Tests', () {
  testWidgets('should be accessible to screen readers', (tester) async {
    // Arrange
    final transaction = createTestTransaction();
    
    // Act
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: TransactionTile(transaction: transaction),
        ),
      ),
    );
    
    // Assert
    expect(tester.getSemantics(find.byType(TransactionTile)), 
           matchesSemantics(
             label: 'Coffee \$5.50',
             button: true,
           ));
  });
});
```

### 2. Keyboard Navigation Tests

```dart
group('Keyboard Navigation', () {
  testWidgets('should support keyboard navigation', (tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // Act
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    
    // Assert
    expect(find.byType(TransactionTile).first, findsOneWidget);
  });
});
```

## Test Utilities

### 1. Test Data Factory

```dart
class TestDataFactory {
  static TransactionEntity createTransaction({
    String? id,
    double? amount,
    TransactionType? type,
    String? description,
  }) {
    return TransactionEntity(
      id: id ?? 'test-id-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount ?? 100.0,
      type: type ?? TransactionType.expense,
      description: description ?? 'Test Transaction',
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
      id: id ?? 'test-category-${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Category',
      type: type ?? CategoryKind.expense,
      colorHex: 0xFF2196F3,
      iconCodePoint: Icons.category.codePoint,
      iconFontFamily: Icons.category.fontFamily!,
    );
  }
}
```

### 2. Test Helpers

```dart
class TestHelpers {
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pump();
    await tester.pumpAndSettle();
  }
  
  static Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }
  
  static Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }
}
```

## Test Configuration

### 1. Test Setup

```dart
void main() {
  group('Transaction Tests', () {
    setUpAll(() {
      // Global setup
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    
    setUp(() {
      // Test setup
    });
    
    tearDown(() {
      // Test cleanup
    });
    
    tearDownAll(() {
      // Global cleanup
    });
  });
}
```

### 2. Test Environment

```dart
class TestEnvironment {
  static void setup() {
    // Setup test environment
    Hive.init('test');
  }
  
  static void teardown() {
    // Cleanup test environment
    Hive.close();
  }
}
```

## Continuous Integration

### 1. GitHub Actions

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Run tests
      run: flutter test --coverage
      
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
```

### 2. Test Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html
```

## Best Practices

### 1. Test Organization
- Group related tests together
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Keep tests focused and simple

### 2. Test Data
- Use factories for test data creation
- Keep test data minimal and focused
- Use meaningful test data values
- Avoid hardcoded values

### 3. Test Maintenance
- Update tests when changing code
- Remove obsolete tests
- Keep tests fast and reliable
- Document complex test scenarios

### 4. Test Performance
- Use `pumpAndSettle()` sparingly
- Mock external dependencies
- Avoid unnecessary widget rebuilds
- Use `testWidgets` for UI tests

## Common Issues

### 1. Flaky Tests
- Use `pumpAndSettle()` instead of `pump()`
- Wait for animations to complete
- Use `tester.binding.delayed()` for timing issues

### 2. Memory Leaks
- Dispose controllers and notifiers
- Clear caches in tearDown
- Use `tester.binding.delayed()` for disposal

### 3. State Issues
- Use `ProviderScope` for state management
- Override providers for testing
- Reset state between tests

### 4. Async Issues
- Use `await` for async operations
- Use `pumpAndSettle()` for animations
- Use `tester.binding.delayed()` for delays
