import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetMonthNetArgs {
  final int y, m;
  final String? walletId;
  final bool includeDeleted;
  const GetMonthNetArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetMonthNet {
  final TransactionRepository repo;
  const GetMonthNet(this.repo);

  double call(GetMonthNetArgs a) => repo.netForMonth(
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
