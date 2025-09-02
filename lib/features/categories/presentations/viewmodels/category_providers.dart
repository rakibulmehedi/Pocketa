import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/features/categories/data/category_repo_impl.dart';
import 'package:pocketa/features/categories/data/models/category_model.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/domain/repositories/category_repository.dart';

final categoryBoxProvider = Provider<Box<CategoryModel>>(
  (ref) => Hive.box<CategoryModel>(HiveBoxes.categories),
);

final categoryRepoProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepoImpl(ref.watch(categoryBoxProvider)),
);
final categoriesMapProvider = Provider<Map<String, CategoryEntity>>((ref) {
  // Watch only the data portion to reduce rebuilds on loading/error transitions
  final list = ref.watch(
    categoriesStreamProvider.select((a) => a.value ?? const <CategoryEntity>[]),
  );
  final map = <String, CategoryEntity>{};
  for (final c in list) {
    map[c.id] = c;
  }
  return map;
});

/// family helper : single id -> entity?
final categoryByIdProvider = Provider.family<CategoryEntity?, String?>((ref, id) {
  if (id == null) return null;
  // Select just the single entity by id from the stream to avoid building the map.
  final match = ref.watch(categoriesStreamProvider.select((a) {
    final list = a.value;
    if (list == null) return null;
    for (final c in list) {
      if (c.id == id) return c;
    }
    return null;
  }));
  return match;
});

final categoriesStreamProvider =
    StreamProvider.autoDispose<List<CategoryEntity>>((ref) {
      return ref.watch(categoryRepoProvider).watchAll();
    });

// convenience actions
final saveCategoryProvider = Provider((ref) {
  final repo = ref.watch(categoryRepoProvider);
  return (CategoryEntity e) => repo.upsert(e);
});

final deleteCategoryProvider = Provider((ref) {
  final repo = ref.watch(categoryRepoProvider);
  return (String id) => repo.delete(id);
});

