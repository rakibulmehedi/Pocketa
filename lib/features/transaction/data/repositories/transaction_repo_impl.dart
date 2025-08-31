import 'package:hive/hive.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepoImpl implements TransactionRepository {
  final Box<Transaction> _box; // Hive model class = Transaction (your DTO)
  const TransactionRepoImpl(this._box);

  // -------Helpers------- //
  DateTime _startOfMonth(int year, int month) => DateTime.utc(year, month, 1);
  DateTime _startOfNextMonth(int year, int month) => month == 12
      ? DateTime.utc(year + 1, 1, 1)
      : DateTime.utc(year, month + 1, 1);

  Iterable<Transaction> _allIter({bool includeDeleted = false}) sync* {
    for (final t in _box.values) {
      if (!includeDeleted && t.isDeleted) continue;
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
      final sameWallet =
          walletId == null ||
          t.walletId == walletId ||
          t.targetWalletId == walletId;
      final sameCat = categoryId == null || t.categoryId == categoryId;
      final sameType = type == null || t.type == type;
      return afterFrom && beforeTo && sameWallet && sameCat && sameType;
    });
  }

  // ---------------- CRUD ----------------
  @override
  Future<void> upsert(TransactionEntity e) async {
    await _box.put(e.id, e.toModel());
  }

  @override
  TransactionEntity? get(String id) => _box.get(id)?.toEntity();

  @override
  Future<void> deleteHard(String id) async => _box.delete(id);

  @override
  Future<void> deleteSoft(String id) async {
    final t = _box.get(id);
    if (t != null) {
      await _box.put(id, t.copyWith(isDeleted: true));
    }
  }

  // ---------------- Queries ----------------
  @override
  List<TransactionEntity> all({bool includeDeleted = false}) {
    final list = _allIter(includeDeleted: includeDeleted).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
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
    final list = _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    ).toList()..sort((a, b) => b.date.compareTo(a.date));
    return list.map((t) => t.toEntity()).toList();
  }

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
          if (t.walletId == walletId) balance -= t.amount; // out
          if (t.targetWalletId == walletId) balance += t.amount; // in
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
    double income = 0.0, expense = 0.0;

    for (final t in _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      if (t.type == TransactionType.income) income += t.amount;
      if (t.type == TransactionType.expense) expense += t.amount;
    }
    return income - expense;
  }

  // ---------- Category analytics (by id) ----------
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

  // --------- Transfers ----------
  @override
  double totalTransferForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) => totalAmountByType(
    TransactionType.transfer,
    year,
    month,
    walletId: walletId,
    includeDeleted: includeDeleted,
  );

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
