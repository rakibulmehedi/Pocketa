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
