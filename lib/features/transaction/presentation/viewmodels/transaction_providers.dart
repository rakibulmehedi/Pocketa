
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/data/repositories/transaction_repo_impl.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:pocketa/features/transaction/domain/usecases/add_transaction.dart';
import 'package:pocketa/features/transaction/domain/usecases/delete_transaction.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_summary.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_transactions.dart';



/// Hive Box Provider (typed)
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>('transactions'),
);

/// Repository as Interface
final txRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepoImpl(ref.watch(txBoxProvider)),
);

/// Use case Providers
final addTxProvider = Provider<AddTransaction>(
  (ref) => AddTransaction(ref.watch(txRepositoryProvider)),
);

final deleteTxProvider = Provider<DeleteTransaction>(
  (ref) => DeleteTransaction(ref.watch(txRepositoryProvider)),
);

final getTxProvider = Provider<GetTransactions>(
  (ref) => GetTransactions(ref.watch(txRepositoryProvider)),
);

// Summery
final monthSummaryProvider = Provider<GetMonthSummary>(
  (ref) => GetMonthSummary(ref.watch(txRepositoryProvider)),
);

/// Reactive list provider (box.listenable → rebuild on change)
final txListenableProvider = Provider<ValueListenable<Box<Transaction>>>(
  (ref) => ref.watch(txBoxProvider).listenable(),
);

/// All Transactions (Entities, sorted desc)
final allTransactionsProvider =
    StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
      final box = ref.watch(txBoxProvider);

      List<TransactionEntity> buildList() {
        final list = box.values.where((t) => !t.isDeleted).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return list.map((m) => m.toEntity()).toList();
      }

      return Stream<List<TransactionEntity>>.multi((controller) {
        // Initial snapshot
        controller.add(buildList());

        // subsequent changes
        final sub = box.watch().listen((_) {
          controller.add(buildList());
        });

        // clean up
        ref.onDispose(sub.cancel);
      });
    });

/// Month-filtered transactions (Entities)
final monthTransactionsProvider =
    Provider.family<
      List<TransactionEntity>,
      ({int y, int m, String? walletId})
    >((ref, args) {
      final repo = ref.watch(txRepositoryProvider);
      return repo.byMonth(args.y, args.m, walletId: args.walletId);
    });

/// Month summaries (optional convenience)
final monthIncomeProvider =
    Provider.family<double, ({int y, int m, String? walletId})>((ref, args) {
      ref.watch(allTransactionsProvider);

      final repo = ref.watch(txRepositoryProvider);
      return repo.totalAmountByType(
        TransactionType.income,
        args.y,
        args.m,
        walletId: args.walletId,
      );
    });

final monthExpenseProvider =
    Provider.family<double, ({int y, int m, String? walletId})>((ref, args) {
      ref.watch(allTransactionsProvider);

      final repo = ref.watch(txRepositoryProvider);
      return repo.totalAmountByType(
        TransactionType.expense,
        args.y,
        args.m,
        walletId: args.walletId,
      );
    });

final monthNetProvider =
    Provider.family<double, ({int y, int m, String? walletId})>((ref, args) {
      ref.watch(allTransactionsProvider);

      final repo = ref.watch(txRepositoryProvider);
      final income = repo.totalAmountByType(
        TransactionType.income,
        args.y,
        args.m,
        walletId: args.walletId,
      );
      final expense = repo.totalAmountByType(
        TransactionType.expense,
        args.y,
        args.m,
        walletId: args.walletId,
      );
      return income - expense;
    });

    
