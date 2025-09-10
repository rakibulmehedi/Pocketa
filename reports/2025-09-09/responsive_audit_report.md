# Responsive & Performance Audit — Pocketa

Summary of centralized responsiveness, i18n enforcement, and list optimizations completed today.

## Metrics
- MediaQuery replaced: 1 (viewInsets → context.layout.viewInsetsBottom)
- EdgeInsets magic numbers replaced: 5 (moved to layout.insets*/space*)
- New i18n keys added: 5 (wallet providers + preset)
- Lists optimized: 1 (stable keys + explicit childCount)
- Responsive imports added: 2 (wallet sheet, transaction tile)

## Key Changes (Before → After)
1) MediaQuery.viewInsets
- Before: `final insets = MediaQuery.of(context).viewInsets; Padding(... bottom: insets.bottom)`
- After: `final L = context.layout; Padding(... bottom: L.viewInsetsBottom)`

2) EdgeInsets magic paddings
- Before: `EdgeInsets.fromLTRB(16, 16, 16, 20)`
- After: `L.insetsOnly(l: 2, t: 2, r: 2, b: 2.5)`

3) Transaction list stability
- Before: `SliverPrototypeExtentList(delegate: SliverChildBuilderDelegate(...))` (no childCount/keys)
- After: `SliverPrototypeExtentList(..., childCount: (list.length*2)-1, ... ValueKey(tx.id))`

4) Tile paddings
- Before: `contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4)`
- After: `contentPadding: L.insetsSymmetric(h: 2, v: 0.5)`

5) i18n for wallet brands
- Before: hardcoded: 'bKash', 'Nagad', 'Bank A/C'
- After: `l10n.wallet_bkash`, `l10n.wallet_nagad`, `l10n.wallet_preset_bank_ac`

## Files Updated
- lib/features/transaction/presentation/widgets/transaction_list_view.dart
- lib/features/transaction/presentations/widgets/transaction_tile.dart
- lib/features/wallets/presentations/widgets/add_wallet_sheet.dart
- lib/l10n/app_en.arb, lib/l10n/app_bn.arb (new keys)

## Still To Tackle (follow-ups)
- Replace remaining EdgeInsets magic numbers in add_edit_transaction_screen.dart with layout helpers.
- Audit other widgets for hardcoded Text strings and move into ARB.
- Consider RepaintBoundary for any heavy charts once added.

