import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetAmountByCategoryArgs {
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetAmountByCategoryArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetAmountByCategory {
  final TransactionRepository repo;
  const GetAmountByCategory(this.repo);

  Map<String, double> call(GetAmountByCategoryArgs a) => repo.amountByCategory(
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
