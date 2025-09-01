import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransactionSoft {
  final TransactionRepository repo;
  const DeleteTransactionSoft(this.repo);

  Future<void> call(String id) => repo.deleteSoft(id);
}
