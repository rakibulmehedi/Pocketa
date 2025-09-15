import 'package:hive/hive.dart';
import 'package:pocketa/core/data/base_repository.dart';
import 'package:pocketa/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

/// Hive-backed implementation using BaseSoftDeleteRepository.
/// Works directly on Hive models for filtering; converts to Entity only at the edge.
class TransactionRepoImpl extends BaseSoftDeleteRepository<TransactionEntity, Transaction> implements TransactionRepository {
  final Box<Transaction> _box;
  const TransactionRepoImpl(this._box) : super(_box);

  // ------- Date helpers (UTC, [from, to)) ------- //
  DateTime _startOfMonth(int y, int m) => DateTime.utc(y, m, 1);
  DateTime _startOfNextMonth(int y, int m) =>
      (m == 12) ? DateTime.utc(y + 1, 1, 1) : DateTime.utc(y, m + 1, 1);

  // ------- Transfer helpers ------- //
  // Internal = wallet -> wallet (target wallet present)
  // ignore: unused_element
  bool _isInternalTransfer(Transaction t) {
    return t.type == TransactionType.transfer &&
        (t.targetWalletId != null && t.targetWalletId!.isNotEmpty);
  }

  bool _isExternalTransfer(Transaction t) {
    return t.type == TransactionType.transfer &&
        ((t.targetWalletId == null || t.targetWalletId!.isEmpty) &&
            (t.transferTo != null && t.transferTo!.trim().isNotEmpty));
  }

  // ------- Base Repository Implementation ------- //
  @override
  Transaction entityToModel(TransactionEntity entity) {
    return TransactionMapper.entityToModel(entity);
  }

  @override
  TransactionEntity modelToEntity(Transaction model) {
    return TransactionMapper.modelToEntity(model);
  }

  @override
  String getEntityId(TransactionEntity entity) {
    return entity.id;
  }

  @override
  String getModelId(Transaction model) {
    return model.id;
  }

  @override
  bool isModelDeleted(Transaction model) {
    return model.isDeleted;
  }

  @override
  Transaction markModelAsDeleted(Transaction model) {
    model.isDeleted = true;
    model.updatedAt = DateTime.now().toUtc();
    return model;
  }

  @override
  Transaction markModelAsNotDeleted(Transaction model) {
    model.isDeleted = false;
    model.updatedAt = DateTime.now().toUtc();
    return model;
  }

  @override
  Future<void> upsert(TransactionEntity entity) async {
    final now = DateTime.now().toUtc();
    final model = entityToModel(entity);
    model.updatedAt = now;
    if (model.createdAt == null) {
      model.createdAt = now;
    }
    await super.upsert(entity);
  }

  @override
  Future<void> upsertMany(Iterable<TransactionEntity> entities) async {
    final now = DateTime.now().toUtc();
    for (final entity in entities) {
      final model = entityToModel(entity);
      model.updatedAt = now;
      if (model.createdAt == null) {
        model.createdAt = now;
      }
    }
    await super.upsertMany(entities);
  }

  // ------- Iter helpers ------- //
  Iterable<Transaction> _allIter({bool includeDeleted = false}) sync* {
    for (final t in _box.values) {
      if (!includeDeleted && isModelDeleted(t)) continue;
      yield t;
    }
  }

  Iterable<Transaction> _filter({
    DateTime? from, // inclusive
    DateTime? to, // exclusive
    String? walletId,
    String? categoryId,
    TransactionType? type,
    bool includeDeleted = false,
  }) {
    final src = _allIter(includeDeleted: includeDeleted);
    return src.where((t) {
      final afterFrom = from == null || !t.date.isBefore(from);
      final beforeTo = to == null || t.date.isBefore(to);

      // Wallet filter: show txs where source==wallet OR target==wallet
      final matchesWallet =
          walletId == null ||
          t.walletId == walletId ||
          t.targetWalletId == walletId;

      final matchesCat = categoryId == null || t.categoryId == categoryId;
      final matchesType = type == null || t.type == type;

      return afterFrom &&
          beforeTo &&
          matchesWallet &&
          matchesCat &&
          matchesType;
    });
  }

  // ---------------- Mutations ----------------

  // ---------------- Reads ----------------

  @override
  List<TransactionEntity> between(
    DateTime from,
    DateTime to, {
    String? walletId,
    String? categoryId,
    TransactionType? type,
    bool includeDeleted = false,
  }) {
    final list = _filter(
      from: from,
      to: to,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
      includeDeleted: includeDeleted,
    ).toList()..sort((a, b) => b.date.compareTo(a.date));
    return list.map((t) => t.toEntity()).toList();
  }

