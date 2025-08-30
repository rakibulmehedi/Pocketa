import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<void> upsert(WalletEntity wallet);
  Future<void> delete(String id, {bool hard = false}); 
  WalletEntity? get(String id);
  List<WalletEntity> all();
  Stream<List<WalletEntity>> watchAll(); 
}
