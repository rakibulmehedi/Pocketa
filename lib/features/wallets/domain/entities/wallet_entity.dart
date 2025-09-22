import 'package:flow/core/data/base_entity.dart';

enum WalletType { cash, bkash, nagad, bank, upay, rocket, others }

class WalletEntity extends BaseEntityImpl {
  final String name;
  final WalletType type;
  final bool isDefault;

  WalletEntity({
    required super.id,
    required this.name,
    this.type = WalletType.cash,
    this.isDefault = false,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) {
    return WalletEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      type: WalletType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WalletType.cash,
      ),
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'isDefault': isDefault,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  WalletEntity copyWith({
    String? id,
    String? name,
    WalletType? type,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    type,
    isDefault,
  ];
}