  @override
  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    return between(
      from,
      to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    );
  }

  // ---------------- Aggregates ----------------
  @override
  double totalAmountByType(
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    return _filter(
      from: from,
      to: to,
      walletId: walletId,
      type: type,
      includeDeleted: includeDeleted,
    ).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  double balanceForWallet(String walletId, {bool includeDeleted = false}) {
    double balance = 0.0;

    for (final t in _filter(
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      switch (t.type) {
        case TransactionType.income:
          if (t.walletId == walletId) balance += t.amount;
          break;
        case TransactionType.expense:
          if (t.walletId == walletId) balance -= t.amount;
          break;
        case TransactionType.transfer:
          // Outflow from source
          if (t.walletId == walletId) balance -= t.amount;
          // Inflow to target (internal only)
          if (t.targetWalletId == walletId) balance += t.amount;
          break;
      }
    }
    return balance;
  }

  @override
  double netForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);

    double income = 0.0;
    double expense = 0.0;

    for (final t in _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else if (t.type == TransactionType.expense) {
        expense += t.amount;
      } else if (_isExternalTransfer(t)) {
        // ✅ Count external transfers as expense in net
        expense += t.amount;
      }
      // internal transfers are ignored (excluded from net)
    }
    return income - expense;
  }

  @override
  double netAll({bool includeDeleted = false}) {
    double income = 0.0, expense = 0.0;
    for (final t in _allIter(includeDeleted: includeDeleted)) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else if (t.type == TransactionType.expense) {
        expense += t.amount;
      } else if (_isExternalTransfer(t)) {
        // external transfer behaves like an expense in net worth
        expense += t.amount;
      }
    }
    return income - expense;
  }

  @override
  List<double> monthlyNetSeries(
    int monthsBack, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final now = DateTime.now().toUtc();
    final list = <double>[];
    for (int i = monthsBack - 1; i >= 0; i--) {
      final d = DateTime.utc(now.year, now.month - i, 1);
      list.add(
        netForMonth(
          d.year,
          d.month,
          walletId: walletId,
          includeDeleted: includeDeleted,
        ),
      );
    }
    return list;
  }

  @override
  List<Map<String, dynamic>> dailyCashflow(
    DateTime month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(month.year, month.month);
    final to = _startOfNextMonth(month.year, month.month);
    final txs = _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    ).toList();

    final daysInMonth = DateTime.utc(month.year, month.month + 1, 0).day;
    final rows = <Map<String, dynamic>>[];

    for (var d = 1; d <= daysInMonth; d++) {
      double income = 0, expense = 0;
      for (final t in txs.where((t) => t.date.day == d)) {
        if (t.type == TransactionType.income) {
          income += t.amount;
        } else if (t.type == TransactionType.expense) {
          expense += t.amount;
        } else if (_isExternalTransfer(t)) {
          // reflect external transfers as outflow in charts
          expense += t.amount;
        }
      }
      rows.add({
        'day': d,
        'income': income,
        'expense': expense,
        'net': income - expense,
      });
    }

    return rows;
  }

  // ---------- Category analytics ----------
  @override
  double totalForCategory(
    String categoryId,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    return _filter(
      from: from,
      to: to,
      walletId: walletId,
      categoryId: categoryId,
      includeDeleted: includeDeleted,
    ).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  double totalForCategoryType(
    String categoryId,
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    return _filter(
      from: from,
      to: to,
      walletId: walletId,
      categoryId: categoryId,
      type: type,
      includeDeleted: includeDeleted,
    ).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Map<String, double> amountByCategory(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    final map = <String, double>{};

    for (final t in _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      // Budget category totals typically consider only explicit expenses.
      // If you want external transfers to contribute here too, add: || _isExternalTransfer(t)
      if (t.type != TransactionType.expense) continue;
      final key = t.categoryId ?? 'uncategorized';
      map[key] = (map[key] ?? 0) + t.amount;
    }
    return map;
  }

  // --------- Transfers ----------
  @override
  double totalTransferForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    return _filter(
      from: from,
      to: to,
      walletId: walletId,
      type: TransactionType.transfer,
      includeDeleted: includeDeleted,
    ).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  double totalTransferForWallet(
    String walletId, {
    bool includeDeleted = false,
  }) {
    return _filter(walletId: walletId, includeDeleted: includeDeleted)
        .where((t) => t.type == TransactionType.transfer)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  double totalTransferBetweenWallets(
    String fromWalletId,
    String toWalletId, {
    bool includeDeleted = false,
  }) {
    return _filter(includeDeleted: includeDeleted)
        .where(
          (t) =>
              t.type == TransactionType.transfer &&
              t.walletId == fromWalletId &&
              t.targetWalletId == toWalletId,
        )
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}
