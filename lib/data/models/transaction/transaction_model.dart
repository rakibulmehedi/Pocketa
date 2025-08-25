import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/core/utils/date_time_utc_converter.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}

@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  groceries,
  @HiveField(1)
  transport,
  @HiveField(2)
  rent,
  @HiveField(3)
  utilities,
  @HiveField(4)
  entertainment,
  @HiveField(5)
  eatingOut,
  @HiveField(6)
  shopping,
  @HiveField(7)
  health,
  @HiveField(8)
  salary,
  @HiveField(9)
  freelance,
  @HiveField(10)
  investment,
  @HiveField(11)
  business,
  @HiveField(12)
  others,
}

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

    @HiveField(2)
    @DateTimeUtcConverter() required DateTime date,

    @HiveField(3) required TransactionType type,
    @HiveField(4) required Category category,
    @HiveField(5) String? note,
    @HiveField(6) required String walletId,
    @HiveField(7) String? targetWalletId,
    @HiveField(8) List<String>? tags,
    @HiveField(9) @Default('BDT') String currency,

    @HiveField(10)
    @DateTimeUtcConverter() DateTime? createdAt,

    @HiveField(11)
    @DateTimeUtcConverter() DateTime? updatedAt,

    @HiveField(12) @Default(false) bool isSynced,
    @HiveField(13) String? attachmentUrl,
    @HiveField(14) @Default(false) bool isDeleted,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}