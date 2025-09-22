import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:flow/core/core.dart';
import 'package:flow/core/db/hive_box.dart';
import 'package:flow/features/categories/data/category_repo_impl.dart';
import 'package:flow/features/categories/data/models/category_model.dart';
import 'package:flow/features/categories/domain/entities/category_entity.dart';

final categoryBoxProvider = Provider<Box<CategoryModel>>(
  (ref) => Hive.box<CategoryModel>(HiveBoxes.categories),
);

final categoryRepoProvider = BaseProviders.repositoryProvider<CategoryRepoImpl, CategoryEntity>(
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
final categoryByIdProvider = BaseProviders.entityByIdProvider<CategoryEntity>(
  categoryRepoProvider,
);

final categoriesStreamProvider = BaseProviders.allEntitiesProvider<CategoryEntity>(
  categoryRepoProvider,
);

// convenience actions
final saveCategoryProvider = Provider((ref) {
  final repo = ref.watch(categoryRepoProvider);
  return (CategoryEntity e) => repo.upsert(e);
});

final deleteCategoryProvider = Provider((ref) {
  final repo = ref.watch(categoryRepoProvider);
  return (String id) => repo.deleteHard(id);
});

