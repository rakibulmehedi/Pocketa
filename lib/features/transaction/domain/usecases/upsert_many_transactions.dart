import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class UpsertManyTransactions {
  final TransactionRepository repo;
  const UpsertManyTransactions(this.repo);

  Future<void> call(Iterable<TransactionEntity> list) => repo.upsertMany(list);
}
