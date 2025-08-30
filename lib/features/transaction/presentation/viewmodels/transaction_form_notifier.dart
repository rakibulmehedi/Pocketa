import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/viewmodels.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/features/transaction/domain/domain.dart';

final transactionFormProvider =
    StateNotifierProvider.autoDispose<
      TransactionFormNotifier,
      TransactionFormState
    >((ref) => TransactionFormNotifier());
class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  TransactionFormNotifier() : super(TransactionFormState.initial());

  void initializeForm(TransactionEntity? e) {
    if (e == null) return;
    state = TransactionFormState.fromEntity(e);
  }

  // Type
  void setType(TransactionType t) => state = state.copyWith(type: t);
  void toggleIncomeExpense() {
    final newType = state.type == TransactionType.expense
        ? TransactionType.income
        : TransactionType.expense;
    state = state.copyWith(type: newType);
  }

  // Category
  void setCategory(Category c) => state = state.copyWith(category: c);
  void resetCategory() => state = state.copyWith(category: Category.eatingOut);

  // Date
  void setDateUtc(DateTime d) => state = state.copyWith(dateUtc: d.toUtc());

  // Currency
  void setCurrency(String c) => state = state.copyWith(currency: c);

  // Tags
  void addTag(String t) {
    final v = t.trim();
    if (v.isEmpty || state.tags.contains(v)) return;
    state = state.copyWith(tags: [...state.tags, v]);
  }

  void removeTag(String t) {
    state = state.copyWith(tags: state.tags.where((x) => x != t).toList());
  }

  void clearTags() => state = state.copyWith(tags: []);
  void setTags(List<String> tags) => state = state.copyWith(tags: tags);
  bool hasTag(String t) => state.tags.contains(t);

  // Bulk ops
  void updateForm(TransactionFormState newState) => state = newState;
  void resetForm() => state = TransactionFormState.initial();
  void loadFromJson(Map<String, dynamic> json) =>
      state = TransactionFormState.fromJson(json);
}
