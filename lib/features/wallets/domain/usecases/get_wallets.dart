import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';

class GetWallets {
  final WalletRepository repository;
  const GetWallets(this.repository);
  List<WalletEntity> call() => repository.all();
}
