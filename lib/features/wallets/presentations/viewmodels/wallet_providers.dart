import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';
import 'package:pocketa/features/wallets/data/models/wallet_repo_impl.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';
import 'package:pocketa/features/wallets/domain/usecases/delete_wallet.dart';
import 'package:pocketa/features/wallets/domain/usecases/get_wallets.dart';
import 'package:pocketa/features/wallets/domain/usecases/save_wallet.dart';

/// Hive box provider
final walletBoxProvider = Provider<Box<WalletModel>>(
  (ref) => Hive.box<WalletModel>('wallets'),
);

/// Repo
final walletRepoProvider = Provider<WalletRepository>(
  (ref) => WalletRepoImpl(ref.watch(walletBoxProvider)),
);

/// Usecases
final saveWalletProvider = Provider(
  (ref) => SaveWallet(ref.watch(walletRepoProvider)),
);
final deleteWalletProvider = Provider(
  (ref) => DeleteWallet(ref.watch(walletRepoProvider)),
);
final getWalletsProvider = Provider(
  (ref) => GetWallets(ref.watch(walletRepoProvider)),
);

/// Reactive list (watch hive events)
final walletsStreamProvider = StreamProvider.autoDispose<List<WalletEntity>>((
  ref,
) async* {
  final box = ref.watch(walletBoxProvider);
  List<WalletEntity> snapshot() =>
      box.values.map((m) => m.toEntity()).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  yield snapshot();
  await for (final _ in box.watch()) {
    yield snapshot();
  }
});
