import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionById {
  final TransactionRepository repo;
  const GetTransactionById(this.repo);

  TransactionEntity? call(String id) => repo.getById(id);
}
