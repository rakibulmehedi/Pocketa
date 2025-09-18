# 🚀 Centralization Migration Guide

This guide shows how to migrate existing features to use the new centralized systems without changing business logic.

## 📋 **Overview of Centralized Systems**

### 1. **BaseEntity** - Common entity structure
### 2. **BaseRepository** - Common CRUD operations
### 3. **BaseProviders** - Common provider patterns
### 4. **BaseFormState & BaseFormNotifier** - Common form handling
### 5. **BaseListWidget** - Common list UI patterns
### 6. **BaseDialog & BaseSheet** - Common dialog/sheet patterns

## 🔄 **Migration Steps**

### Step 1: Update Entities to Extend BaseEntity

**Before:**
```dart
class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  // ... other fields

  @override
  List<Object?> get props => [id, amount, date, createdAt, updatedAt, isDeleted];
}
```

**After:**
```dart
class TransactionEntity extends BaseEntity {
  final double amount;
  final DateTime date;
  // ... other fields (id, createdAt, updatedAt, isDeleted inherited)

  const TransactionEntity({
    required super.id,
    required this.amount,
    required this.date,
    // ... other fields
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  List<Object?> get props => [...super.props, amount, date];
}
```

### Step 2: Update Repositories to Extend BaseRepository

**Before:**
```dart
abstract class TransactionRepository {
  Future<void> upsert(TransactionEntity e);
  Future<void> deleteHard(String id);
  TransactionEntity? getById(String id);
  List<TransactionEntity> all({bool includeDeleted = false});
  // ... other methods
}

class TransactionRepoImpl implements TransactionRepository {
  final Box<Transaction> _box;
  
  @override
  Future<void> upsert(TransactionEntity e) async {
    // Implementation
  }
  
  // ... other implementations
}
```

**After:**
```dart
abstract class TransactionRepository extends BaseRepository<TransactionEntity> {
  // Add transaction-specific methods here
  List<TransactionEntity> byMonth(int year, int month, {String? walletId});
  double totalAmountByType(TransactionType type, int year, int month);
}

class TransactionRepoImpl extends BaseRepositoryImpl<TransactionEntity, Transaction> implements TransactionRepository {
  const TransactionRepoImpl(super.box);

  @override
  TransactionEntity modelToEntity(Transaction model) => model.toEntity();

  @override
  Transaction entityToModel(TransactionEntity entity) => entity.toModel();

  @override
  String get entityIdField => 'id';

  @override
  TransactionEntity _markAsDeleted(TransactionEntity entity) {
    return entity.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  dynamic _getFieldValue(TransactionEntity entity, String fieldName) {
    switch (fieldName) {
      case 'walletId': return entity.walletId;
      case 'type': return entity.type;
      case 'date': return entity.date;
      default: return null;
    }
  }

  // Implement transaction-specific methods
  @override
  List<TransactionEntity> byMonth(int year, int month, {String? walletId}) {
    // Implementation
  }
}
```

### Step 3: Update Providers to Use BaseProviders

**Before:**
```dart
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>(HiveBoxes.transactions),
);

final txRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepoImpl(ref.watch(txBoxProvider)),
);

final allTransactionsProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
  final box = ref.watch(txBoxProvider);
  // Implementation
});
```

**After:**
```dart
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>(HiveBoxes.transactions),
);

final txRepositoryProvider = BaseProviders.repositoryProvider<TransactionRepoImpl, TransactionEntity>(
  (ref) => TransactionRepoImpl(ref.watch(txBoxProvider)),
);

final allTransactionsProvider = BaseProviders.allEntitiesProvider<TransactionEntity>(
  txRepositoryProvider,
);

final transactionByIdProvider = BaseProviders.entityByIdProvider<TransactionEntity>(
  txRepositoryProvider,
);
```

### Step 4: Update Form Handling

**Before:**
```dart
@freezed
class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    @Default(TransactionType.expense) TransactionType type,
    String? categoryId,
    @DateTimeUtcConverter() required DateTime dateUtc,
    @Default(0.0) double amount,
    // ... other fields
  }) = _TransactionFormState;
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  // Implementation with manual validation
}
```

**After:**
```dart
@freezed
class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    @Default(TransactionType.expense) TransactionType type,
    String? categoryId,
    @DateTimeUtcConverter() required DateTime dateUtc,
    @Default(0.0) double amount,
    // ... other fields
    // Inherit base form fields
    @Default(false) bool isLoading,
    @Default(false) bool isValid,
    String? error,
    @Default({}) Map<String, String> fieldErrors,
  }) = _TransactionFormState;
}

class TransactionFormNotifier extends BaseFormNotifier<TransactionFormState> {
  TransactionFormNotifier() : super(TransactionFormState.initial());

  void updateType(TransactionType type) {
    state = state.copyWith(type: type);
    _validateForm();
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
    _validateForm();
  }

  void _validateForm() {
    final validators = {
      'amount': () => validatePositiveNumber(state.amount.toString(), 'Amount'),
      'categoryId': () => validateRequired(state.categoryId, 'Category'),
    };
    validateForm(validators);
  }

  // Implement abstract methods
  @override
  TransactionFormState updateLoadingState(TransactionFormState state, bool loading) {
    return state.copyWith(isLoading: loading);
  }

  // ... other abstract method implementations
}
```

