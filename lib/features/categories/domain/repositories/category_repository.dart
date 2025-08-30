import 'package:pocketa/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> upsert(CategoryEntity e);
  Future<void> delete(String id);
  CategoryEntity? get(String id);
  List<CategoryEntity> all();
  Stream<List<CategoryEntity>> watchAll();
}
