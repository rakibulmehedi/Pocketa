// lib/features/transaction/presentation/viewmodels/transaction_usecases_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_providers.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

// ---- Usecases (IMPORT ALL) ----
import 'package:pocketa/features/transaction/domain/usecases/upsert_transaction.dart';
import 'package:pocketa/features/transaction/domain/usecases/upsert_many_transactions.dart';
import 'package:pocketa/features/transaction/domain/usecases/delete_transaction_hard.dart';
import 'package:pocketa/features/transaction/domain/usecases/delete_transaction_soft.dart';

import 'package:pocketa/features/transaction/domain/usecases/get_transaction_by_id.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_all_transactions.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_transactions_between.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_transactions_by_month.dart';

import 'package:pocketa/features/transaction/domain/usecases/get_month_income.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_expense.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_net.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_net_worth.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_monthly_net_series.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_daily_cashflow.dart';

import 'package:pocketa/features/transaction/domain/usecases/get_category_total_in_month.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_category_type_total_in_month.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_amount_by_category.dart';

import 'package:pocketa/features/transaction/domain/usecases/get_transfer_total_in_month.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_wallet_transfer_total.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_transfer_between_wallets.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_wallet_balance.dart';

// Helper: in providers files use `Ref` (NOT WidgetRef)
TransactionRepository _repo(Ref ref) => ref.watch(txRepositoryProvider);

// ----------------- Mutations -----------------
final upsertTxUCProvider = Provider<UpsertTransaction>(
  (ref) => UpsertTransaction(_repo(ref)),
);

final upsertManyTxUCProvider = Provider<UpsertManyTransactions>(
  (ref) => UpsertManyTransactions(_repo(ref)),
);

final deleteTxHardUCProvider = Provider<DeleteTransactionHard>(
  (ref) => DeleteTransactionHard(_repo(ref)),
);

final deleteTxSoftUCProvider = Provider<DeleteTransactionSoft>(
  (ref) => DeleteTransactionSoft(_repo(ref)),
);

// ----------------- Reads -----------------
final getTxByIdUCProvider = Provider<GetTransactionById>(
  (ref) => GetTransactionById(_repo(ref)),
);

final getAllTxUCProvider = Provider<GetAllTransactions>(
  (ref) => GetAllTransactions(_repo(ref)),
);

final getTxBetweenUCProvider = Provider<GetTransactionsBetween>(
  (ref) => GetTransactionsBetween(_repo(ref)),
);

final getTxByMonthUCProvider = Provider<GetTransactionsByMonth>(
  (ref) => GetTransactionsByMonth(_repo(ref)),
);

// ----------------- Aggregates -----------------
final getMonthIncomeUCProvider = Provider<GetMonthIncome>(
  (ref) => GetMonthIncome(_repo(ref)),
);

final getMonthExpenseUCProvider = Provider<GetMonthExpense>(
  (ref) => GetMonthExpense(_repo(ref)),
);

final getMonthNetUCProvider = Provider<GetMonthNet>(
  (ref) => GetMonthNet(_repo(ref)),
);

final getNetWorthUCProvider = Provider<GetNetWorth>(
  (ref) => GetNetWorth(_repo(ref)),
);

final getMonthlyNetSeriesUCProvider = Provider<GetMonthlyNetSeries>(
  (ref) => GetMonthlyNetSeries(_repo(ref)),
);

final getDailyCashflowUCProvider = Provider<GetDailyCashflow>(
  (ref) => GetDailyCashflow(_repo(ref)),
);

// ----------------- Category analytics -----------------
final getCategoryTotalInMonthUCProvider = Provider<GetCategoryTotalInMonth>(
  (ref) => GetCategoryTotalInMonth(_repo(ref)),
);

final getCategoryTypeTotalInMonthUCProvider =
    Provider<GetCategoryTypeTotalInMonth>(
      (ref) => GetCategoryTypeTotalInMonth(_repo(ref)),
    );

final getAmountByCategoryUCProvider = Provider<GetAmountByCategory>(
  (ref) => GetAmountByCategory(_repo(ref)),
);

// ----------------- Transfers -----------------
final getTransferTotalInMonthUCProvider = Provider<GetTransferTotalInMonth>(
  (ref) => GetTransferTotalInMonth(_repo(ref)),
);

final getWalletTransferTotalUCProvider = Provider<GetWalletTransferTotal>(
  (ref) => GetWalletTransferTotal(_repo(ref)),
);

final getTransferBetweenWalletsUCProvider = Provider<GetTransferBetweenWallets>(
  (ref) => GetTransferBetweenWallets(_repo(ref)),
);

final getWalletBalanceUCProvider = Provider<GetWalletBalance>(
  (ref) => GetWalletBalance(_repo(ref)),
);
