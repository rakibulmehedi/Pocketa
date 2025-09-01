import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';

import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/month_args.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_providers.dart';

/// -----------------------------
/// FAST HELPERS
/// -----------------------------

/// True if value is effectively zero (guards FP noise)
bool _isZero(double v) => v.abs() < 1e-9;

/// Watch the repo once for every compute provider
TransactionRepository _repo(Ref ref) => ref.watch(txRepositoryProvider);

/// Always re-compute when transactions change
void _tieToTransactions(Ref ref) {
  // If you already expose a tx stream in transaction_providers.dart:
  //  - Make sure it triggers rebuilds when anything changes in Hive box
  ref.watch(allTransactionsProvider);
}

/// -----------------------------
/// MONTH KPIs (exclude transfers)
/// -----------------------------

/// Total income for (y,m)
final monthIncomeRxProvider = Provider.family.autoDispose<double, MonthArgs>((
  ref,
  args,
) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.totalAmountByType(
    TransactionType.income,
    args.y,
    args.m,
    walletId: args.walletId,
  );
});

/// Total expense for (y,m)
final monthExpenseRxProvider = Provider.family.autoDispose<double, MonthArgs>((
  ref,
  args,
) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.totalAmountByType(
    TransactionType.expense,
    args.y,
    args.m,
    walletId: args.walletId,
  );
});

final monthNetRxProvider = Provider.family.autoDispose<double, MonthArgs>((
  ref,
  args,
) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.netForMonth(args.y, args.m, walletId: args.walletId);
});

/// Convenience: is net positive? (for trending icon/color)
final isMonthNetPositiveProvider = Provider.family.autoDispose<bool, MonthArgs>(
  (ref, args) {
    final net = ref.watch(monthNetRxProvider(args));
    return net > 0 && !_isZero(net);
  },
);

/// Transfers total for (y,m) — for display only, NOT in Net
final monthTransfersTotalRxProvider =
    Provider.family.autoDispose<double, MonthArgs>((ref, args) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.totalTransferForMonth(
    args.y,
    args.m,
    walletId: args.walletId,
  );
});

/// -----------------------------
/// WALLET BALANCE (includes transfers)
/// -----------------------------

final walletBalanceRxProvider = Provider.family.autoDispose<double, String>((
  ref,
  walletId,
) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.balanceForWallet(walletId);
});

/// -----------------------------
/// TRENDS / CHART DATA
/// -----------------------------

/// Net worth across all wallets (income − expense across all time; transfers ignored)
final netWorthRxProvider = Provider.autoDispose<double>((ref) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.netAll();
});

/// Monthly net series for charts (older→newer). Ex: last 12 months.
final monthlyNetSeriesRxProvider =
    Provider.family.autoDispose<List<double>, int>((ref, monthsBack) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.monthlyNetSeries(monthsBack);
});

/// Daily cashflow rows for the month (day / income / expense / net)
final dailyCashflowRxProvider = Provider.family
    .autoDispose<List<Map<String, dynamic>>, MonthArgs>((ref, args) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.dailyCashflow(
    DateTime(args.y, args.m, 1),
    walletId: args.walletId,
  );
});

/// Expense totals per category for this month (map: categoryId → amount)
final expenseByCategoryRxProvider =
    Provider.family.autoDispose<Map<String, double>, MonthArgs>((ref, args) {
  _tieToTransactions(ref);
  final repo = _repo(ref);
  return repo.amountByCategory(args.y, args.m, walletId: args.walletId);
});
