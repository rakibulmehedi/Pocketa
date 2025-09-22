import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/features/transaction/presentation/viewmodels/transaction_form_notifier.dart';
import 'package:flow/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:flow/features/wallets/presentation/widgets/wallet_picker_button.dart';
import 'package:flow/l10n/app_localizations.dart';
import 'package:flow/shared/widgets.dart';

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
