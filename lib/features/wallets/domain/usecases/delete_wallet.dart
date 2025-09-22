import 'package:flow/features/wallets/domain/repositories/wallet_repository.dart';

class DeleteWallet {
  final WalletRepository repository;
  const DeleteWallet(this.repository);
  Future<void> call(String id, {bool hard = false}) => hard ? repository.deleteHard(id) : repository.deleteSoft(id);
}
