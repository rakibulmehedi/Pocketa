import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_notifier.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:pocketa/features/wallets/presentations/widgets/wallet_picker_button.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/section_card.dart';

class TransactionWalletSection extends ConsumerWidget {
  final TransactionFormState form;

  const TransactionWalletSection({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(transactionFormProvider.notifier);

    return SectionCard(
      title: l10n.wallet,
      subtitle: l10n.tapToSelect,
      children: [
        WalletPickerButton(
          walletId: form.walletId,
          onSelected: (wallet) {
            notifier.setWalletId(wallet.id);
          },
        ),
      ],
    );
  }
}
