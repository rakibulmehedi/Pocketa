// lib/features/wallets/presentations/widgets/wallet_picker_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
<<<<<<< Updated upstream:lib/features/wallets/presentations/widgets/wallet_picker_button.dart
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';
import 'package:pocketa/features/wallets/presentations/widgets/add_wallet_sheet.dart';

=======
import 'package:pocketa/features/wallets/presentation/viewmodels/wallet_providers.dart';
import 'package:pocketa/features/wallets/presentation/widgets/add_wallet_sheet.dart';
import 'package:pocketa/shared/widgets.dart';
>>>>>>> Stashed changes:lib/features/wallets/presentation/widgets/wallet_picker_button.dart
class WalletPickerButton extends ConsumerWidget {
  final String? walletId;
  final ValueChanged<WalletEntity> onSelected;
  final String label;
  const WalletPickerButton({
    super.key,
    required this.onSelected,
    this.walletId,
    this.label = 'Wallet',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStreamProvider);

    final t = AppLocalizations.of(context);
    return walletsAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Theme.of(context).shadowColor.withAlpha(50)),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: Text(label),
                subtitle: Text(t.noWallets),
                trailing: IconButton(
                  tooltip: t.addWallet,
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final created = await showAddWalletSheet(context, ref);
                    if (created != null) onSelected(created);
                  },
                ),
                onTap: () async {
                  final created = await showAddWalletSheet(context, ref);
                  if (created != null) onSelected(created);
                },
              ),
            ),
          );
        }

        // Pick current => prefer default wallet, else first, else by id
        WalletEntity current;
        if (walletId != null) {
          current = list.firstWhere(
            (w) => w.id == walletId,
            orElse: () => list.first,
          );
        } else {
          current = list.firstWhere(
            (w) => w.isDefault == true,
            orElse: () => list.first,
          );

          // 🔁 Auto-sync to form only once (not during build)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSelected(current);
          });
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.account_balance_wallet_outlined),
          title: Text(label),
          subtitle: Text(current.name),
          trailing: IconButton(
            tooltip: t.addWallet,
            icon: const Icon(Icons.add),
            onPressed: () async {
              final created = await showAddWalletSheet(context, ref);
              if (created != null) onSelected(created);
            },
          ),
          onTap: () async {
            final selected = await showModalBottomSheet<WalletEntity>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (ctx) =>
                  _WalletChooser(list: list, selectedId: walletId),
            );
            if (selected != null) onSelected(selected);
          },
        );
      },
      error: (e, _) => Text(t.errorGeneric),
      loading: () => const LinearProgressIndicator(minHeight: 2),
    );
  }
}

class _WalletChooser extends StatelessWidget {
  final List<WalletEntity> list;
  final String? selectedId;
  const _WalletChooser({required this.list, this.selectedId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final w = list[i];
          final selected = w.id == selectedId;
          return ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: Text(w.name),
            trailing: selected ? const Icon(Icons.check) : null,
            onTap: () => Navigator.pop(context, w),
          );
        },
      ),
    );
  }
}
