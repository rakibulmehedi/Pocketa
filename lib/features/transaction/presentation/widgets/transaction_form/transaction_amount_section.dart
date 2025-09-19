import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/currency_utils.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_notifier.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:pocketa/shared/widgets.dart';

class TransactionAmountSection extends ConsumerWidget {
  final TextEditingController amountController;
  final TransactionFormState form;

  const TransactionAmountSection({
    super.key,
    required this.amountController,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.layout;
    final notifier = ref.read(transactionFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount field
        AmountField(
          controller: amountController,
          currencySymbol: AppCurrencies.symbol(form.currency),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0.0;
            notifier.setAmount(amount);
          },
        ),

        SizedBox(height: layout.spaceS),

        // Quick amount chips
        _buildQuickAmountChips(context, notifier, form, layout),
      ],
    );
  }

  Widget _buildQuickAmountChips(
    BuildContext context,
    TransactionFormNotifier notifier,
    TransactionFormState form,
    AppSize layout,
  ) {
    const amounts = <int>[100, 200, 500, 1000, 2000, 5000];

    return Wrap(
      spacing: layout.spaceS,
      runSpacing: layout.spaceXs,
      children: amounts.map((amount) {
        // final displayAmount = form.type == TransactionType.expense
        //     ? -amount.toDouble()
        //     : amount.toDouble();

        return ActionChip(
          label: Text(
            '${AppCurrencies.symbol(form.currency)}$amount',
          ),
          onPressed: () {
            amountController.text = amount.toString();
            notifier.setAmount(amount.toDouble());
            HapticFeedback.lightImpact();
          },
        );
      }).toList(),
    );
  }
}
