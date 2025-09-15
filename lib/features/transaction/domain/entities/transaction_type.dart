import 'package:hive/hive.dart';
import 'package:pocketa/core/db/hive_type.dart';

part 'transaction_type.g.dart';

/// Transaction type enum - Domain layer
@HiveType(typeId: kTransactionEnumTypeId)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}