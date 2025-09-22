import 'package:flow/features/transaction/data/models/transaction_model.dart';
import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';

extension TransactionMapper on Transaction {
  TransactionEntity toEntity() {
    return TransactionEntity(
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
      transferTo: transferTo,
    );
  }
}

extension TransactionEntityMapper on TransactionEntity {
  Transaction toModel() {
    return Transaction(
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
      transferTo: transferTo,
    );
  }
}
