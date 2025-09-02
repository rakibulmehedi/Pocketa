import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/core/db/hive_type.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

/// ---------- Wallet Type Enum ----------
/// Assign its own unique typeId (must NOT clash with WalletModel).
/// Keep this stable once used on device!
@HiveType(typeId: kWalletEnumTypeId)
enum WalletTypeDto {
  @HiveField(0)
  cash,
  @HiveField(1)
  bkash,
  @HiveField(2)
  nagad,
  @HiveField(3)
  bank,
  @HiveField(4)
  upay,
  @HiveField(5)
  rocket,
  @HiveField(6)
  others,
}

WalletTypeDto _toDto(WalletType type) => WalletTypeDto.values[type.index];
WalletType _fromDto(WalletTypeDto t) => WalletType.values[t.index];

/// ---------- Wallet Model ----------
@freezed
@HiveType(typeId: kWalletModelTypeId)
class WalletModel with _$WalletModel {
  const factory WalletModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required WalletTypeDto type,
    @HiveField(3) @Default(false) bool isDefault,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) DateTime? updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

/// ---------- Mapping ----------
extension WalletMapper on WalletModel {
  WalletEntity toEntity() => WalletEntity(
        id: id,
        name: name,
        type: _fromDto(type),
        isDefault: isDefault,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension WalletEntityMapper on WalletEntity {
  WalletModel toModel() => WalletModel(
        id: id,
        name: name,
        type: _toDto(type),
        isDefault: isDefault,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
