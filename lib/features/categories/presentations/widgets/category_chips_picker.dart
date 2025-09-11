import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/features/categories/presentations/widgets/add_category_dialog.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class CategoryChipsPicker extends ConsumerWidget {
  final CategoryKind kind;
  final String? selectedId;
  final ValueChanged<CategoryEntity> onSelected;

  const CategoryChipsPicker({
    super.key,
    required this.kind,
    required this.onSelected,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(categoriesStreamProvider);

    return catsAsync.when(
      data: (userList) {
        final merged = <CategoryEntity>[
          ...defaultCategoriesByKind(kind),
          ...userList.where((c) => c.kind == kind),
        ];

        return Wrap(
          spacing: 8,
          runSpacing: -6,
          children: [
            ...merged.map((c) {
              final selected = c.id == selectedId;
              return ChoiceChip(
                selected: selected,
                avatar: selected
                    ? const Icon(Icons.check, size: 16)
                    : Icon(
                        c.iconCodePoint != 0 
                            ? IconData(c.iconCodePoint, fontFamily: c.iconFontFamily)
                            : Icons.category,
                        size: 16,
                        color: Color(c.colorHex),
                      ),
                label: Text(c.name),
                onSelected: (_) => onSelected(c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),

            // ➕ New chip
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: Text(AppLocalizations.of(context).newLabel),
              onPressed: () async {
                final created = await showDialog<CategoryEntity>(
                  context: context,
                  builder: (_) => AddCategoryDialog(
                    kind: kind,
                    isIncome: kind == CategoryKind.income,
                  ),
                );
                if (created != null) onSelected(created);
              },
            ),

            const SizedBox(height: 12,),
            
          ],
        );
      },
      error: (e, _) => Text(AppLocalizations.of(context).errorGeneric),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: LinearProgressIndicator(minHeight: 2),
      ),
    );
  }
}
