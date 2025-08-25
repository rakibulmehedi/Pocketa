import 'package:hive/hive.dart';
import 'package:pocketa/data/models/transaction/transaction_model.dart';

class TransactionRepo {
  final Box<Transaction> _box;
  const TransactionRepo(this._box);

  // -------Helpers------- //
  DateTime _startOfMonth(int year, int month) => DateTime.utc(year, month, 1);
  DateTime _startOfNextMonth(int year, int month) => month == 12
      ? DateTime.utc(year + 1, 1, 1)
      : DateTime.utc(year, month + 1, 1);

  Iterable<Transaction> _allIter({bool includeDeleted = false}) sync* {
    for (final transaction in _box.values) {
      if (!includeDeleted && transaction.isDeleted) continue;
      yield transaction;
    }
  }

  Iterable<Transaction> _filter({
    DateTime? from, // inclusive
    DateTime? to, // exclusive
    String? walletId, // filter by wallet
    Category? category, // filter by category
    TransactionType? type, // filter by type
    bool includeDeleted = false, // include deleted transactions
  }) {
    final src = _allIter(includeDeleted: includeDeleted); // source iterable
    return src.where((t) {
      final afterFrom = from == null || !t.date.isBefore(from);
      final beforeTo = to == null || t.date.isBefore(to);
      final sameWallet =
          walletId == null ||
          t.walletId == walletId ||
          t.targetWalletId == walletId;
      final sameCategory = category == null || t.category == category;
      final sameType = type == null || t.type == type;
      return afterFrom && beforeTo && sameWallet && sameCategory && sameType;
    });
  }

  // CRUD operations //
  Future<void> upsert(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// Read operations - get by id only
  Transaction? get(String id) => _box.get(id); // get by id

  /// hard delete - permanently removes the transaction from the box
  Future<void> deleteHard(String id) async =>
      await _box.delete(id); // hard delete

  /// soft delete - marks the transaction as deleted without removing it from the box
  /// this allows for potential recovery or auditing
  Future<void> deleteSoft(String id) async {
    final transaction = _box.get(id);
    if (transaction != null) {
      final deletedTransaction = transaction.copyWith(isDeleted: true);
      await _box.put(id, deletedTransaction);
    }
  }

  // Query operations //

  /// get all transactions, sorted by date descending and optionally include deleted transactions
  List<Transaction> all({bool includeDeleted = false}) {
    final transactionList = _allIter(
      includeDeleted: includeDeleted,
    ).toList(); // convert to list for sorting
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    return transactionList; // return sorted list
  }

  /// get transactions for a specific month and year, optionally filtered by wallet id and includeDeleted flag
  List<Transaction> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    final transactionList = _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    ).toList();
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    return transactionList; // return sorted list
  }

  /// total amount for a specific type (income, expense, transfer) in a specific month and year for a specific wallet if provided or all wallets if not provided
  double totalAmountByType(
    TransactionType type,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    final transactions = _filter(
      // filter transactions by type and date range and wallet if provided
      from: from,
      to: to,
      walletId: walletId,
      type: type,
      includeDeleted: includeDeleted,
    ).where((t) => t.type == type).fold<double>(0, (sum, t) => sum + t.amount);
    return transactions; // return the total amount
  }

  /// balance = income - expense + transfer_in - transfer_out for a specific wallet if provided or all wallets if not provided (transfer considered for balance calculation purpose)
  double balanceForWallet(String walletId, {bool includeDeleted = false}) {
    double balance = 0.0;
    for (final transaction in _filter(
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      switch (transaction.type) {
        case TransactionType.income:
          if (transaction.walletId == walletId) balance += transaction.amount;
          break;
        case TransactionType.expense:
          if (transaction.walletId == walletId) balance -= transaction.amount;
          break;
        case TransactionType.transfer:
          if (transaction.walletId == walletId) balance -= transaction.amount;
          if (transaction.walletId == walletId) balance += transaction.amount;
      }
    }
    return balance;
  }

  /// net = income - expense for the month for a specific wallet if provided or all wallets if not provided (transfer ignored for net calculation purpose)
  double netForMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    double income = 0.0, expense = 0.0;

    for (final transaction in _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    )) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      }
      if (transaction.type == TransactionType.expense) {
        expense += transaction.amount;
      }
    }
    return income - expense; // net = income - expense
  }

  /// Category-wise net (Income +, Expense -) in a month
  double totalForCategory(
    Category category,
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) {
    final from = _startOfMonth(year, month);
    final to = _startOfNextMonth(year, month);
    double sum = 0.0;

    for (final t in _filter(
      from: from,
      to: to,
      walletId: walletId,
      includeDeleted: includeDeleted,
    ).where((transaction) => transaction.category == category)) {
      if (t.type == TransactionType.income) sum += t.amount;
      if (t.type == TransactionType.expense) sum -= t.amount;
    }
    return sum;
  }

  /// Category + Type (pure sum, not netting)
  double totalForCategoryType(
    Category category,
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
          includeDeleted: includeDeleted,
        )
        .where((t) => t.category == category && t.type == type)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  // --------- Transfer Analytics ---------
  /// total transfer amount in a month (volume, both direction counted positive)
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

  /// Transfer volume touching a wallet (counts in/out as positive)
  double totalTransferForWallet(
    String walletId, {
    bool includeDeleted = false,
  }) {
    return _filter(walletId: walletId, includeDeleted: includeDeleted)
        .where((t) => t.type == TransactionType.transfer)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Transfer volume from -> to (directional)
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
