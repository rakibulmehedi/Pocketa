import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetNetWorth {
  final TransactionRepository repo;
  const GetNetWorth(this.repo);

  double call({bool includeDeleted = false}) =>
      repo.netAll(includeDeleted: includeDeleted);
}
