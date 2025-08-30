import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';

class DeleteWallet {
  final WalletRepository repository;
  const DeleteWallet(this.repository);
  Future<void> call(String id, {bool hard = false}) => repository.delete(id);
}
