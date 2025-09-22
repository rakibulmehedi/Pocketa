import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetCategoryTotalInMonthArgs {
  final String categoryId;
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetCategoryTotalInMonthArgs({
    required this.categoryId,
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetCategoryTotalInMonth {
  final TransactionRepository repo;
  const GetCategoryTotalInMonth(this.repo);

  double call(GetCategoryTotalInMonthArgs a) => repo.totalForCategory(
    a.categoryId,
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
