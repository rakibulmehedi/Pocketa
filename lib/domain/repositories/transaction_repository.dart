import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> upsert(TransactionEntity transaction);
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
  double netForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double balanceForWallet(String walletId, {bool includeDeleted = false});

  double totalForCategory(
    Category category,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });
  double totalForCategoryType(
    Category category,
    TransactionType type,
    int year,
    int month, {
    String walletId,
    bool includeDeleted = false,
  });

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
