import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/core.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/data/transaction_repo_impl.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_outflow.dart';

/// Hive box
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>(HiveBoxes.transactions),
);

/// Repository using centralized BaseProviders
final txRepositoryProvider = BaseProviders.repositoryProvider<TransactionRepoImpl, TransactionEntity>(
  (ref) => TransactionRepoImpl(ref.watch(txBoxProvider)),
);

/// For widgets that only need a listenable (e.g. ValueListenableBuilder)
final txListenableProvider = Provider<ValueListenable<Box<Transaction>>>(
  (ref) => ref.watch(txBoxProvider).listenable(),
);

/// Stream of all (non-deleted) transactions using centralized provider
final allTransactionsProvider = BaseProviders.allEntitiesProvider<TransactionEntity>(
  txRepositoryProvider,
);

/// Use case provider
final getMonthOutflowProvider = Provider<GetMonthOutflow>(
  (ref) => GetMonthOutflow(ref.watch(txRepositoryProvider)),
);

/// Reactive outflow provider (expenses + external transfers)
final monthOutflowProvider =
    Provider.family<double, ({int y, int m, String? walletId})>((ref, args) {
  ref.watch(allTransactionsProvider); // rebuild on changes
  final usecase = ref.watch(getMonthOutflowProvider);
  return usecase(args.y, args.m, walletId: args.walletId);
});
