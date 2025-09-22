import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetWalletTransferTotal {
  final TransactionRepository repo;
  const GetWalletTransferTotal(this.repo);

  double call(String walletId, {bool includeDeleted = false}) =>
      repo.totalTransferForWallet(walletId, includeDeleted: includeDeleted);
}
