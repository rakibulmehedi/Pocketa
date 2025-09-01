import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetWalletBalance {
  final TransactionRepository repo;
  const GetWalletBalance(this.repo);

  double call(String walletId, {bool includeDeleted = false}) =>
      repo.balanceForWallet(walletId, includeDeleted: includeDeleted);
}
