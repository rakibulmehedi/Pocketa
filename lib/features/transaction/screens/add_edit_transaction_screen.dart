import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/widgets/custom_app_bar.dart';
import 'package:uuid/uuid.dart';

import 'package:pocketa/widgets/section_card.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/core/utils/currency_utils.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/providers/transaction_provider.dart';

// Inputs
import 'package:pocketa/widgets/input/app_amount_field.dart';
import 'package:pocketa/widgets/input/app_date_time_field.dart';
import 'package:pocketa/widgets/input/app_dropdown.dart';
import 'package:pocketa/widgets/input/app_note_field.dart';
import 'package:pocketa/widgets/input/app_text_form_field.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionEntity? initial;
  const AddEditTransactionScreen({super.key, this.initial});

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _walletController = TextEditingController();
  final _targetWalletController = TextEditingController();
  final _tagController = TextEditingController();

  // Local state
  final List<String> _tags = [];
  late TransactionType _type;
  late Category _category;
  late DateTime _dateUtc;
  String _currency = 'BDT';

  @override
  void initState() {
    super.initState();
    final init = widget.initial;

    if (init == null) {
      _type = TransactionType.expense;
      _category = Category.eatingOut;
      _dateUtc = DateTime.now().toUtc();
      _walletController.text = 'default';
      _currency = 'BDT';
    } else {
      _type = init.type;
      _category = init.category;
      _dateUtc = init.date;
      _amountController.text = init.amount.toString();
      _noteController.text = init.note ?? '';
      _walletController.text = init.walletId;
      _targetWalletController.text = init.targetWalletId ?? '';
      _currency = init.currency;
      _tags.addAll(init.tags ?? const []);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _walletController.dispose();
    _targetWalletController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showSnack('Enter a valid number');
      return;
    }
    if (_type == TransactionType.transfer &&
        _targetWalletController.text.trim().isEmpty) {
      _showSnack('Target wallet is required for transfer');
      return;
    }

    final isEdit = widget.initial != null;
    final id = isEdit ? widget.initial!.id : const Uuid().v4();

    final entity = TransactionEntity(
      id: id,
      amount: amount,
      date: _dateUtc,
      type: _type,
      category: _category,
      walletId: _walletController.text.trim(),
      targetWalletId: _type == TransactionType.transfer
          ? _targetWalletController.text.trim()
          : null,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      tags: _tags,
      currency: _currency,
      createdAt: widget.initial?.createdAt ?? DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      isSynced: false,
      attachmentUrl: widget.initial?.attachmentUrl,
      isDeleted: false,
    );

    await ref.read(addTxProvider).call(entity);

    if (!mounted) return;
    _showSnack(isEdit ? 'Transaction updated' : 'Transaction added');
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _addTag() {
    final t = _tagController.text.trim();
    if (t.isEmpty) return;
    setState(() {
      if (!_tags.contains(t)) _tags.add(t);
      _tagController.clear();
    });
  }

  void _clearTags() {
    if (_tags.isEmpty) return;
    setState(() => _tags.clear());
  }

  void _resetCategoryToDefault() {
    setState(() => _category = Category.eatingOut);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: (isEdit ? 'Edit Transaction' : 'Add Transaction'),
        showBack: true,
        actions: [
          if (isEdit)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Transaction?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref.read(deleteTxProvider).call(widget.initial!.id);
                  if (!mounted) return;
                  _showSnack('Deleted');
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                }
              },
            ),
        ],
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            // TYPE
            SectionCard(
              title: 'Type',
              trailing: IconButton(
                tooltip: 'Toggle Expense/Income',
                icon: const Icon(Icons.flip),
                onPressed: () {
                  setState(() {
                    _type = _type == TransactionType.expense
                        ? TransactionType.income
                        : TransactionType.expense;
                  });
                },
              ),
              children: [
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.income,
                      icon: Icon(Icons.arrow_downward),
                      label: Text('Income'),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      icon: Icon(Icons.arrow_upward),
                      label: Text('Expense'),
                    ),
                    ButtonSegment(
                      value: TransactionType.transfer,
                      icon: Icon(Icons.swap_horiz),
                      label: Text('Transfer'),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                  showSelectedIcon: false,
                ),
              ],
            ),

            // AMOUNT + CURRENCY
            SectionCard(
              title: 'Amount',
              trailing: IconButton(
                tooltip: 'Clear amount',
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _amountController.clear()),
              ),
              children: [
                LayoutBuilder(
                  builder: (ctx, c) {
                    final isNarrow = c.maxWidth < 480;

                    final amountField = AmountField(
                      controller: _amountController,
                      currencySymbol: AppCurrencies.symbol(_currency),
                    );
                    final currencyField = SizedBox(
                      width: 140,
                      child: AppDropdownField<String>(
                        label: 'Currency',
                        value: _currency,
                        items: AppCurrencies.list
                            .map(
                              (code) => DropdownMenuItem(
                                value: code,
                                child: Text(
                                  '${AppCurrencies.symbol(code)} $code',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _currency = v!),
                        validator: (v) => v == null ? 'Required' : null,
                        prefixIcon: Icons.payments_outlined,
                      ),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          amountField,
                          const SizedBox(height: 12),
                          currencyField,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: amountField),
                        const SizedBox(width: 12),
                        currencyField,
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Live signed preview
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Builder(
                    key: ValueKey(
                      '${_type}_${_amountController.text}_$_currency',
                    ),
                    builder: (context) {
                      final raw = double.tryParse(_amountController.text) ?? 0;
                      final signed = _type == TransactionType.expense
                          ? -raw
                          : raw;
                      final color = _type == TransactionType.expense
                          ? Colors.red
                          : (_type == TransactionType.income
                                ? Colors.green
                                : Colors.blueGrey);
                      return Row(
                        children: [
                          Icon(Icons.equalizer_rounded, color: color),
                          const SizedBox(width: 6),
                          Text(
                            formatAmount(signed, currency: _currency),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            // CATEGORY
            SectionCard(
              title: 'Category',
              trailing: IconButton(
                tooltip: 'Reset to default',
                icon: const Icon(Icons.restart_alt),
                onPressed: _resetCategoryToDefault,
              ),
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: -6,
                    children: Category.values.map((c) {
                      final selected = _category == c;
                      return ChoiceChip(
                        label: Text(prettyCategory(c)),
                        selected: selected,
                        onSelected: (_) => setState(() => _category = c),
                        avatar: selected
                            ? const Icon(Icons.check, size: 16)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // DETAILS (DATE, WALLET, TARGET)
            SectionCard(
              title: 'Details',
              trailing: IconButton(
                tooltip: 'Set Now',
                icon: const Icon(Icons.schedule),
                onPressed: () =>
                    setState(() => _dateUtc = DateTime.now().toUtc()),
              ),
              children: [
                AppDateTimeField(
                  label: 'Date & Time',
                  valueUtc: _dateUtc,
                  onChanged: (utc) => setState(() => _dateUtc = utc),
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: _walletController,
                  label: 'Wallet',
                  prefixIcon: Icons.account_balance_wallet_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _type == TransactionType.transfer
                      ? Column(
                          key: const ValueKey('target_wallet'),
                          children: [
                            const SizedBox(height: 12),
                            AppTextFormField(
                              controller: _targetWalletController,
                              label: 'Target Wallet',
                              prefixIcon: Icons.call_made_outlined,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('no_target_wallet'),
                        ),
                ),
              ],
            ),

            // NOTES & TAGS
            SectionCard(
              title: 'Notes & Tags',
              trailing: IconButton(
                tooltip: 'Clear all tags',
                icon: const Icon(Icons.clear_all),
                onPressed: _clearTags,
              ),
              children: [
                NoteField(controller: _noteController),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          hintText: 'Add tag and press Enter',
                          prefixIcon: Icon(Icons.tag_outlined),
                        ),
                        onFieldSubmitted: (_) => _addTag(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Add tag',
                      onPressed: _addTag,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: -6,
                    children: _tags
                        .map(
                          (t) => InputChip(
                            label: Text(t),
                            onDeleted: () => setState(() => _tags.remove(t)),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ],
        ),
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
}
