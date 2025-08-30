
import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 31)
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required int iconCodePoint,
    @HiveField(3) required int colorHex,
    @HiveField(4) @Default(false) bool isDefault,
    @HiveField(5) @Default(false) bool isIncome,
    @HiveField(6) DateTime? createdAt,
    @HiveField(7) DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

extension CategoryMapper on CategoryModel {
  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    iconCodePoint: iconCodePoint,
    colorHex: colorHex,
    isDefault: isDefault,
    isIncome: isIncome,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension CategoryEntityMapper on CategoryEntity {
  CategoryModel toModel() => CategoryModel(
    id: id,
    name: name,
    iconCodePoint: iconCodePoint,
    colorHex: colorHex,
    isDefault: isDefault,
    isIncome: isIncome,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
