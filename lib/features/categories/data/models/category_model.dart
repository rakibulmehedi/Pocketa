import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow/core/db/hive_type.dart';
import 'package:flow/features/categories/domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: kCategoryModelTypeId)
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required int kindIndex, // store enum index (CategoryKind)
    @HiveField(3) required int iconCodePoint,
    @HiveField(4) @Default('MaterialIcons') String iconFontFamily,
    @HiveField(5) @Default(0xFF607D8B) int colorHex,
    @HiveField(6) @Default(false) bool isDefault,
    @HiveField(7) DateTime? createdAt,
    @HiveField(8) DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

extension CategoryMapper on CategoryModel {
  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    kind: CategoryKind.values[kindIndex],
    iconCodePoint: iconCodePoint,
    iconFontFamily: iconFontFamily,
    colorHex: colorHex,
    isDefault: isDefault,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension CategoryEntityMapper on CategoryEntity {
  CategoryModel toModel() => CategoryModel(
    id: id,
    name: name,
    kindIndex: kind.index,
    iconCodePoint: iconCodePoint,
    iconFontFamily: iconFontFamily,
    colorHex: colorHex,
    isDefault: isDefault,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

