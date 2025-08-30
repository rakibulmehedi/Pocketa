import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';

class WalletRepoImpl implements WalletRepository {
  final Box<WalletModel> _box;
  const WalletRepoImpl(this._box);

  // make sure only one wallet is default
  @override
  Future<void> upsert(WalletEntity wallet) async {
    final model = wallet.toModel();

    if (model.isDefault) {
      for (final key in _box.keys) {
        final m = _box.get(key);
        if (m != null && m.isDefault && m.id != model.id) {
          await _box.put(key, m.copyWith(isDefault: false));
        }
      }
    }

    await _box.put(model.id, model);
  }

  @override
  Future<void> delete(String id, {bool hard = false}) async {
    await _box.delete(id);
  }

  @override
  WalletEntity? get(String id) => _box.get(id)?.toEntity();

  @override
  List<WalletEntity> all() =>
      _box.values.map((e) => e.toEntity()).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  Stream<List<WalletEntity>> watchAll() async* {
    List<WalletEntity> snapshot() => all();
    yield snapshot();
    await for (final _ in _box.watch()) {
      yield snapshot();
    }
  }
}
