
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> upsert(TransactionEntity e);
  TransactionEntity? get(String id);
  Future<void> deleteHard(String id);
  Future<void> deleteSoft(String id);

  List<TransactionEntity> all({bool includeDeleted = false});
  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  double totalAmountByType(
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  double balanceForWallet(String walletId, {bool includeDeleted = false});
  double netForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // categoryId-based
  double totalForCategory(
    String categoryId,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  double totalForCategoryType(
    String categoryId,
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // transfers
  double totalTransferForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double totalTransferForWallet(String walletId, {bool includeDeleted = false});
  double totalTransferBetweenWallets(
    String fromWalletId,
    String toWalletId, {
    bool includeDeleted = false,
  });
}
