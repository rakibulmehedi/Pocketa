import 'package:pocketa/domain/entities/transaction_entity.dart';
import 'package:pocketa/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;
  const AddTransaction(this.repository);

  Future<void> call(TransactionEntity tx) {
    return repository.upsert(tx);
  }
}
