import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetCategoryTypeTotalInMonthArgs {
  final String categoryId;
  final TransactionType type;
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetCategoryTypeTotalInMonthArgs({
    required this.categoryId,
    required this.type,
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetCategoryTypeTotalInMonth {
  final TransactionRepository repo;
  const GetCategoryTypeTotalInMonth(this.repo);

  double call(GetCategoryTypeTotalInMonthArgs a) => repo.totalForCategoryType(
    a.categoryId,
    a.type,
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
