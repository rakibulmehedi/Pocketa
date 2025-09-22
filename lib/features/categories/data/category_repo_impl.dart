
import 'package:flow/core/data/base_repository.dart';
import 'package:flow/features/categories/data/models/category_model.dart';
import 'package:flow/features/categories/domain/entities/category_entity.dart';
import 'package:flow/features/categories/domain/repositories/category_repository.dart';

class CategoryRepoImpl extends BaseRepositoryImpl<CategoryEntity, CategoryModel> implements CategoryRepository {
  const CategoryRepoImpl(super.box);

  @override
  CategoryEntity modelToEntity(CategoryModel model) => model.toEntity();

  @override
  CategoryModel entityToModel(CategoryEntity entity) => entity.toModel();

  @override
  String get entityIdField => 'id';

  CategoryEntity _markAsDeleted(CategoryEntity entity) {
    return entity.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  dynamic _getFieldValue(CategoryEntity entity, String fieldName) {
    switch (fieldName) {
      case 'name': return entity.name;
      case 'kind': return entity.kind;
      case 'isDefault': return entity.isDefault;
      case 'createdAt': return entity.createdAt;
      default: return null;
    }
  }

  @override
  Future<void> deleteHard(String id) async {
    final m = box.get(id);
    if (m?.isDefault == true) {
      throw StateError('Default categories cannot be deleted');
    }
    await box.delete(id);
  }

  @override
  List<CategoryEntity> all({bool includeDeleted = false}) {
    return box.values
        .map((e) => e.toEntity())
        .where((entity) => includeDeleted || !entity.isDeleted)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
