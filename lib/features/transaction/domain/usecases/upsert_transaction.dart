import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class UpsertTransaction {
  final TransactionRepository repo;
  const UpsertTransaction(this.repo);

  Future<void> call(TransactionEntity e) => repo.upsert(e);
}
