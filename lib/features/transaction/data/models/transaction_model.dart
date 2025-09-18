import 'package:hive/hive.dart';
import 'package:pocketa/core/db/hive_type.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';

// Re-export TransactionType for convenience
export 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: kTransactionModelTypeId)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  double amount;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  String? categoryId;
  @HiveField(5)
  String walletId;
  @HiveField(6)
  String? targetWalletId;
  @HiveField(7)
  String? note;
  @HiveField(8)
  List<String>? tags;
  @HiveField(9)
  String currency;
  @HiveField(10)
  DateTime? createdAt;
  @HiveField(11)
  DateTime? updatedAt;
  @HiveField(12)
  bool isSynced;
  @HiveField(13)
  String? attachmentUrl;
  @HiveField(14)
  bool isDeleted;
  @HiveField(15)
  String? transferTo;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    this.categoryId,
    required this.walletId,
    this.targetWalletId,
    this.note,
    this.tags,
    this.currency = 'BDT',
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
    this.attachmentUrl,
    this.isDeleted = false,
    this.transferTo,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? categoryId,
    String? walletId,
    String? targetWalletId,
    String? note,
    List<String>? tags,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? attachmentUrl,
    bool? isDeleted,
    String? transferTo,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      targetWalletId: targetWalletId ?? this.targetWalletId,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      isDeleted: isDeleted ?? this.isDeleted,
      transferTo: transferTo ?? this.transferTo,
    );
  }
}
