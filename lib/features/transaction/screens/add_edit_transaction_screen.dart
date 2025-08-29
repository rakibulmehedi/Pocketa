import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:pocketa/application/transaction/providers/transaction_form_notifier.dart';
import 'package:pocketa/application/transaction/providers/transaction_provider.dart';
import 'package:pocketa/application/transaction/transaction_form_state.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/core/utils/currency_utils.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';

import 'package:pocketa/widgets/custom_app_bar.dart';
import 'package:pocketa/widgets/section_card.dart';

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
  ConsumerState<AddEditTransactionScreen> createState() => _TxScreenState();
}

class _TxScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _walletCtrl;
  late final TextEditingController _targetWalletCtrl;
  late final TextEditingController _tagCtrl;

  @override
  void initState() {
    super.initState();

    // Hydrate provider with initial (edit mode)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionFormProvider.notifier).initializeForm(widget.initial);
    });

    // Prime controllers
    _amountCtrl = TextEditingController(
      text: widget.initial?.amount.toString() ?? '',
    );
    _noteCtrl = TextEditingController(text: widget.initial?.note ?? '');
    _walletCtrl = TextEditingController(
      text: widget.initial?.walletId ?? 'Default',
    );
    _targetWalletCtrl = TextEditingController(
      text: widget.initial?.targetWalletId ?? '',
    );
    _tagCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _walletCtrl.dispose();
    _targetWalletCtrl.dispose();
    _tagCtrl.dispose();
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
            onPressed: () => _amountCtrl.clear(),
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

            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _amountCtrl,
              builder: (context, value, _) {
                final raw = double.tryParse(value.text) ?? 0;
                final signed = form.type == TransactionType.expense
                    ? -raw
                    : raw;
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
                      formatAmount(signed, currency: form.currency),
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
    return SectionCard(
      title: 'Category',
      trailing: IconButton(
        tooltip: 'Reset',
        icon: const Icon(Icons.restart_alt),
        onPressed: nf.resetCategory,
      ),
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Wrap(
            spacing: 8,
            runSpacing: -6,
            children: Category.values.map((c) {
              final selected = form.category == c;
              return ChoiceChip(
                label: Text(prettyCategory(c)),
                selected: selected,
                onSelected: (_) => nf.setCategory(c),
                avatar: selected ? const Icon(Icons.check, size: 16) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }).toList(),
          ),
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
        AppDateTimeField(
          label: 'Date & Time',
          valueUtc: form.dateUtc,
          onChanged: notifier.setDateUtc,
        ),
        const SizedBox(height: 12),
        AppTextFormField(
          label: 'Wallet',
          controller: _walletCtrl,
          prefixIcon: Icons.account_balance_wallet_outlined,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: form.type == TransactionType.transfer
              ? Column(
                  key: const ValueKey('target'),
                  children: [
                    const SizedBox(height: 12),
                    AppTextFormField(
                      label: 'Target Wallet',
                      controller: _targetWalletCtrl,
                      prefixIcon: Icons.call_made_outlined,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('no_target')),
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
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount');
      return;
    }
    if (form.type == TransactionType.transfer &&
        _targetWalletCtrl.text.trim().isEmpty) {
      _snack('Target wallet is required for transfer');
      return;
    }

    final isEdit = widget.initial != null;
    final id = isEdit ? widget.initial!.id : const Uuid().v4();

    final entity = TransactionEntity(
      id: id,
      amount: amount,
      date: form.dateUtc,
      type: form.type,
      category: form.category,
      walletId: _walletCtrl.text.trim(),
      targetWalletId: form.type == TransactionType.transfer
          ? _targetWalletCtrl.text.trim()
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
