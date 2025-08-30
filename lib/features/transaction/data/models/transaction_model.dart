import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:pocketa/core/enums/transaction_enums.dart'; // enums from core
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart'; // entity for mapping

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
@HiveType(typeId: 0)
class Transaction with _$Transaction {
  @Assert(
    'type != TransactionType.transfer || targetWalletId != null',
    'targetWalletId is required for transfer',
  )
  @Assert(
    'type == TransactionType.transfer || targetWalletId == null',
    'targetWalletId must be null unless type=transfer',
  )
  const factory Transaction({
    @HiveField(0) required String id,
    @HiveField(1) required double amount,
    @HiveField(2) required DateTime date,
    @HiveField(3) required TransactionType type,
    @HiveField(4) required Category category,
    @HiveField(5) String? note,
    @HiveField(6) required String walletId,
    @HiveField(7) String? targetWalletId,
    @HiveField(8) List<String>? tags,
    @HiveField(9) @Default('BDT') String currency,
    @HiveField(10) DateTime? createdAt,
    @HiveField(11) DateTime? updatedAt,
    @HiveField(12) @Default(false) bool isSynced,
    @HiveField(13) String? attachmentUrl,
    @HiveField(14) @Default(false) bool isDeleted,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

extension TransactionModelMapper on Transaction {
  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    date: date,
    type: type,
    category: category,
    walletId: walletId,
    targetWalletId: targetWalletId,
    note: note,
    tags: tags,
    currency: currency,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isSynced: isSynced,
    attachmentUrl: attachmentUrl,
    isDeleted: isDeleted,
  );
}

extension TransactionEntityMapper on TransactionEntity {
  Transaction toModel() => Transaction(
    id: id,
    amount: amount,
    date: date,
    type: type,
    category: category,
    walletId: walletId,
    targetWalletId: targetWalletId,
    note: note,
    tags: tags,
    currency: currency,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isSynced: isSynced,
    attachmentUrl: attachmentUrl,
    isDeleted: isDeleted,
  );
}
