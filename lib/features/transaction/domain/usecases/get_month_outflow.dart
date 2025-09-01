import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

/// Returns total outflow (expenses + external transfers) for a month.
///
/// - Expenses are straightforward (sum of expense transactions).
/// - External transfers are “money leaving me”: transfer tx with NO target wallet
///   but a non-empty `transferTo` (someone/account).
/// - Internal transfers (wallet -> wallet) are excluded.

class GetMonthOutflow {
  final TransactionRepository repo;
  const GetMonthOutflow(this.repo);

  double call(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    // 1) Pure expenses
    final double expense = repo.totalAmountByType(
      TransactionType.expense,
      year,
      month,
      walletId: walletId,
      includeDeleted: includeDeleted,
    );

    // 2) External transfers (wallet -> someone/account)
    final allTxs = repo.byMonth(
      year,
      month,
      walletId: walletId,
      includeDeleted: includeDeleted,
    );

    final double externalTransfers = allTxs
        .where(
          (t) =>
              t.type == TransactionType.transfer &&
              // external if there's no target wallet but there IS a transferTo
              (t.targetWalletId == null || t.targetWalletId!.isEmpty) &&
              (t.transferTo != null && t.transferTo!.trim().isNotEmpty),
        )
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    // 3) Total outflow
    return expense + externalTransfers;
  }
}
