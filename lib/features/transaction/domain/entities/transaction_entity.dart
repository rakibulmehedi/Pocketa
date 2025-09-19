<<<<<<< Updated upstream
import 'package:equatable/equatable.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
=======
import 'package:pocketa/core/data/base_entity.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';
>>>>>>> Stashed changes

class TransactionEntity extends BaseEntityImpl {
  final double amount;
  final DateTime date;
  final TransactionType type;

  final String? categoryId;
  final String walletId;
  final String? targetWalletId;
  final String? note;
  final List<String>? tags;
  final String currency;
  final bool isSynced;
  final String? attachmentUrl;
  final String? transferTo;
  final bool externalTransfer;

  TransactionEntity({
    required super.id,
    required this.amount,
    required this.date,
    required this.type,
    this.categoryId,
    required this.walletId,
    this.targetWalletId,
    this.note,
    this.tags,
    this.currency = 'BDT',
    this.isSynced = false,
    this.attachmentUrl,
    this.transferTo,
    this.externalTransfer = false,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  // Convenience
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;
  double get signedAmount => isExpense ? -amount : amount;
  bool get hasCategory => categoryId != null && categoryId!.isNotEmpty;
  List<String> get safeTags => List.unmodifiable(tags ?? const []);

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
    String? transferTo,
    bool? externalTransfer,
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
      transferTo: transferTo ?? this.transferTo,
      externalTransfer: externalTransfer ?? this.externalTransfer,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    amount,
    date,
    type,
    categoryId,
    walletId,
    targetWalletId,
    note,
    tags?.join('\u0001'),
    currency,
    isSynced,
    attachmentUrl,
    transferTo,
    externalTransfer,
  ];
}
