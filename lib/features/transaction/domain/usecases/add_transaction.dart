import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;
  const AddTransaction(this.repository);

  Future<void> call(TransactionEntity tx) {
    return repository.upsert(tx);
  }
}
