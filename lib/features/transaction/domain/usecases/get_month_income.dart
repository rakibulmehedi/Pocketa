import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flow/features/transaction/domain/entities/transaction_type.dart';

class GetMonthIncomeArgs {
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetMonthIncomeArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetMonthIncome {
  final TransactionRepository repo;
  const GetMonthIncome(this.repo);

  double call(GetMonthIncomeArgs a) => repo.totalAmountByType(
        TransactionType.income,
        a.y,
        a.m,
        walletId: a.walletId,
        includeDeleted: a.includeDeleted,
      );
}
