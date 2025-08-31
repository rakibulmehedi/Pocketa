import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pocketa/features/categories/data/category_repo_impl.dart';
import 'package:pocketa/features/categories/data/models/category_model.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/domain/repositories/category_repository.dart';

final categoryBoxProvider = Provider<Box<CategoryModel>>(
  (ref) => Hive.box<CategoryModel>('categories'),
);

final categoryRepoProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepoImpl(ref.watch(categoryBoxProvider)),
);
final categoriesMapProvider = Provider<Map<String, CategoryEntity>>((ref) {
  final asyncList = ref.watch(categoriesStreamProvider);
  return asyncList.maybeWhen(
    data: (list) {
      final map = <String, CategoryEntity>{};
      for (final c in list) {
        map[c.id] = c;
      }
      return map;
    },
    orElse: () => const {},
  );
});

/// family helper : single id -> entity?
final categoryByIdProvider = Provider.family<CategoryEntity?, String?>((
  ref,
  id,
) {
  if (id == null) return null;
  final map = ref.watch(categoriesMapProvider);
  return map[id];
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


