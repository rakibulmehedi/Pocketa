import 'package:hive/hive.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 10)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final TransactionType type;

  @HiveField(15)
  final String? categoryId;

  @HiveField(5)
  final String walletId;

  @HiveField(6)
  final String? targetWalletId;

  @HiveField(7)
  final String? note;

  @HiveField(8)
  final List<String>? tags;

  @HiveField(9)
  final String currency;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  @HiveField(12)
  final bool isSynced;

  @HiveField(13)
  final String? attachmentUrl;

  @HiveField(14)
  final bool isDeleted;

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
    );
  }

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    date: date,
    type: type,
    categoryId: categoryId,
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

  factory Transaction.fromEntity(TransactionEntity e) => Transaction(
    id: e.id,
    amount: e.amount,
    date: e.date,
    type: e.type,
    categoryId: e.categoryId,
    walletId: e.walletId,
    targetWalletId: e.targetWalletId,
    note: e.note,
    tags: e.tags,
    currency: e.currency,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
    isSynced: e.isSynced,
    attachmentUrl: e.attachmentUrl,
    isDeleted: e.isDeleted,
  );
}

extension TransactionMapper on TransactionEntity {
  Transaction toModel() => Transaction(
    id: id,
    amount: amount,
    date: date,
    type: type,
    categoryId: categoryId,
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

 
