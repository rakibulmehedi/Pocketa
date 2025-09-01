import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';

/// Repository contract for Transactions.
/// All date range filters use [from, to) i.e. inclusive start, exclusive end.
abstract class TransactionRepository {
  // Mutations
  Future<void> upsert(TransactionEntity e);
  Future<void> upsertMany(Iterable<TransactionEntity> list);
  Future<void> deleteHard(String id);
  Future<void> deleteSoft(String id);

  // Reads
  TransactionEntity? getById(String id);
  List<TransactionEntity> all({bool includeDeleted = false});
  List<TransactionEntity> between(
    DateTime from,
    DateTime to, {
    String? walletId,
    String? categoryId,
    TransactionType? type,
    bool includeDeleted = false,
  });
  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // Aggregates
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
  double netAll({bool includeDeleted = false});
  List<double> monthlyNetSeries(
    int monthsBack, {
    String? walletId,
    bool includeDeleted = false,
  });
  List<Map<String, dynamic>> dailyCashflow(
    DateTime month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // Category analytics
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
  Map<String, double> amountByCategory(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  });

  // Transfers
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
