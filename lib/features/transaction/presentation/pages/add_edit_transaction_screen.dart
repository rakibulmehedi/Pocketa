// lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/core/utils/currency_utils.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

import 'package:pocketa/features/categories/presentations/widgets/category_chips_picker.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/viewmodels.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';
import 'package:pocketa/features/wallets/presentations/widgets/wallet_picker_button.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionEntity? initial;
  const AddEditTransactionScreen({super.key, this.initial});

  @override
  ConsumerState<AddEditTransactionScreen> createState() => _TxScreenState();
}

class _TxScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _tagCtrl;

  // listeners we remove on dispose
  late ProviderSubscription<TransactionFormState> _typeSub;
  late ProviderSubscription<AsyncValue<List<WalletEntity>>> _walletsSub;
  VoidCallback? _amountCtrlListener;

  @override
  void initState() {
    super.initState();

    // Controllers
    _amountCtrl = TextEditingController(
      text: widget.initial?.amount.toString() ?? '',
    );
    _noteCtrl = TextEditingController(text: widget.initial?.note ?? '');
    _tagCtrl = TextEditingController();

    // 1) Hydrate edit-mode & set initial sensible defaults ONCE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionFormProvider.notifier).initializeForm(widget.initial);
      _ensureDefaultsOnce();
    });

    // 2) Amount controller -> provider (outside build)
    _amountCtrlListener = () {
      final raw = _amountCtrl.text.replaceAll(',', '');
      final parsed = double.tryParse(raw) ?? 0;
      // microtask so this never runs inside current build frame
      scheduleMicrotask(() {
        if (!mounted) return;
        ref.read(transactionFormProvider.notifier).setAmount(parsed);
      });
    };
    _amountCtrl.addListener(_amountCtrlListener!);

    // 3) On type change -> reset category to the first of that kind
    _typeSub = ref.listenManual<TransactionFormState>(transactionFormProvider, (
      prev,
      next,
    ) {
      if (prev?.type != next.type) {
        final kind = kindFromTxType(next.type);
        final list = defaultCategoriesByKind(kind);
        if (list.isNotEmpty) {
          ref
              .read(transactionFormProvider.notifier)
              .setCategoryId(list.first.id);
        }
      }
    });

    // 4) When wallets stream becomes non-empty and wallet not chosen yet → set default
    _walletsSub = ref.listenManual(walletsStreamProvider, (prev, next) {
      next.whenData((list) {
        final f = ref.read(transactionFormProvider);
        if (f.walletId == null && list.isNotEmpty) {
          final def = list.firstWhere(
            (w) => w.isDefault,
            orElse: () => list.first,
          );
          ref.read(transactionFormProvider.notifier).setWalletId(def.id);
        }
      });
    });
  }

  void _ensureDefaultsOnce() {
    final f = ref.read(transactionFormProvider);

    // WALLET default (snapshot)
    if (f.walletId == null) {
      final wallets = ref
          .read(walletsStreamProvider)
          .maybeWhen(data: (l) => l, orElse: () => const <WalletEntity>[]);
      if (wallets.isNotEmpty) {
        final def = wallets.firstWhere(
          (w) => w.isDefault,
          orElse: () => wallets.first,
        );
        ref.read(transactionFormProvider.notifier).setWalletId(def.id);
      }
    }

    // CATEGORY default (by type)
    if (f.categoryId == null) {
      final kind = kindFromTxType(f.type);
      final list = defaultCategoriesByKind(kind);
      if (list.isNotEmpty) {
        ref.read(transactionFormProvider.notifier).setCategoryId(list.first.id);
      }
    }
  }

  @override
  void dispose() {
    _amountCtrlListener?.call; // noop, just to silence analyzer if needed
    _amountCtrl.removeListener(_amountCtrlListener!);
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _tagCtrl.dispose();
    _typeSub.close();
    _walletsSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(transactionFormProvider);
    final isEdit = widget.initial != null;

    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 900;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Transaction' : 'Add Transaction',
        showBack: true,
        onBackTap: () => context.pop(),
        actions: [
          if (isEdit)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final sure =
                    await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete transaction?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => context.pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
                if (!sure) return;

                try {
                  await ref
                      .read(deleteTxProvider)
                      .call(widget.initial!.id, hard: false);
                  if (!mounted) return;
                  _snack('Transaction deleted');
                  context.canPop()
                      ? context.pop()
                      : context.goNamed('transactions');
                } catch (e) {
                  if (!mounted) return;
                  _snack('Delete failed: $e');
                }
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: isWide ? _buildWide(form) : _buildNarrow(form),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: Text(isEdit ? 'Save Changes' : 'Add Transaction'),
          ),
        ),
      ),
    );
  }

  // ----------------- Layouts -----------------

  Widget _buildNarrow(TransactionFormState form) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
    children: [
      _typeCard(form),
      _amountCard(form),
      _categoryCard(form),
      _detailsCard(form),
      _notesCard(form),
    ],
  );

  Widget _buildWide(TransactionFormState form) => CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.08,
          ),
          delegate: SliverChildListDelegate.fixed([
            _typeCard(form),
            _amountCard(form),
            _categoryCard(form),
            _detailsCard(form),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        sliver: SliverToBoxAdapter(child: _notesCard(form)),
      ),
    ],
  );

  // ----------------- Cards -----------------

  Widget _typeCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);
    return SectionCard(
      title: 'Transaction Type',
      trailing: IconButton(
        icon: const Icon(Icons.flip),
        tooltip: 'Toggle',
        onPressed: notifier.toggleIncomeExpense,
      ),
      children: [
        SegmentedButton<TransactionType>(
          segments: const [
            ButtonSegment(
              value: TransactionType.income,
              label: Text('Income'),
              icon: Icon(Icons.arrow_downward),
            ),
            ButtonSegment(
              value: TransactionType.expense,
              label: Text('Expense'),
              icon: Icon(Icons.arrow_upward),
            ),
            ButtonSegment(
              value: TransactionType.transfer,
              label: Text('Transfer'),
              icon: Icon(Icons.swap_horiz),
            ),
          ],
          selected: {form.type},
          onSelectionChanged: (s) => notifier.setType(s.first),
          showSelectedIcon: true,
        ),
      ],
    );
  }

  Widget _amountCard(TransactionFormState form) {
    final nf = ref.read(transactionFormProvider.notifier);

    return LayoutBuilder(
      builder: (context, c) {
        const gap = 12.0;

        double targetDropW;
        if (c.maxWidth < 360) {
          targetDropW = 110;
        } else if (c.maxWidth < 420) {
          targetDropW = 130;
        } else {
          targetDropW = 150;
        }
        final double dropW = targetDropW
            .clamp(70.0, c.maxWidth * 0.30)
            .toDouble();

        final bool canRow = c.maxWidth >= (dropW + gap + 200.0);

        final amountField = Expanded(
          child: AmountField(
            controller: _amountCtrl,
            currencySymbol: AppCurrencies.symbol(form.currency),
            // If your AmountField supports onChanged, keep this; otherwise remove it.
            onChanged: (txt) {
              // already handled by controller listener; keep as NOP or light-parsing if you want
            },
          ),
        );

        final currencyField = SizedBox(
          width: dropW,
          child: AppDropdownField<String>(
            label: 'Currency',
            value: form.currency,
            items: AppCurrencies.list
                .map(
                  (code) => DropdownMenuItem<String>(
                    value: code,
                    child: Text(
                      '${AppCurrencies.symbol(code)} $code',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => nf.setCurrency(v!),
            validator: (v) => v == null ? 'Required' : null,
            isDense: true,
          ),
        );

        return SectionCard(
          title: 'Amount',
          trailing: IconButton(
            tooltip: 'Clear amount',
            icon: const Icon(Icons.clear),
            onPressed: () {
              _amountCtrl.clear();
              nf.setAmount(0);
            },
          ),
          children: [
            if (canRow)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  amountField,
                  const SizedBox(width: gap),
                  Flexible(flex: 0, child: currencyField),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  amountField,
                  const SizedBox(height: gap),
                  currencyField,
                ],
              ),
            const SizedBox(height: 8),

            // Read-only preview (no provider writes here)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _amountCtrl,
              builder: (context, value, _) {
                final parsed =
                    double.tryParse(value.text.replaceAll(',', '')) ?? 0;
                final signed = form.type == TransactionType.expense
                    ? -parsed
                    : parsed;
                final color = form.type == TransactionType.expense
                    ? Colors.red
                    : (form.type == TransactionType.income
                          ? Colors.green
                          : Colors.blueGrey);

                return Row(
                  children: [
                    Icon(Icons.equalizer_rounded, color: color),
                    const SizedBox(width: 6),
                    Text(
                      // symbol pass করুন (আপনার formatter এ symbol/code—যেটা নেয়)
                      formatAmount(
                        signed,
                        currency: AppCurrencies.symbol(form.currency),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _categoryCard(TransactionFormState form) {
    final nf = ref.read(transactionFormProvider.notifier);
    final kind = kindFromTxType(form.type);

    return SectionCard(
      title: 'Category',
      trailing: IconButton(
        tooltip: 'Reset',
        icon: const Icon(Icons.restart_alt),
        onPressed: () {
          final list = defaultCategoriesByKind(kind);
          if (list.isNotEmpty) nf.setCategoryId(list.first.id);
        },
      ),
      children: [
        CategoryChipsPicker(
          kind: kind,
          selectedId: form.categoryId,
          onSelected: (c) => nf.setCategoryId(c.id),
        ),
      ],
    );
  }

  Widget _detailsCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);

    return SectionCard(
      title: 'Details',
      trailing: IconButton(
        tooltip: 'Set Now',
        onPressed: () => notifier.setDateUtc(DateTime.now().toUtc()),
        icon: const Icon(Icons.schedule),
      ),
      children: [
        const SizedBox(height: 8),
        AppDateTimeField(
          label: 'Date & Time',
          valueUtc: form.dateUtc,
          onChanged: notifier.setDateUtc,
        ),
        const SizedBox(height: 12),

        WalletPickerButton(
          walletId: form.walletId,
          label: 'Wallet',
          onSelected: (w) => notifier.setWalletId(w.id),
        ),

        if (form.type == TransactionType.transfer)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: WalletPickerButton(
              walletId: form.targetWalletId,
              label: 'Target Wallet',
              onSelected: (w) => notifier.setTargetWalletId(w.id),
            ),
          ),
      ],
    );
  }

  Widget _notesCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);
    return SectionCard(
      title: 'Notes & Tags',
      trailing: IconButton(
        tooltip: 'Clear all tags',
        icon: const Icon(Icons.clear_all),
        onPressed: notifier.clearTags,
      ),
      children: [
        NoteField(controller: _noteCtrl),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagCtrl,
                decoration: const InputDecoration(
                  hintText: 'Add tag and press Enter',
                  prefixIcon: Icon(Icons.tag_outlined),
                ),
                onFieldSubmitted: (v) {
                  notifier.addTag(v.trim());
                  _tagCtrl.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add tag',
              onPressed: () {
                notifier.addTag(_tagCtrl.text.trim());
                _tagCtrl.clear();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (form.tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: -6,
            children: form.tags
                .map(
                  (t) => InputChip(
                    label: Text(t),
                    onDeleted: () => notifier.removeTag(t),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  // ----------------- Submit -----------------
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final form = ref.read(transactionFormProvider);

    // quick business rules
    final msg = ref.read(transactionFormProvider.notifier).quickValidate();
    if (msg != null) {
      _snack(msg);
      return;
    }

    // resolve amount (state is source of truth; fallback to controller)
    var resolvedAmount = form.amount;
    if (resolvedAmount <= 0 && _amountCtrl.text.isNotEmpty) {
      resolvedAmount =
          double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    }
    if (resolvedAmount <= 0) {
      _snack('Enter a valid amount');
      return;
    }

    // transfer guard (double check)
    if (form.type == TransactionType.transfer &&
        (form.targetWalletId == null || form.targetWalletId!.isEmpty)) {
      _snack('Target wallet is required for transfer');
      return;
    }

    // build entity
    final isEdit = widget.initial != null;
    final id = isEdit ? widget.initial!.id : const Uuid().v4();

    final entity = TransactionEntity(
      id: id,
      amount: resolvedAmount,
      date: form.dateUtc,
      type: form.type,
      categoryId: form.categoryId!, // ensured non-null by validation/defaults
      walletId: form.walletId!,
      targetWalletId: form.type == TransactionType.transfer
          ? form.targetWalletId
          : null,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      tags: form.tags,
      currency: form.currency,
      createdAt: widget.initial?.createdAt ?? DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      isSynced: false,
      attachmentUrl: widget.initial?.attachmentUrl,
      isDeleted: false,
    );

    await ref.read(addTxProvider).call(entity);
    if (!mounted) return;

    _snack(isEdit ? 'Transaction updated' : 'Transaction added');
    context.canPop() ? context.pop() : context.goNamed('transactions');
  }

  void _snack(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}
