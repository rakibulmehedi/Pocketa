import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransferTotalInMonthArgs {
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetTransferTotalInMonthArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetTransferTotalInMonth {
  final TransactionRepository repo;
  const GetTransferTotalInMonth(this.repo);

  double call(GetTransferTotalInMonthArgs a) => repo.totalTransferForMonth(
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
