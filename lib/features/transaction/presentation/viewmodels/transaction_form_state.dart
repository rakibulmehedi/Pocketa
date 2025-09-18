
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/core/utils/date_time_utc_converter.dart';
import 'package:pocketa/core/utils/transaction_type_converter.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';


part 'transaction_form_state.freezed.dart';
part 'transaction_form_state.g.dart';

@freezed
class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    @Default(TransactionType.expense) @TransactionTypeConverter() TransactionType type,
    String? categoryId,
    @DateTimeUtcConverter() required DateTime dateUtc,
    @Default('BDT') String currency,
    @Default(0.0) double amount,
    @Default(<String>[]) List<String> tags,
    String? walletId,
    String? targetWalletId,
    String? transferTo,
    @Default(false) bool externalTransfer,
    String? note,
  }) = _TransactionFormState;

  factory TransactionFormState.initial() =>
      TransactionFormState(dateUtc: DateTime.now().toUtc());

  // Keep this exact signature so json_serializable generates the function:
  factory TransactionFormState.fromJson(Map<String, dynamic> json) =>
      _$TransactionFormStateFromJson(json);
}

// Convenience (pure)
extension TransactionFormStateX on TransactionFormState {
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;

  bool get isInternalTransfer =>
      isTransfer && (targetWalletId != null && targetWalletId!.isNotEmpty);

  bool get isExternalTransfer =>
      isTransfer &&
      (targetWalletId == null || targetWalletId!.isEmpty) &&
      ((transferTo ?? '').trim().isNotEmpty);

  double get signedAmount => isExpense ? -amount : amount;
}
