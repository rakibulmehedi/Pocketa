import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  /// Which kind of category we’re creating
  final CategoryKind kind;
  const AddCategoryDialog({
    super.key,
    required this.kind,
    required bool isIncome,
  });

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  // Simple preset icon/color pools (MVP)
  static const _iconCandidates = <IconData>[
    Icons.fastfood_outlined,
    Icons.restaurant_outlined,
    Icons.local_mall_outlined,
    Icons.directions_bus_outlined,
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.savings_outlined,
    Icons.payments_outlined,
    Icons.wallet_outlined,
    Icons.category_outlined,
  ];

  static const _colorCandidates = <int>[
    0xFF2196F3, // Blue
    0xFFF44336, // Red
    0xFF4CAF50, // Green
    0xFFFF9800, // Orange
    0xFF9C27B0, // Purple
    0xFF009688, // Teal
    0xFF795548, // Brown
    0xFFFF5722, // Deep Orange
  ];

  // Current selections
  late int _iconCodePoint;
  String _iconFontFamily = 'MaterialIcons';
  late int _colorHex;

  @override
  void initState() {
    super.initState();
    _iconCodePoint = _iconCandidates.first.codePoint;
    _colorHex = _colorCandidates.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveCategory = ref.read(saveCategoryProvider);

    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.addCategory),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: const Icon(Icons.edit_outlined),
              ),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return l10n.errorRequired(l10n.name);
                if (t.length > 24) return l10n.errorMaxLength(l10n.name, 24);
                return null;
              },
              onFieldSubmitted: (_) => _submit(saveCategory),
            ),
            const SizedBox(height: 12),

            // Icon + Color compact pickers
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(_colorHex).withValues(alpha: 0.15),
                  child: Icon(
                    IconData(_iconCodePoint, fontFamily: _iconFontFamily),
                    color: Color(_colorHex),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _pickIcon,
                  icon: const Icon(Icons.apps_outlined),
                  label: Text(l10n.icon),
                ),
                const SizedBox(width: 6),
                TextButton.icon(
                  onPressed: _pickColor,
                  icon: const Icon(Icons.palette_outlined),
                  label: Text(l10n.color),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => _submit(saveCategory),
          child: Text(l10n.addCategory),
        ),
      ],
    );
  }

  // ---- Actions ----

  Future<void> _submit(Future<void> Function(CategoryEntity) save) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now().toUtc();
    final entity = CategoryEntity(
      id: now.millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      kind: widget.kind,
      iconCodePoint: _iconCodePoint,
      iconFontFamily: _iconFontFamily,
      colorHex: _colorHex,
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    );

    await save(entity);
    if (!mounted) return;
    Navigator.pop(context, entity);
  }

  void _pickIcon() async {
    final picked = await showModalBottomSheet<IconData>(
      context: context,
      showDragHandle: true,
      builder: (_) => _IconPickerSheet(candidates: _iconCandidates),
    );
    if (picked == null) return;
    setState(() {
      _iconCodePoint = picked.codePoint;
      _iconFontFamily = picked.fontFamily ?? 'MaterialIcons';
    });
  }

  void _pickColor() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (_) => _ColorPickerSheet(candidates: _colorCandidates),
    );
    if (picked == null) return;
    setState(() => _colorHex = picked);
  }

  String _dialogTitleFor(CategoryKind kind) => '';
}

// ---- Bottom sheets (MVP simple pickers) ----

class _IconPickerSheet extends StatelessWidget {
  final List<IconData> candidates;
  const _IconPickerSheet({required this.candidates});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: candidates.length,
        itemBuilder: (_, i) {
          final ic = candidates[i];
          return InkWell(
            onTap: () => Navigator.pop(context, ic),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(ic)),
            ),
          );
        },
      ),
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  final List<int> candidates;
  const _ColorPickerSheet({required this.candidates});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: candidates
                  .map(
                    (hex) => GestureDetector(
                      onTap: () => Navigator.pop(context, hex),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(hex),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
