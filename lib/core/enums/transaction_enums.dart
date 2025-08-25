import 'package:hive/hive.dart';

part 'transaction_enums.g.dart';

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
