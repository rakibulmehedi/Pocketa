import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/core/utils/date_time_utc_converter.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';

part 'transaction_form_state.freezed.dart';
part 'transaction_form_state.g.dart';

@freezed
class TransactionFormState with _$TransactionFormState {
  const factory TransactionFormState({
    @Default(TransactionType.expense) TransactionType type,
    String? categoryId,

    @DateTimeUtcConverter() required DateTime dateUtc,

    @Default('BDT') String currency,
    @Default(0.0) double amount,
    @Default(<String>[]) List<String> tags,
    String? walletId,
    String? targetWalletId,
  }) = _TransactionFormState;

  factory TransactionFormState.initial() =>
      TransactionFormState(dateUtc: DateTime.now().toUtc());

  factory TransactionFormState.fromEntity(TransactionEntity e) =>
      TransactionFormState(
        type: e.type,
        amount: e.amount,
        dateUtc: e.date.toUtc(),
        currency: e.currency,
        tags: List<String>.from(e.tags ?? const []),
        walletId: e.walletId,
        targetWalletId: e.targetWalletId,
        categoryId: e.categoryId,
      );

  factory TransactionFormState.fromJson(Map<String, dynamic> json) =>
      _$TransactionFormStateFromJson(json);
}
