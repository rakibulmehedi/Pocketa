import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetAllTransactions {
  final TransactionRepository repo;
  const GetAllTransactions(this.repo);

  List<TransactionEntity> call({bool includeDeleted = false}) =>
      repo.all(includeDeleted: includeDeleted);
}
