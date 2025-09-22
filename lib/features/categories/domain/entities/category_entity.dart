import 'package:flow/core/data/base_entity.dart';

enum CategoryKind { income, expense, transfer }

class CategoryEntity extends BaseEntityImpl {
  final String name;
  final CategoryKind kind; // income / expense / transfer
  final int iconCodePoint; // material icon code point
  final String iconFontFamily; // usually "MaterialIcons"
  final int colorHex; // color for UI
  final bool isDefault;
  final bool isIncome;

  CategoryEntity({
    required super.id,
    required this.name,
    required this.kind,
    required this.iconCodePoint,
    this.isIncome = false,
    this.iconFontFamily = 'MaterialIcons',
    this.colorHex = 0xFF607D8B, // default grey
    this.isDefault = false,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    kind,
    iconCodePoint,
    iconFontFamily,
    colorHex,
    isDefault,
    isIncome,
  ];

  CategoryEntity copyWith({
    String? id,
    String? name,
    CategoryKind? kind,
    int? iconCodePoint,
    String? iconFontFamily,
    int? colorHex,
    bool? isDefault,
    bool? isIncome,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      isIncome: isIncome ?? this.isIncome,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
