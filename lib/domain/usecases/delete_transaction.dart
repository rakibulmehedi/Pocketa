import 'package:pocketa/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;
  const DeleteTransaction(this.repository);

  Future<void> call(String id, {bool hard = false}) async {
    if (hard) {
      await repository.deleteHard(id);
    } else {
      await repository.deleteSoft(id);
    }
  }
}
