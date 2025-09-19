import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/features/categories/presentations/widgets/category_chips_picker.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_notifier.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:pocketa/l10n/app_localizations.dart';
<<<<<<< Updated upstream
import 'package:pocketa/shared/widgets/section_card.dart';
=======
import 'package:pocketa/shared/widgets.dart';
>>>>>>> Stashed changes

class TransactionCategorySection extends ConsumerWidget {
  final TransactionFormState form;

  const TransactionCategorySection({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(transactionFormProvider.notifier);
    final kind = kindFromTxType(form.type);

    return SectionCard(
      title: l10n.category,
      subtitle: l10n.tapToSelect,
      trailing: IconButton(
        tooltip: l10n.reset,
        icon: const Icon(Icons.restart_alt),
        onPressed: () {
          final list = defaultCategoriesByKind(kind);
          if (list.isNotEmpty) {
            notifier.setCategoryId(list.first.id);
            HapticFeedback.selectionClick();
          }
        },
      ),
      children: [
        CategoryChipsPicker(
          kind: kind,
          selectedId: form.categoryId,
          onSelected: (category) {
            notifier.setCategoryId(category.id);
            HapticFeedback.selectionClick();
          },
        ),
      ],
    );
  }
}
