import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  final bool isIncome;
  const AddCategoryDialog({super.key, required this.isIncome});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  final int _icon = Icons.category_outlined.codePoint;
  final int _color = 0xFF2196F3;

  @override
  Widget build(BuildContext context) {
    final save = ref.read(saveCategoryProvider);

    return AlertDialog(
      title: const Text('New Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            // MVP: simple icon/color choices
            Row(
              children: [
                Icon(
                  IconData(_icon, fontFamily: 'MaterialIcons'),
                  color: Color(_color),
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Pick icon/color'),
                  onPressed: () {
                    // later: open a simple picker
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final entity = CategoryEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _name.text.trim(),
              iconCodePoint: _icon,
              colorHex: _color,
              isIncome: widget.isIncome,
              createdAt: DateTime.now().toUtc(),
            );
            await save(entity);
            if (!mounted) return;
            Navigator.pop(context, entity); // return created entity
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
