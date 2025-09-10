import 'dart:async';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/features/transaction/data/mappers/transaction_mapper.dart';

import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/data/transaction_repo_impl.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:pocketa/features/transaction/domain/usecases/get_month_outflow.dart';

/// Hive box
final txBoxProvider = Provider<Box<Transaction>>(
  (ref) => Hive.box<Transaction>(HiveBoxes.transactions),
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

  // Descending by date (newest first)
  int _compare(Transaction a, Transaction b) => b.date.compareTo(a.date);

  // Binary search lowerBound for descending list by date
  int _lowerBoundDesc(List<Transaction> list, DateTime date) {
    var low = 0;
    var high = list.length;
    while (low < high) {
      final mid = (low + high) >> 1;
      // If mid item is newer, insert after it
      if (list[mid].date.compareTo(date) > 0) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  return Stream<List<TransactionEntity>>.multi((controller) {
    // Build initial active map and sorted list
    final byKey = <dynamic, Transaction>{};
    final sorted = <Transaction>[];
    for (final k in box.keys) {
      final t = box.get(k);
      if (t != null && !t.isDeleted) {
        byKey[k] = t;
        sorted.add(t);
      }
    }
    sorted.sort(_compare);

    void emit() {
      // Emit a fresh list instance of entities
      controller.add(List<TransactionEntity>.unmodifiable(
        sorted.map((t) => t.toEntity()),
      ));
    }

    emit();

    Timer? debounce;
    void scheduleEmit() {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 16), emit);
    }

    int _indexById(String id) =>
        sorted.indexWhere((x) => x.id == id);

    final sub = box.watch().listen((event) {
      try {
        if (event.deleted == true) {
          final old = byKey.remove(event.key);
          if (old != null) {
            final i = _indexById(old.id);
            if (i >= 0) sorted.removeAt(i);
            scheduleEmit();
          }
          return;
        }

        final nv = event.value as Transaction?;
        if (nv == null) return;

        if (nv.isDeleted) {
          final old = byKey.remove(event.key);
          if (old != null) {
            final i = _indexById(old.id);
            if (i >= 0) sorted.removeAt(i);
            scheduleEmit();
          }
          return;
        }

        final prev = byKey[event.key];
        byKey[event.key] = nv;

        if (prev == null) {
          // New insert
          final idx = _lowerBoundDesc(sorted, nv.date);
          sorted.insert(idx, nv);
          scheduleEmit();
          return;
        }

        // Update
        final sameDate = prev.date.isAtSameMomentAs(nv.date);
        final i = _indexById(prev.id);
        if (i >= 0) {
          if (sameDate) {
            // In-place replace keeps position stable
            sorted[i] = nv;
          } else {
            sorted.removeAt(i);
            final idx = _lowerBoundDesc(sorted, nv.date);
            sorted.insert(idx, nv);
          }
          scheduleEmit();
        } else {
          // Not found (shouldn't happen) — fallback to insert
          final idx = _lowerBoundDesc(sorted, nv.date);
          sorted.insert(idx, nv);
          scheduleEmit();
        }
      } catch (_) {
        // On any inconsistency, fall back to a full rebuild
        final list = box.values.where((t) => !t.isDeleted).toList()
          ..sort(_compare);
        byKey
          ..clear()
          ..addEntries(list.map((t) => MapEntry(t.key, t)));
        sorted
          ..clear()
          ..addAll(list);
        scheduleEmit();
      }
    });

    ref.onDispose(() {
      debounce?.cancel();
      sub.cancel();
    });
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
