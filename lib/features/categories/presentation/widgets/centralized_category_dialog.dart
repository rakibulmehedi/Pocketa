import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/features/categories/domain/entities/category_entity.dart';
import 'package:flow/features/categories/presentation/viewmodels/category_providers.dart';
import 'package:flow/l10n/app_localizations.dart';
import 'package:flow/shared/services/ui/ui_services.dart';

class CentralizedCategoryDialog extends ConsumerStatefulWidget {
  final CategoryKind kind;
  final bool isIncome;

  const CentralizedCategoryDialog({
    super.key,
    required this.kind,
    required this.isIncome,
  });

  @override
  ConsumerState<CentralizedCategoryDialog> createState() => _CentralizedCategoryDialogState();
}

class _CentralizedCategoryDialogState extends ConsumerState<CentralizedCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  IconData _selectedIcon = Icons.category_outlined;
  int _selectedColor = 0xFF607D8B;

  // Simple preset icon/color pools
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final entity = CategoryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      kind: widget.kind,
      iconCodePoint: _selectedIcon.codePoint,
      iconFontFamily: 'MaterialIcons',
      colorHex: _selectedColor,
      isIncome: widget.isIncome,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(saveCategoryProvider)(entity);
      if (mounted) Navigator.of(context).pop(entity);
    } catch (e) {
      if (mounted) {
        SnackbarService.showError(
          context,
          message: l10n.errorGeneric,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Form(
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
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          _buildIconSelector(),
          const SizedBox(height: 16),
          _buildColorSelector(),
        ],
      ),
    );
  }


  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Icon', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _iconCandidates.map((icon) {
            final isSelected = icon == _selectedIcon;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _colorCandidates.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(color),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
