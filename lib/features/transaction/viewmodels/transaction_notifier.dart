import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/application/transaction/providers/transaction_provider.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';

class TransactionActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {} // Initialize

  /// Add a transaction to the database and update the UI accordingly (async)
  Future<void> add(TransactionEntity tx, WidgetRef ref) async {
    state = const AsyncLoading();
    try {
      await ref.read(addTxProvider).call(tx);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Delete a transaction from the database and update the UI accordingly (async)
  Future<void> deleteHard(String id, WidgetRef ref) async {
    state = AsyncLoading();
    try {
      await ref.read(deleteTxProvider).call(id, hard: true);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Delete a transaction from the database and update the UI accordingly (async)
  Future<void> deleteSoft(String id, WidgetRef ref) async {
    state = AsyncLoading();
    try {
      await ref.read(deleteTxProvider).call(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Get all transactions from the database and update the UI accordingly (async)
  final transactionActionsProvider =
      AsyncNotifierProvider<TransactionActions, void>(
        () => TransactionActions(),
      );

  /// Computed summery of transactions for a month and wallet (if provided) (income, expense, net) (async)
  final monthNetProvider =
      Provider.family<double, ({int year, int month, String? walletId})>((
        ref,
        args,
      ) {
        final summery = ref.watch(monthSummaryProvider);
        return summery.net(args.year, args.month, walletId: args.walletId);
      });
  final monthIncomeProvider =
      Provider.family<double, ({int year, int month, String? walletId})>((
        ref,
        args,
      ) {
        final summery = ref.watch(monthSummaryProvider);
        return summery.income(args.year, args.month, walletId: args.walletId);
      });
  final monthExpenseProvider =
      Provider.family<double, ({int year, int month, String? walletId})>((
        ref,
        args,
      ) {
        final summery = ref.watch(monthSummaryProvider);
        return summery.expense(args.year, args.month, walletId: args.walletId);
      });
}
