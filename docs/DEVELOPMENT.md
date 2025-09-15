# Pocketa Development Guide

## Getting Started

### Prerequisites
- Flutter 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code with Flutter extensions
- Git
- Node.js (for code generation tools)

### Development Environment Setup

1. **Install Flutter**
   ```bash
   # Download Flutter SDK
   git clone https://github.com/flutter/flutter.git -b stable
   
   # Add to PATH
   export PATH="$PATH:`pwd`/flutter/bin"
   
   # Verify installation
   flutter doctor
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                           # Core utilities and shared functionality
│   ├── responsive/                 # Responsive design system
│   │   ├── responsive.dart         # Main responsive utilities
│   │   └── app_size.dart          # Size definitions
│   ├── theme/                      # Design system
│   │   ├── app_theme.dart         # Theme configuration
│   │   ├── app_colors.dart        # Color definitions
│   │   └── text_styles.dart       # Typography system
│   ├── utils/                      # Utility functions
│   │   ├── currency_utils.dart    # Currency handling
│   │   └── transaction_utils.dart # Transaction utilities
│   ├── constants/                  # App constants
│   │   └── default_categories.dart
│   └── db/                         # Database configuration
│       └── hive_bootstrap.dart
├── features/                       # Feature modules
│   ├── onboarding/                 # Onboarding flow
│   │   ├── domain/                # Business logic
│   │   ├── data/                  # Data layer
│   │   └── presentation/          # UI layer
│   ├── dashboard/                 # Main dashboard
│   ├── transaction/               # Transaction management
│   ├── categories/                # Category management
│   └── wallets/                   # Wallet management
├── shared/                        # Shared components
│   ├── widgets/                   # Reusable UI components
│   └── services/                  # Shared services
└── l10n/                          # Internationalization
    ├── app_en.arb                # English translations
    └── app_bn.arb                # Bengali translations
```

## Coding Standards

### 1. Naming Conventions

#### Files and Directories
- Use snake_case for file names: `transaction_tile.dart`
- Use snake_case for directory names: `transaction_form/`
- Use descriptive names: `add_edit_transaction_screen.dart`

#### Classes and Variables
- Use PascalCase for classes: `TransactionEntity`
- Use camelCase for variables: `transactionAmount`
- Use snake_case for constants: `DEFAULT_CURRENCY`

#### Widgets
- Use PascalCase for widget classes: `TransactionTile`
- Use descriptive names: `EnhancedFloatingActionButton`
- Prefix private widgets with underscore: `_TransactionFormField`

### 2. Code Organization

#### Import Order
```dart
// 1. Dart core libraries
import 'dart:async';
import 'dart:math';

// 2. Flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Internal packages
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

// 5. Relative imports
import 'transaction_entity.dart';
```

#### Class Structure
```dart
class TransactionTile extends ConsumerWidget {
  // 1. Static constants
  static const double _defaultHeight = 60.0;
  
  // 2. Instance variables
  final TransactionEntity transaction;
  final VoidCallback? onTap;
  
  // 3. Constructor
  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });
  
  // 4. Override methods
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Implementation
  }
  
  // 5. Private methods
  Widget _buildAmountText(BuildContext context) {
    // Implementation
  }
}
```

### 3. Widget Guidelines

#### Stateless vs Stateful
- Use `StatelessWidget` when possible
- Use `StatefulWidget` only when state management is needed
- Prefer `ConsumerWidget` for Riverpod integration

#### Widget Composition
```dart
// Good: Composed widgets
class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTransactionList(),
        _buildFooter(),
      ],
    );
  }
  
  Widget _buildHeader() => TransactionListHeader();
  Widget _buildTransactionList() => TransactionListView();
  Widget _buildFooter() => TransactionListFooter();
}

// Bad: Monolithic widget
class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 200+ lines of header code
        // 300+ lines of list code
        // 100+ lines of footer code
      ],
    );
  }
}
```

#### Responsive Design
```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return Container(
      padding: layout.pageGutter,
      child: Column(
        children: [
          Text(
            'Title',
            style: AppTextStyles.responsiveTitle(context),
          ),
          SizedBox(height: layout.spaceM),
          // Content
        ],
      ),
    );
  }
}
```

### 4. State Management

#### Riverpod Providers
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

