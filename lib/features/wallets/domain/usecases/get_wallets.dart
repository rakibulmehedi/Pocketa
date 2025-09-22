import 'package:flow/features/wallets/domain/entities/wallet_entity.dart';
import 'package:flow/features/wallets/domain/repositories/wallet_repository.dart';

class GetWallets {
  final WalletRepository repository;
  const GetWallets(this.repository);
  List<WalletEntity> call({bool includeDeleted = false}) => repository.all(includeDeleted: includeDeleted);
}