### Step 5: Update List Widgets

**Before:**
```dart
class TransactionListView extends StatelessWidget {
  final List<TransactionEntity> transactions;
  // ... other properties

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

**After:**
```dart
class TransactionListView extends BaseListWidget<TransactionEntity> {
  const TransactionListView({
    super.key,
    required super.items,
    super.itemBuilder,
    super.separatorBuilder,
    super.emptyWidget,
    super.emptyMessage,
    super.isLoading,
    super.hasMore,
    super.onLoadMore,
    super.padding,
    super.scrollController,
    super.shrinkWrap,
    super.physics,
  });

  @override
  Widget _buildDefaultItem(BuildContext context, TransactionEntity item, int index) {
    return TransactionTile(transaction: item);
  }
}
```

### Step 6: Update Dialogs and Sheets

**Before:**
```dart
void showAddTransactionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Transaction'),
      content: TransactionForm(),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Save')),
      ],
    ),
  );
}
```

**After:**
```dart
void showAddTransactionDialog(BuildContext context) {
  DialogService.showForm(
    context,
    title: 'Add Transaction',
    form: TransactionForm(),
    onSave: () {
      // Handle save
      Navigator.of(context).pop();
    },
  );
}

// Or for bottom sheets
void showAddTransactionSheet(BuildContext context) {
  SheetService.showForm(
    context,
    title: 'Add Transaction',
    form: TransactionForm(),
    onSave: () {
      // Handle save
      Navigator.of(context).pop();
    },
  );
}
```

## 🎯 **Benefits After Migration**

### 1. **Reduced Code Duplication**
- Common CRUD operations centralized
- Form validation logic reused
- UI patterns standardized

### 2. **Improved Consistency**
- All entities follow same structure
- All forms have same validation patterns
- All dialogs/sheets have same behavior

### 3. **Better Maintainability**
- Changes to base classes affect all features
- Common bugs fixed in one place
- Easier to add new features

### 4. **Enhanced Performance**
- Optimized list rendering
- Efficient state management
- Better memory usage

### 5. **Developer Experience**
- Less boilerplate code
- Consistent patterns across features
- Easier to onboard new developers

## 📝 **Migration Checklist**

- [ ] Update entities to extend BaseEntity
- [ ] Update repositories to extend BaseRepository
- [ ] Update providers to use BaseProviders
- [ ] Update form states to include base form fields
- [ ] Update form notifiers to extend BaseFormNotifier
- [ ] Update list widgets to extend BaseListWidget
- [ ] Replace custom dialogs with DialogService
- [ ] Replace custom sheets with SheetService
- [ ] Update imports to use centralized systems
- [ ] Test all functionality works as before
- [ ] Remove duplicate code
- [ ] Update documentation

## 🔧 **Common Patterns**

### Entity Pattern
```dart
class FeatureEntity extends BaseEntity {
  // Feature-specific fields
  // Inherit: id, createdAt, updatedAt, isDeleted
}
```

### Repository Pattern
```dart
class FeatureRepository extends BaseRepository<FeatureEntity> {
  // Feature-specific methods
}

class FeatureRepositoryImpl extends BaseRepositoryImpl<FeatureEntity, FeatureModel> implements FeatureRepository {
  // Implement abstract methods
  // Add feature-specific methods
}
```

### Provider Pattern
```dart
final featureRepositoryProvider = BaseProviders.repositoryProvider<FeatureRepositoryImpl, FeatureEntity>(
  (ref) => FeatureRepositoryImpl(ref.watch(featureBoxProvider)),
);

final allFeaturesProvider = BaseProviders.allEntitiesProvider<FeatureEntity>(
  featureRepositoryProvider,
);
```

### Form Pattern
```dart
class FeatureFormNotifier extends BaseFormNotifier<FeatureFormState> {
  // Implement abstract methods
  // Add feature-specific form logic
}
```

### List Pattern
```dart
class FeatureListWidget extends BaseListWidget<FeatureEntity> {
  @override
  Widget _buildDefaultItem(BuildContext context, FeatureEntity item, int index) {
    // Feature-specific item widget
  }
}
```

This migration guide ensures that all features can benefit from the centralized systems while maintaining their existing business logic and functionality.