// Computed provider
final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionNotifierProvider).transactions;
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});
```

#### State Classes
```dart
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default([]) List<TransactionEntity> transactions,
    @Default(false) bool isLoading,
    String? error,
  }) = _TransactionState;
}
```

#### Notifier Classes
```dart
class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier(this._repository) : super(const TransactionState());
  
  final TransactionRepository _repository;
  
  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);
    try {
      final transactions = await _repository.getTransactions();
      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
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

### 5. Error Handling

#### Failure Classes
```dart
@freezed
class TransactionFailure with _$TransactionFailure {
  const factory TransactionFailure.network(String message) = NetworkFailure;
  const factory TransactionFailure.storage(String message) = StorageFailure;
  const factory TransactionFailure.validation(String message) = ValidationFailure;
}
```

#### Error Handling in Widgets
```dart
class TransactionList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionNotifierProvider);
    
    return state.when(
      data: (transactions) => _buildTransactionList(transactions),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }
  
  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error, size: 48),
          SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () => ref.refresh(transactionNotifierProvider),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

## Testing

### 1. Unit Tests

#### Test Structure
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
    });
  });
}
```

#### Mock Classes
```dart
class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockTransactionNotifier extends Mock implements TransactionNotifier {}
```

### 2. Widget Tests

#### Test Structure
```dart
void main() {
  group('TransactionTile', () {
    testWidgets('should display transaction information', (tester) async {
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
      expect(find.text(transaction.description), findsOneWidget);
      expect(find.text('\$${transaction.amount}'), findsOneWidget);
    });
  });
}
```

### 3. Integration Tests

#### Test Structure
```dart
void main() {
  group('Transaction Flow', () {
    testWidgets('should add new transaction', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      
      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byType(TextField).first, '100');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('100'), findsOneWidget);
    });
  });
}
```

## Performance Optimization

### 1. Widget Optimization

#### Use const Constructors
```dart
// Good
const TransactionTile({
  super.key,
  required this.transaction,
});

// Bad
TransactionTile({
  super.key,
  required this.transaction,
});
```

#### Implement RepaintBoundary
```dart
class HeavyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        // Heavy rendering logic
      ),
    );
  }
}
```

#### Use ListView.builder
```dart
class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }
}
```

### 2. State Management Optimization

#### Use select for Specific Fields
```dart
class TransactionList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuild when transactions change, not when isLoading changes
    final transactions = ref.watch(
      transactionNotifierProvider.select((state) => state.transactions),
    );
    
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }
}
```

#### Implement Proper Disposal
```dart
class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier(this._repository) : super(const TransactionState());
  
  final TransactionRepository _repository;
  StreamSubscription? _subscription;
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

### 3. Memory Management

#### Dispose Controllers
```dart
class TransactionForm extends StatefulWidget {
  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late TextEditingController _amountController;
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
```

#### Clear Caches
```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final List<TransactionEntity> _cache = [];
  
  @override
  Future<void> clearCache() async {
    _cache.clear();
  }
}
```

## Debugging

### 1. Flutter DevTools
- Use Flutter Inspector for widget tree debugging
- Use Performance view for frame rate analysis
- Use Memory view for memory leak detection

### 2. Logging
```dart
import 'package:flutter/foundation.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  Future<void> loadTransactions() async {
    if (kDebugMode) {
      print('Loading transactions...');
    }
    
    try {
      final transactions = await _repository.getTransactions();
      state = state.copyWith(transactions: transactions);
      
      if (kDebugMode) {
        print('Loaded ${transactions.length} transactions');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading transactions: $e');
      }
    }
  }
}
```

### 3. Error Reporting
```dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
    } else {
      // Report to crash analytics
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
```

## Code Generation

### 1. Freezed
```dart
@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required TransactionType type,
    required DateTime date,
  }) = _TransactionEntity;
  
  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
```

### 2. JSON Serialization
```dart
@JsonSerializable()
class TransactionModel {
  final String id;
  final double amount;
  final String type;
  final DateTime date;
  
  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
  });
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
```

### 3. Hive Adapters
```dart
@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  double amount;
  
  @HiveField(2)
  String type;
  
  @HiveField(3)
  DateTime date;
  
  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
  });
}
```

## Deployment

### 1. Build Configuration
```yaml
# pubspec.yaml
version: 1.0.0+1

# android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 2. Release Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### 3. Code Signing
```bash
# Android
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# iOS
# Configure in Xcode
```

## Best Practices

### 1. Code Quality
- Write self-documenting code
- Use meaningful variable names
- Keep functions small and focused
- Add comments for complex logic
- Follow SOLID principles

### 2. Performance
- Profile before optimizing
- Use const constructors
- Implement proper disposal
- Optimize list rendering
- Monitor memory usage

### 3. Testing
- Write tests for business logic
- Test edge cases
- Use mocks for external dependencies
- Maintain high test coverage
- Test on different devices

### 4. Security
- Validate all inputs
- Encrypt sensitive data
- Use secure storage
- Implement proper authentication
- Follow OWASP guidelines
