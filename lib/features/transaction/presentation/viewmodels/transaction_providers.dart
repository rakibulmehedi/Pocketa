import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/features/transaction/data/mappers/transaction_mapper.dart';

import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/data/transaction_repo_impl.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_outflow.dart';

/// Hive box
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>('transactions'),
);

/// Repository
final txRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepoImpl(ref.watch(txBoxProvider)),
);

/// For widgets that only need a listenable (e.g. ValueListenableBuilder)
final txListenableProvider = Provider<ValueListenable<Box<Transaction>>>(
  (ref) => ref.watch(txBoxProvider).listenable(),
);

/// Stream of all (non-deleted) transactions, newest first
final allTransactionsProvider =
    StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
      final box = ref.watch(txBoxProvider);

      List<TransactionEntity> buildList() {
        final list = box.values.where((t) => !t.isDeleted).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return list.map((t) => t.toEntity()).toList();
      }

      return Stream<List<TransactionEntity>>.multi((controller) {
        controller.add(buildList());
        final sub = box.watch().listen((_) => controller.add(buildList()));
        ref.onDispose(sub.cancel);
      });
    });

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
