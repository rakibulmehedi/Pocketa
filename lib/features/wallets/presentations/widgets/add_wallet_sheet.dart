
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pocketa/l10n/app_localizations.dart';

import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';

Future<WalletEntity?> showAddWalletSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  return showModalBottomSheet<WalletEntity>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _AddWalletSheet(),
  );
}

class _AddWalletSheet extends ConsumerStatefulWidget {
  const _AddWalletSheet();
  @override
  ConsumerState<_AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends ConsumerState<_AddWalletSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  WalletType _type = WalletType.cash;
  bool _isDefault = false;
  bool _saving = false;
  String? _dupError;

  @override
  void initState() {
    super.initState();

    // first wallet => default = true
    final wallets = ref
        .read(walletsStreamProvider)
        .maybeWhen(data: (l) => l, orElse: () => const <WalletEntity>[]);
    _isDefault = wallets.isEmpty;

    // live clear duplicate error + toggle clear icon visibility
    _name.addListener(() {
      if (_dupError != null) {
        setState(() => _dupError = null);
      } else {
        // still trigger rebuild to refresh suffix clear button
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _applyPreset(String name, WalletType t) {
    setState(() {
      _type = t;
      _name.text = name;
      _dupError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    _dupError = null;
    if (!(_form.currentState?.validate() ?? false)) {
      setState(() {});
      return;
    }

    // duplicate-guard (case-insensitive)
    final list = ref
        .read(walletsStreamProvider)
        .maybeWhen(data: (l) => l, orElse: () => const <WalletEntity>[]);
    final exists = list.any(
      (w) => w.name.trim().toLowerCase() == _name.text.trim().toLowerCase(),
    );
    if (exists) {
      setState(() => _dupError = AppLocalizations.of(context).errorValidation);
      return;
    }

    setState(() => _saving = true);

    final entity = WalletEntity(
      id: const Uuid().v4(),
      name: _name.text.trim(),
      type: _type,
      isDefault: _isDefault,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      await ref.read(saveWalletProvider)(entity);
      if (mounted) Navigator.pop(context, entity); // return created wallet
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final insets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: Form(
        key: _form,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            Row(
              children: [
                Text(
                  l10n.addWallet,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Presets
            Wrap(
              spacing: 8,
              runSpacing: -6,
              children: [
                _PresetChip(
                  'Cash',
                  Icons.payments_outlined,
                  () => _applyPreset('Cash', WalletType.cash),
                ),
                _PresetChip(
                  'bKash',
                  Icons.account_balance_wallet_outlined,
                  () => _applyPreset('bKash', WalletType.bkash),
                ),
                _PresetChip(
                  'Nagad',
                  Icons.account_balance_wallet_outlined,
                  () => _applyPreset('Nagad', WalletType.nagad),
                ),
                _PresetChip(
                  'Bank',
                  Icons.account_balance_outlined,
                  () => _applyPreset('Bank A/C', WalletType.bank),
                ),
              ],
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.walletName,
                hintText: l10n.walletNameHint,
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                suffixIcon: _name.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_name.clear),
                      ),
                errorText: _dupError,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.errorRequired(l10n.walletName)
                  : null,
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<WalletType>(
              value: _type,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.walletType,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: WalletType.values
                  .map(
                    (t) =>
                        DropdownMenuItem(value: t, child: Text(_prettyType(t))),
                  )
                  .toList(),
              onChanged: (t) => setState(() => _type = t!),
            ),

            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              title: Text(l10n.systemDefault),
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(l10n.save),
            ),
          ],
        ),
      ),
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

class _PresetChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PresetChip(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
