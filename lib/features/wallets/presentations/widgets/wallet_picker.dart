// lib/features/wallets/presentations/widgets/wallet_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';

class WalletPicker extends ConsumerWidget {
  final String? valueId;
  final ValueChanged<WalletEntity> onSelected;
  final String label;

  const WalletPicker({
    super.key,
    required this.onSelected,
    this.valueId,
    this.label = 'Wallet',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStreamProvider);

    return walletsAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return ListTile(
            title: Text(label),
            subtitle: const Text('No wallets yet. Tap to add one.'),
            trailing: const Icon(Icons.add),
            onTap: () async {
              final created = await _showAddWalletDialog(context, ref);
              if (created != null) onSelected(created);
            },
          );
        }

        // current selection
        final selected = list.firstWhere(
          (w) => w.id == valueId,
          orElse: () => list.first,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selected.id,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
              items: [
                for (final w in list)
                  DropdownMenuItem<String>(value: w.id, child: Text(w.name)),
              ],
              onChanged: (id) {
                final w = list.firstWhere((e) => e.id == id);
                onSelected(w);
              },
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add wallet'),
                onPressed: () async {
                  final created = await _showAddWalletDialog(context, ref);
                  if (created != null) onSelected(created);
                },
              ),
            ),
          ],
        );
      },
      error: (e, _) => Text('Wallets error: $e'),
      loading: () => const LinearProgressIndicator(minHeight: 2),
    );
  }
}

/// Inline dialog to create a wallet
Future<WalletEntity?> _showAddWalletDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  var type = WalletType.cash;
  var makeDefault = false;

  WalletEntity? result;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Add Wallet'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Wallet name',
                  hintText: 'e.g. Cash, bKash, Nagad, Salary Bank',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<WalletType>(
                value: type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final t in WalletType.values)
                    DropdownMenuItem(value: t, child: Text(_prettyType(t))),
                ],
                onChanged: (v) => type = v!,
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setSt) => SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Make default'),
                  value: makeDefault,
                  onChanged: (v) => setSt(() => makeDefault = v),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;

              final entity = WalletEntity(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: nameCtrl.text.trim(),
                type: type,
                isDefault: makeDefault,
                createdAt: DateTime.now().toUtc(),
              );

              try {
                await ref.read(saveWalletProvider)(entity);
                result = entity;
                if (context.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save wallet: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  return result;
}

String _prettyType(WalletType t) {
  switch (t) {
    case WalletType.cash:
      return 'Cash';
    case WalletType.bkash:
      return 'bKash';
    case WalletType.nagad:
      return 'Nagad';
    case WalletType.bank:
      return 'Bank';
    case WalletType.upay:
      return 'Upay';
    case WalletType.rocket:
      return 'Rocket';
    case WalletType.others:
      return 'Others';
  }
}
