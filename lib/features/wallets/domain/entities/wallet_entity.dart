import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';
part 'wallet_entity.g.dart';

enum WalletType { cash, bkash, nagad, bank, upay, rocket, others }

@freezed
class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String id,
    required String name,
    @Default(WalletType.cash) WalletType type,
    @Default(false) bool isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletEntityFromJson(json);
}
