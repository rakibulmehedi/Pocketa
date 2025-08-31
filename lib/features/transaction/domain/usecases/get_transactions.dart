import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;
  const GetTransactions(this.repository);

  List<TransactionEntity> all({bool includeDeleted = false}) =>
      repository.all(includeDeleted: includeDeleted);

  List<TransactionEntity> byMonth(
    int year,
    int month, {
    String? walletId,
    bool includeDeleted = false,
  }) => repository.byMonth(
        year,
        month,
        walletId: walletId,
        includeDeleted: includeDeleted,
      );
}
