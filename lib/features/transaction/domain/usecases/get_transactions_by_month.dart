import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsByMonthArgs {
  final int y;
  final int m;
  final String? walletId;
  final bool includeDeleted;
  const GetTransactionsByMonthArgs({
    required this.y,
    required this.m,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetTransactionsByMonth {
  final TransactionRepository repo;
  const GetTransactionsByMonth(this.repo);

  List<TransactionEntity> call(GetTransactionsByMonthArgs a) => repo.byMonth(
    a.y,
    a.m,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
