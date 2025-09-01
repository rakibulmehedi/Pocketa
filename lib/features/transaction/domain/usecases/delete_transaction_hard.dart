import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransactionHard {
  final TransactionRepository repo;
  const DeleteTransactionHard(this.repo);

  Future<void> call(String id) => repo.deleteHard(id);
}
