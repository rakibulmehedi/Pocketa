import 'package:flow/features/wallets/domain/entities/wallet_entity.dart';
import 'package:flow/features/wallets/domain/repositories/wallet_repository.dart';

class SaveWallet {
  final WalletRepository repository;
  const SaveWallet(this.repository);

  Future<void> call(WalletEntity wallet) => repository.upsert(wallet);
}
