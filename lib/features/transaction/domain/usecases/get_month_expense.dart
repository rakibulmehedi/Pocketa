import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_type.dart';

class GetMonthExpenseArgs {
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetMonthExpenseArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetMonthExpense {
  final TransactionRepository repo;
  const GetMonthExpense(this.repo);

  double call(GetMonthExpenseArgs a) => repo.totalAmountByType(
        TransactionType.expense,
        a.y,
        a.m,
        walletId: a.walletId,
        includeDeleted: a.includeDeleted,
      );
}
