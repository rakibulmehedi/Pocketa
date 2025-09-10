import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';

void main() {
  test('categoryByIdProvider selects single entity from stream', () async {
    final c1 = CategoryEntity(
      id: '1',
      name: 'Food',
      kind: CategoryKind.expense,
      iconCodePoint: 0,
    );
    final c2 = CategoryEntity(
      id: '2',
      name: 'Salary',
      kind: CategoryKind.income,
      iconCodePoint: 0,
    );

    final controller = StreamController<List<CategoryEntity>>();
    final container = ProviderContainer(overrides: [
      categoriesStreamProvider.overrideWith((ref) => controller.stream),
    ]);
    addTearDown(container.dispose);
    // Ensure provider is listening before emitting to the stream.
    final sub = container.listen<CategoryEntity?>(
      categoryByIdProvider('2'),
      (_, __) {},
    );
    addTearDown(sub.close);

    controller.add([c1, c2]);
    // allow stream to propagate
    await Future<void>.delayed(const Duration(milliseconds: 1));

    final picked = container.read(categoryByIdProvider('2'));
    expect(picked?.id, '2');

    await controller.close();
  });
}
