import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/core/providers/base_providers.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';
import 'package:pocketa/features/wallets/data/wallet_repo_impl.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';

/// Hive box provider
final walletBoxProvider = Provider<Box<WalletModel>>(
  (ref) => Hive.box<WalletModel>(HiveBoxes.wallets),
);

/// Repository provider using BaseProviders
final walletRepoProvider = BaseProviders.repositoryProvider<WalletRepository, WalletEntity>(
  (ref) => WalletRepoImpl(ref.watch(walletBoxProvider)),
);

/// All wallets stream provider using BaseProviders
final allWalletsProvider = BaseProviders.allEntitiesProvider<WalletEntity>(walletRepoProvider);

/// Wallet by ID provider using BaseProviders
final walletByIdProvider = BaseProviders.entityByIdProvider<WalletEntity>(walletRepoProvider);

/// Direct repository access (no need for use case wrappers)
final saveWalletProvider = Provider<Future<void> Function(WalletEntity)>((ref) {
  final repository = ref.watch(walletRepoProvider);
  return (wallet) => repository.upsert(wallet);
});

final deleteWalletProvider = Provider<Future<void> Function(String, {bool hard})>((ref) {
  final repository = ref.watch(walletRepoProvider);
  return (id, {bool hard = false}) => hard ? repository.deleteHard(id) : repository.deleteSoft(id);
});

final getWalletsProvider = Provider<List<WalletEntity> Function({bool includeDeleted})>((ref) {
  final repository = ref.watch(walletRepoProvider);
  return ({bool includeDeleted = false}) => repository.all(includeDeleted: includeDeleted);
});

/// Wallet-specific providers
final defaultWalletProvider = Provider<WalletEntity?>((ref) {
  final repository = ref.watch(walletRepoProvider);
  return repository.getDefaultWallet();
});

final walletsByTypeProvider = Provider.family<List<WalletEntity>, WalletType>((ref, type) {
  final repository = ref.watch(walletRepoProvider);
  return repository.getByType(type);
});

/// Legacy stream provider for backward compatibility
final walletsStreamProvider = allWalletsProvider;
