import 'package:pocketa/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransferBetweenWalletsArgs {
  final String fromWalletId;
  final String toWalletId;
  final bool includeDeleted;
  const GetTransferBetweenWalletsArgs({
    required this.fromWalletId,
    required this.toWalletId,
    this.includeDeleted = false,
  });
}

class GetTransferBetweenWallets {
  final TransactionRepository repo;
  const GetTransferBetweenWallets(this.repo);

  double call(GetTransferBetweenWalletsArgs a) =>
      repo.totalTransferBetweenWallets(
        a.fromWalletId,
        a.toWalletId,
        includeDeleted: a.includeDeleted,
      );
}
