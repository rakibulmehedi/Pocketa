enum CategoryKind { income, expense, transfer }

class CategoryEntity {
  final String id;
  final String name;
  final CategoryKind kind; // income / expense / transfer
  final int iconCodePoint; // material icon code point
  final String iconFontFamily; // usually "MaterialIcons"
  final int colorHex; // color for UI
  final bool isDefault;
  final bool isIncome;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.kind,
    required this.iconCodePoint,
    this.isIncome = false,
    this.iconFontFamily = 'MaterialIcons',
    this.colorHex = 0xFF607D8B, // default grey
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });
}
