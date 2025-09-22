
import 'package:flow/features/transaction/domain/entities/transaction_type.dart';

class TransactionFormState {
  final TransactionType type;
  final String? categoryId;
  final DateTime dateUtc;
  final String currency;
  final double amount;
  final List<String> tags;
  final String? walletId;
  final String? targetWalletId;
  final String? transferTo;
  final bool externalTransfer;
  final String? note;
  // Base form fields
  final bool isLoading;
  final bool isValid;
  final String? error;
  final Map<String, String> fieldErrors;

  const TransactionFormState({
    this.type = TransactionType.expense,
    this.categoryId,
    required this.dateUtc,
    this.currency = 'BDT',
    this.amount = 0.0,
    this.tags = const <String>[],
    this.walletId,
    this.targetWalletId,
    this.transferTo,
    this.externalTransfer = false,
    this.note,
    this.isLoading = false,
    this.isValid = false,
    this.error,
    this.fieldErrors = const {},
  });

  factory TransactionFormState.initial() =>
      TransactionFormState(dateUtc: DateTime.now().toUtc());

  TransactionFormState copyWith({
    TransactionType? type,
    String? categoryId,
    DateTime? dateUtc,
    String? currency,
    double? amount,
    List<String>? tags,
    String? walletId,
    String? targetWalletId,
    String? transferTo,
    bool? externalTransfer,
    String? note,
    bool? isLoading,
    bool? isValid,
    String? error,
    Map<String, String>? fieldErrors,
  }) {
    return TransactionFormState(
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      dateUtc: dateUtc ?? this.dateUtc,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      tags: tags ?? this.tags,
      walletId: walletId ?? this.walletId,
      targetWalletId: targetWalletId ?? this.targetWalletId,
      transferTo: transferTo ?? this.transferTo,
      externalTransfer: externalTransfer ?? this.externalTransfer,
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionFormState &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.dateUtc == dateUtc &&
        other.currency == currency &&
        other.amount == amount &&
        other.tags == tags &&
        other.walletId == walletId &&
        other.targetWalletId == targetWalletId &&
        other.transferTo == transferTo &&
        other.externalTransfer == externalTransfer &&
        other.note == note &&
        other.isLoading == isLoading &&
        other.isValid == isValid &&
        other.error == error &&
        other.fieldErrors == fieldErrors;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        categoryId.hashCode ^
        dateUtc.hashCode ^
        currency.hashCode ^
        amount.hashCode ^
        tags.hashCode ^
        walletId.hashCode ^
        targetWalletId.hashCode ^
        transferTo.hashCode ^
        externalTransfer.hashCode ^
        note.hashCode ^
        isLoading.hashCode ^
        isValid.hashCode ^
        error.hashCode ^
        fieldErrors.hashCode;
  }
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
