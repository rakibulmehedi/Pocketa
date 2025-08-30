
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';

class AddWalletDialog extends ConsumerStatefulWidget {
  const AddWalletDialog({super.key});

  @override
  ConsumerState<AddWalletDialog> createState() => _AddWalletDialogState();
}

class _AddWalletDialogState extends ConsumerState<AddWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  WalletType _type = WalletType.cash;
  bool _isDefault = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Wallet'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Wallet name',
                hintText: 'e.g. Cash, bKash, Nagad',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WalletType>(
              value: _type,
              items: WalletType.values
                  .map(
                    (t) =>
                        DropdownMenuItem(value: t, child: Text(_prettyType(t))),
                  )
                  .toList(),
              onChanged: (t) => setState(() => _type = t!),
              decoration: const InputDecoration(
                labelText: 'Type',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              title: const Text('Make default'),
              contentPadding: EdgeInsets.zero,
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

            final entity = WalletEntity(
              id: const Uuid().v4(),
              name: _nameCtrl.text.trim(),
              type: _type,
              isDefault: _isDefault,
              createdAt: DateTime.now().toUtc(),
            );

            try {
              await ref.read(saveWalletProvider)(entity);
              if (context.mounted) Navigator.pop(context, entity);
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save wallet: $e')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
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
}
