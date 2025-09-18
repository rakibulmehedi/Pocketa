import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_notifier.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/input/app_note_field.dart';
import 'package:pocketa/shared/widgets/ui_components.dart';

class TransactionDetailsSection extends ConsumerWidget {
  final TextEditingController noteController;
  final TextEditingController tagController;
  final TransactionFormState form;

  const TransactionDetailsSection({
    super.key,
    required this.noteController,
    required this.tagController,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(transactionFormProvider.notifier);

    return SectionCard(
      title: l10n.notesAndTags,
      subtitle: l10n.optional,
      trailing: IconButton(
        tooltip: l10n.clearAllTags,
        icon: const Icon(Icons.clear_all),
        onPressed: () {
          notifier.clearTags();
        },
      ),
      children: [
        NoteField(controller: noteController),
        
        SizedBox(height: context.layout.spaceS),
        
        // Tag input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: tagController,
                decoration: InputDecoration(
                  hintText: l10n.addTag,
                  prefixIcon: const Icon(Icons.tag_outlined),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    notifier.addTag(value.trim());
                    tagController.clear();
                  }
                },
              ),
            ),
            
            SizedBox(width: context.layout.spaceS),
            
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.addTag,
              onPressed: () {
                if (tagController.text.trim().isNotEmpty) {
                  notifier.addTag(tagController.text.trim());
                  tagController.clear();
                }
              },
            ),
          ],
        ),
        
        // Tags display
        if (form.tags.isNotEmpty) ...[
          SizedBox(height: context.layout.spaceS),
          Wrap(
            spacing: context.layout.spaceS,
            runSpacing: context.layout.spaceXs,
            children: form.tags
                .map(
                  (tag) => InputChip(
                    label: Text(tag),
                    onDeleted: () => notifier.removeTag(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
