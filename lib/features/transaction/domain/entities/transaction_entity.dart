
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';

class TransactionEntity {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;

  /// New: user-defined category id (nullable for now)
  final String? categoryId;

  final String walletId;
  final String? targetWalletId;
  final String? note;
  final List<String>? tags;
  final String currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final String? attachmentUrl;
  final bool isDeleted;

  const TransactionEntity({
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

  TransactionEntity copyWith({
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
    return TransactionEntity(
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
}
