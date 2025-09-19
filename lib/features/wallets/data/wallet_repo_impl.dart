import 'package:pocketa/core/data/base_repository.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/domain/repositories/wallet_repository.dart';

/// Hive-backed implementation for WalletRepository.
class WalletRepoImpl extends BaseRepositoryImpl<WalletEntity, WalletModel> implements WalletRepository {
  const WalletRepoImpl(super.box);

  @override
  WalletEntity modelToEntity(WalletModel model) => model.toEntity();

  @override
  WalletModel entityToModel(WalletEntity entity) => entity.toModel();

  @override
  String get entityIdField => 'id';

  WalletEntity _markAsDeleted(WalletEntity entity) {
    return entity.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  dynamic _getFieldValue(WalletEntity entity, String fieldName) {
    switch (fieldName) {
      case 'name': return entity.name;
      case 'type': return entity.type;
      case 'isDefault': return entity.isDefault;
      case 'createdAt': return entity.createdAt;
      default: return null;
    }
  }

  // Override upsert to handle default wallet logic
  @override
  Future<void> upsert(WalletEntity entity) async {
    final now = DateTime.now().toUtc();
    final model = entity
        .copyWith(createdAt: entity.createdAt ?? now, updatedAt: now)
        .toModel();

    // Make sure only one wallet is default
    if (model.isDefault) {
      for (final key in box.keys) {
        final m = box.get(key);
        if (m != null && m.isDefault && m.id != model.id) {
          await box.put(key, m.copyWith(isDefault: false));
        }
      }
    }

    await box.put(model.id, model);
  }

  @override
  List<WalletEntity> all({bool includeDeleted = false}) {
    final list = box.values
        .map((e) => e.toEntity())
        .where((entity) => includeDeleted || !entity.isDeleted)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  @override
  WalletEntity? getDefaultWallet() {
    return all().where((wallet) => wallet.isDefault).firstOrNull;
  }

  @override
  Future<void> setDefaultWallet(String walletId) async {
    // First, remove default from all wallets
    for (final key in box.keys) {
      final model = box.get(key);
      if (model != null && model.isDefault) {
        await box.put(key, model.copyWith(isDefault: false));
      }
    }

    // Then set the specified wallet as default
    final model = box.get(walletId);
    if (model != null) {
      await box.put(walletId, model.copyWith(
        isDefault: true,
        updatedAt: DateTime.now().toUtc(),
      ));
    }
  }

  @override
  List<WalletEntity> getByType(WalletType type) {
    return all().where((wallet) => wallet.type == type).toList();
  }
}
