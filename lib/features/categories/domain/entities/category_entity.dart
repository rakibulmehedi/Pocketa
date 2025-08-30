
class CategoryEntity {
  final String id;
  final String name;
  final int iconCodePoint;
  final int colorHex;
  final bool isDefault;
  final bool isIncome;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorHex,
    this.isDefault = false,
    this.isIncome = false,
    this.createdAt,
    this.updatedAt,
  });
}
