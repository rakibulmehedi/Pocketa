
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/features/categories/data/models/category_model.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/domain/repositories/category_repository.dart';

class CategoryRepoImpl implements CategoryRepository {
  final Box<CategoryModel> _box;
  const CategoryRepoImpl(this._box);

  @override
  Future<void> upsert(CategoryEntity e) async {
    await _box.put(e.id, e.toModel());
  }

  @override
  Future<void> delete(String id) async {
    final m = _box.get(id);
    if (m?.isDefault == true) {
      throw StateError('Default categories cannot be deleted');
    }
    await _box.delete(id);
  }

  @override
  CategoryEntity? get(String id) => _box.get(id)?.toEntity();

  @override
  List<CategoryEntity> all() =>
      _box.values.map((e) => e.toEntity()).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  Stream<List<CategoryEntity>> watchAll() async* {
    List<CategoryEntity> snap() => all();
    yield snap();
    await for (final _ in _box.watch()) {
      yield snap();
    }
  }
}
