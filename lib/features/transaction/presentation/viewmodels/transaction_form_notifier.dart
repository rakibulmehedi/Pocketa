import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';

final transactionFormProvider =
    StateNotifierProvider.autoDispose<
      TransactionFormNotifier,
      TransactionFormState
    >((ref) => TransactionFormNotifier());

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  TransactionFormNotifier() : super(TransactionFormState.initial());

  void initializeForm(TransactionEntity? e) {
    if (e == null) return;
    state = state.copyWith(
      type: e.type,
      amount: e.amount,
      categoryId: e.categoryId,
      dateUtc: e.date.toUtc(),
      currency: e.currency,
      tags: e.tags ?? const [],
      walletId: e.walletId,
      targetWalletId: e.targetWalletId,
    );
    _fixTransferConsistency();
  }

  void resetForm() => state = TransactionFormState.initial();

  /// Bulk replace (use cautiously)
  void updateForm(TransactionFormState newState) {
    state = newState.copyWith(dateUtc: newState.dateUtc.toUtc());
    _fixTransferConsistency();
  }

  void loadFromJson(Map<String, dynamic> json) {
    final next = TransactionFormState.fromJson(json);
    state = next.copyWith(dateUtc: next.dateUtc.toUtc());
    _fixTransferConsistency();
  }

  // ------------------------- Type -------------------------
  void setType(TransactionType t) {
    state = state.copyWith(type: t);
    _fixTransferConsistency();
  }

  void toggleIncomeExpense() {
    final next = state.type == TransactionType.expense
        ? TransactionType.income
        : TransactionType.expense;
    setType(next);
  }

  // ------------------------- Category -------------------------

  void setCategoryId(String id) => state = state.copyWith(categoryId: id);
  // void setCategory(Category c) => state = state.copyWith(category: c);
  void clearCategory() => state = state.copyWith(categoryId: null);
  void resetCategory(CategoryKind kind) {
    final first = defaultCategoriesByKind(kind).first;
    state = state.copyWith(categoryId: first.id);
  }

  // ------------------------- Date / Currency -------------------------
  void setDateUtc(DateTime d) => state = state.copyWith(dateUtc: d.toUtc());
  void setCurrency(String c) => state = state.copyWith(currency: c);

  // ------------------------- Amount -------------------------
  void setAmount(double value) {
    final v = value.isNaN || value.isInfinite ? 0.0 : value;
    state = state.copyWith(amount: v.abs());
  }

  // ------------------------- Tags -------------------------
  void addTag(String t) {
    final v = t.trim();
    if (v.isEmpty || state.tags.contains(v)) return;
    state = state.copyWith(tags: [...state.tags, v]);
  }

  void removeTag(String t) =>
      state = state.copyWith(tags: state.tags.where((x) => x != t).toList());

  void clearTags() => state = state.copyWith(tags: const []);
  void setTags(List<String> tags) => state = state.copyWith(
    tags: [
      ...{...tags.map((e) => e.trim())},
    ],
  );

  bool hasTag(String t) => state.tags.contains(t.trim());

  // ------------------------- Wallets -------------------------

  void setWalletId(String id) => state = state.copyWith(walletId: id);

  void setTargetWalletId(String? id) {
    if (state.type == TransactionType.transfer) {
      state = state.copyWith(targetWalletId: id);
    } else {
      state = state.copyWith(targetWalletId: null);
    }
  }

  void resetWallets() =>
      state = state.copyWith(walletId: null, targetWalletId: null);

  // ------------------------- Validation helpers -------------------------
  String? quickValidate() {
    if (state.amount <= 0) return 'Enter a valid amount';
    if (state.walletId == null || state.walletId!.isEmpty) {
      return 'Wallet is required';
    }
    if (state.type == TransactionType.transfer) {
      if (state.targetWalletId == null || state.targetWalletId!.isEmpty) {
        return 'Target wallet is required for transfer';
      }
      if (state.walletId == state.targetWalletId) {
        return 'Source and target wallet cannot be same';
      }
    }
    if (state.categoryId == null || state.categoryId!.isEmpty) {
      return 'Category is required';
    }
    return null; // OK
  }

  // ------------------------- Internal -------------------------
  void _fixTransferConsistency() {
    if (state.type != TransactionType.transfer) {
      state = state.copyWith(targetWalletId: null);
    }
  }
}
