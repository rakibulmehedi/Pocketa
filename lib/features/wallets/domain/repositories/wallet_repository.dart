import 'package:flow/core/data/base_repository.dart';
import 'package:flow/features/wallets/domain/entities/wallet_entity.dart';

/// Repository contract for Wallets.
abstract class WalletRepository extends BaseRepository<WalletEntity> {
  // Wallet-specific methods
  WalletEntity? getDefaultWallet();
  Future<void> setDefaultWallet(String walletId);
  List<WalletEntity> getByType(WalletType type);
}
