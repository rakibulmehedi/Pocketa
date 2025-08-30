import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/features/categories/presentations/widgets/add_category_dialog.dart';

class CategoryPicker extends ConsumerWidget {
  final String? valueId;
  final bool isIncome; // filter for income vs expense list
  final ValueChanged<CategoryEntity> onSelected;

  const CategoryPicker({
    super.key,
    required this.onSelected,
    this.valueId,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(categoriesStreamProvider);

    return catsAsync.when(
      data: (list) {
        final filtered = list.where((c) => c.isIncome == isIncome).toList();
        if (filtered.isEmpty) {
          return _CreateFirstTile(isIncome: isIncome);
        }

        final selected = filtered.firstWhere(
          (c) => c.id == valueId,
          orElse: () => filtered.first,
        );

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selected.id,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final c in filtered)
                    DropdownMenuItem(
                      value: c.id,
                      child: Row(
                        children: [
                          Icon(
                            IconData(
                              c.iconCodePoint,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Color(c.colorHex),
                          ),
                          const SizedBox(width: 8),
                          Text(c.name),
                        ],
                      ),
                    ),
                ],
                onChanged: (id) {
                  final c = filtered.firstWhere((e) => e.id == id);
                  onSelected(c);
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'New category',
              icon: const Icon(Icons.add),
              onPressed: () async {
                final created = await showDialog<CategoryEntity>(
                  context: context,
                  builder: (_) => AddCategoryDialog(isIncome: isIncome),
                );
                if (created != null) {
                  onSelected(created); // auto-select new
                }
              },
            ),
          ],
        );
      },
      error: (e, _) => Text('Categories error: $e'),
      loading: () => const LinearProgressIndicator(minHeight: 2),
    );
  }
}

class _CreateFirstTile extends ConsumerWidget {
  final bool isIncome;
  const _CreateFirstTile({required this.isIncome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Category'),
      subtitle: const Text('No categories yet. Tap to create.'),
      trailing: const Icon(Icons.add),
      onTap: () async {
        final created = await showDialog<CategoryEntity>(
          context: context,
          builder: (_) => AddCategoryDialog(isIncome: isIncome),
        );
        if (created == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Category created')));
      },
    );
  }
}
