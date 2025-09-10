import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/month_args.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_computed_providers.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_usecases_providers.dart';
import 'package:pocketa/shared/widgets/more_menu.dart';
import 'package:uuid/uuid.dart';

import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/core/utils/currency_utils.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/shared/widgets/widgets.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/core/sync/sync_queue.dart';

import 'package:pocketa/features/categories/presentations/widgets/category_chips_picker.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/viewmodels.dart';
import 'package:pocketa/features/wallets/domain/entities/wallet_entity.dart';
import 'package:pocketa/features/wallets/presentations/viewmodels/wallet_providers.dart';
import 'package:pocketa/features/wallets/presentations/widgets/wallet_picker_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  late final TextEditingController _recipientCtrl;
  late final FocusNode _recipientFocus;
  late final FocusNode _amountFocus;

  // subscriptions
  late ProviderSubscription<TransactionFormState> _typeSub;
  late ProviderSubscription<TransactionFormState> _formSub;
  late ProviderSubscription<AsyncValue<List<WalletEntity>>> _walletsSub;

  VoidCallback? _amountCtrlListener;
  String? _inlineError;

  @override
  void initState() {
    super.initState();

    _amountCtrl = TextEditingController(
      text: widget.initial?.amount.toString() ?? '',
    );
    _noteCtrl = TextEditingController(text: widget.initial?.note ?? '');
    _tagCtrl = TextEditingController();
    _recipientCtrl = TextEditingController(
      text: widget.initial?.transferTo ?? '',
    );
    _recipientFocus = FocusNode();
    _amountFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionFormProvider.notifier).initializeForm(widget.initial);
      _ensureDefaultsOnce();
    });

    // Amount controller → provider (only if value changed)
    _amountCtrlListener = () {
      final raw = _amountCtrl.text.replaceAll(',', '');
      final parsed = double.tryParse(raw) ?? 0.0;
      final current = ref.read(transactionFormProvider).amount;
      if (parsed != current) {
        scheduleMicrotask(() {
          if (!mounted) return;
          ref.read(transactionFormProvider.notifier).setAmount(parsed);
        });
      }
    };
    _amountCtrl.addListener(_amountCtrlListener!);

    // Type change → reset category; clear transfer-only when leaving transfer
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
        if (next.type != TransactionType.transfer) {
          FocusScope.of(context).unfocus();
          ref.read(transactionFormProvider.notifier).setTransferTo(null);
          ref.read(transactionFormProvider.notifier).setTargetWalletId(null);
          _recipientCtrl.clear();
        }
      }
    });

    // Clear inline error on any form mutation
    _formSub = ref.listenManual<TransactionFormState>(transactionFormProvider, (
      _,
      __,
    ) {
      if (_inlineError != null) {
        setState(() => _inlineError = null);
      }
    });

    // When wallets arrive & none chosen → set default once
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

    // Wallet default (snapshot)
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

    // Category default by type
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
    if (_amountCtrlListener != null) {
      _amountCtrl.removeListener(_amountCtrlListener!);
      _amountCtrlListener = null;
    }
    _amountCtrl.dispose();
    _amountFocus.dispose();
    _noteCtrl.dispose();
    _tagCtrl.dispose();
    _recipientCtrl.dispose();
    _recipientFocus.dispose();
    _typeSub.close();
    _formSub.close();
    _walletsSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(transactionFormProvider);
    final isEdit = widget.initial != null;

    final w = context.vw;
    final isWide = w >= 900;

    // Header KPI (safe: wallet can be null)
    final now = DateTime.now();
    final args = MonthArgs(y: now.year, m: now.month, walletId: form.walletId);
    final netBalance = ref.watch(monthNetRxProvider(args));
    final isPositive = ref.watch(isMonthNetPositiveProvider(args));

    final signedPreview =
        form.type == TransactionType.expense ? -form.amount : form.amount;
    final previewText = formatAmount(
      signedPreview,
      currency: AppCurrencies.symbol(form.currency),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit
            ? AppLocalizations.of(context).editTransaction
            : AppLocalizations.of(context).addTransaction,
        subtitle: formatDate(now),
        showBack: true,
        actions: [
          MoreMenu(
            onDelete: isEdit ? () => _confirmDelete(widget.initial!.id) : null,
          ),
        ],
        trailingPillText: formatAmount(netBalance),
        trailingPillIcon: isPositive
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded,
        trailingPillColor: isPositive ? Colors.green : Colors.red,
        accentColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // inline error banner
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _inlineError == null
                ? const SizedBox(height: 0)
                : Container(
                    key: const ValueKey('error'),
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _inlineError!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(context).close,
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _inlineError = null),
                        ),
                      ],
                    ),
                  ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: isWide ? _buildWide(form) : _buildNarrow(form),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: _accentByType(form.type)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  previewText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _accentByType(form.type),
                      ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: Text(isEdit
                    ? AppLocalizations.of(context).save
                    : AppLocalizations.of(context).addTransaction),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- Layouts -----------------
  Widget _buildNarrow(TransactionFormState form) {
    final L = context.layout;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: L.insetsOnly(l: 2, t: 1.5, r: 2, b: 2),
      children: [
        _typeCard(form),
        _amountCard(form),
        _quickAmountChips(form),
        _categoryCard(form),
        _detailsCard(form),
        if (form.type == TransactionType.transfer) _transferTargetCard(form),
        _notesCard(form),
        SizedBox(height: L.space3xl),
      ],
    );
  }

  Widget _buildWide(TransactionFormState form) {
    final L = context.layout;
    final cols = L.columnsFor(480);
    final cross = cols < 2 ? 2 : (cols > 3 ? 3 : cols);

    final cards = <Widget>[
      _typeCard(form),
      _amountCard(form),
      _categoryCard(form),
      _detailsCard(form),
    ];

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: L.insetsSymmetric(h: 2, v: 1.5),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: cross,
            mainAxisSpacing: L.spaceL,
            crossAxisSpacing: L.spaceL,
            childCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          ),
        ),
        SliverPadding(
          padding: L.insetsSymmetric(h: 2),
          sliver: SliverToBoxAdapter(child: _transferTargetCard(form)),
        ),
        SliverPadding(
          padding: L.insetsAll(2),
          sliver: SliverToBoxAdapter(child: _notesCard(form)),
        ),
        SliverToBoxAdapter(child: SizedBox(height: L.space3xl)),
      ],
    );
  }

  // ----------------- Cards -----------------
  Widget _typeCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);
    return SectionCard(
      title: AppLocalizations.of(context).type,
      trailing: IconButton(
        icon: const Icon(Icons.flip),
        onPressed: notifier.toggleIncomeExpense,
      ),
      children: [
        SegmentedButton<TransactionType>(
          segments: [
            ButtonSegment(
              value: TransactionType.income,
              label: Text(AppLocalizations.of(context).incomeType),
              icon: Icon(Icons.arrow_downward_rounded),
            ),
            ButtonSegment(
              value: TransactionType.expense,
              label: Text(AppLocalizations.of(context).expenseType),
              icon: Icon(Icons.arrow_upward_rounded),
            ),
            ButtonSegment(
              value: TransactionType.transfer,
              label: Text(AppLocalizations.of(context).transfer),
              icon: Icon(Icons.swap_horiz_rounded),
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
        final dropW = targetDropW.clamp(70.0, c.maxWidth * 0.30).toDouble();
        final canRow = c.maxWidth >= (dropW + gap + 200.0);

        final amountField = Expanded(
          child: AmountField(
            controller: _amountCtrl,
            label: AppLocalizations.of(context).amount,
            currencySymbol: AppCurrencies.symbol(form.currency),
          ),
        );

        final currencyField = SizedBox(
          width: dropW,
          child: AppDropdownField<String>(
            label: AppLocalizations.of(context).currency,
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
            validator: (v) => v == null
                ? AppLocalizations.of(context)
                    .errorRequired(AppLocalizations.of(context).currency)
                : null,
            isDense: true,
          ),
        );

        final color = _accentByType(form.type);

        return SectionCard(
          title: AppLocalizations.of(context).amount,
          trailing: IconButton(
            tooltip: AppLocalizations.of(context).clear,
            icon: const Icon(Icons.clear),
            onPressed: () {
              _amountCtrl.clear();
              nf.setAmount(0);
              HapticFeedback.selectionClick();
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
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _amountCtrl,
              builder: (context, value, _) {
                final parsed =
                    double.tryParse(value.text.replaceAll(',', '')) ?? 0;
                final signed =
                    form.type == TransactionType.expense ? -parsed : parsed;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Row(
                    key: ValueKey('${form.type}-$parsed-${form.currency}'),
                    children: [
                      Icon(Icons.equalizer_rounded, color: color),
                      const SizedBox(width: 6),
                      Text(
                        formatAmount(
                          signed,
                          currency: AppCurrencies.symbol(form.currency),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _quickAmountChips(TransactionFormState form) {
    final nf = ref.read(transactionFormProvider.notifier);
    const amounts = <int>[100, 200, 500, 1000, 2000, 5000];

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: -6,
        children: [
          for (final a in amounts)
            ActionChip(
              label: Text(
                formatAmount(
                  form.type == TransactionType.expense
                      ? -a.toDouble()
                      : a.toDouble(),
                  currency: AppCurrencies.symbol(form.currency),
                ),
              ),
              onPressed: () {
                _amountCtrl.text = a.toString();
                nf.setAmount(a.toDouble());
                HapticFeedback.lightImpact();
              },
            ),
        ],
      ),
    );
  }

  Widget _categoryCard(TransactionFormState form) {
    final nf = ref.read(transactionFormProvider.notifier);
    final kind = kindFromTxType(form.type);

    return SectionCard(
      title: AppLocalizations.of(context).category,
      subtitle: AppLocalizations.of(context).tapToSelect,
      trailing: IconButton(
        tooltip: AppLocalizations.of(context).reset,
        icon: const Icon(Icons.restart_alt),
        onPressed: () {
          final list = defaultCategoriesByKind(kind);
          if (list.isNotEmpty) {
            nf.setCategoryId(list.first.id);
            HapticFeedback.selectionClick();
          }
        },
      ),
      children: [
        CategoryChipsPicker(
          kind: kind,
          selectedId: form.categoryId,
          onSelected: (c) {
            nf.setCategoryId(c.id);
            HapticFeedback.selectionClick();
          },
        ),
      ],
    );
  }

  Widget _detailsCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);

    return SectionCard(
      title: AppLocalizations.of(context).details,
      subtitle: AppLocalizations.of(context).detailsSubtitle,
      trailing: IconButton(
        tooltip: AppLocalizations.of(context).setNow,
        onPressed: () {
          notifier.setDateUtc(DateTime.now().toUtc());
          HapticFeedback.selectionClick();
        },
        icon: const Icon(Icons.schedule),
      ),
      children: [
        const SizedBox(height: 8),
        AppDateTimeField(
          label: AppLocalizations.of(context).dateTime,
          valueUtc: form.dateUtc,
          onChanged: notifier.setDateUtc,
        ),
        const SizedBox(height: 12),
        WalletPickerButton(
          walletId: form.walletId,
          label: AppLocalizations.of(context).wallet,
          onSelected: (w) => notifier.setWalletId(w.id),
        ),
      ],
    );
  }

  Widget _transferTargetCard(TransactionFormState form) {
    if (form.type != TransactionType.transfer) return const SizedBox.shrink();
    final nf = ref.read(transactionFormProvider.notifier);

    final isExternal = form.externalTransfer;
    final isInternal = !isExternal;

    return SectionCard(
      title: AppLocalizations.of(context).transferTo,
      subtitle: AppLocalizations.of(context).transferChoiceHelp,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(AppLocalizations.of(context).anotherWallet),
              selected: isInternal,
              onSelected: (sel) {
                if (!sel) return;
                FocusScope.of(context).unfocus();
                nf.enableInternalTransfer();
                HapticFeedback.selectionClick();
              },
            ),
            ChoiceChip(
              label: Text(AppLocalizations.of(context).someoneAccount),
              selected: isExternal,
              onSelected: (sel) {
                if (!sel) return;
                nf.enableExternalTransfer(_recipientCtrl.text);
                // Focus after the field is mounted
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _recipientFocus.requestFocus();
                });
                HapticFeedback.selectionClick();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(sizeFactor: anim, child: child),
          ),
          child: isInternal
              ? WalletPickerButton(
                  key: const ValueKey('internal'),
                  walletId: form.targetWalletId,
                  label: AppLocalizations.of(context).targetWallet,
                  onSelected: (w) => nf.setTargetWalletId(w.id),
                )
              : TextFormField(
                  key: const ValueKey('external'),
                  controller: _recipientCtrl,
                  focusNode: _recipientFocus,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).recipientLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: AppLocalizations.of(context).recipientHint,
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  onChanged: (v) => nf.setTransferTo(v),
                ),
        ),
      ],
    );
  }

  Widget _notesCard(TransactionFormState form) {
    final notifier = ref.read(transactionFormProvider.notifier);
    return SectionCard(
      title: AppLocalizations.of(context).notesAndTags,
      subtitle: AppLocalizations.of(context).optional,
      trailing: IconButton(
        tooltip: AppLocalizations.of(context).clearAllTags,
        icon: const Icon(Icons.clear_all),
        onPressed: () {
          notifier.clearTags();
          HapticFeedback.selectionClick();
        },
      ),
      children: [
        NoteField(controller: _noteCtrl),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).addTag,
                  prefixIcon: const Icon(Icons.tag_outlined),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (v) {
                  notifier.addTag(v.trim());
                  _tagCtrl.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: AppLocalizations.of(context).addTag,
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

  // ----------------- Submit / Delete -----------------
  Future<void> _submit() async {
    HapticFeedback.selectionClick();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final form = ref.read(transactionFormProvider);

    final msg = ref.read(transactionFormProvider.notifier).quickValidate();
    if (msg != null) {
      setState(() => _inlineError = msg);
      return;
    }

    var resolvedAmount = form.amount;
    if (resolvedAmount <= 0 && _amountCtrl.text.isNotEmpty) {
      resolvedAmount =
          double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    }
    if (resolvedAmount <= 0) {
      setState(() =>
          _inlineError = AppLocalizations.of(context).errorAmountPositive);
      return;
    }

    final isEdit = widget.initial != null;
    final id = isEdit ? widget.initial!.id : const Uuid().v4();

    final entity = TransactionEntity(
      id: id,
      amount: resolvedAmount,
      date: form.dateUtc,
      type: form.type,
      categoryId: form.categoryId!,
      walletId: form.walletId!,
      targetWalletId:
          form.type == TransactionType.transfer ? form.targetWalletId : null,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      tags: form.tags,
      currency: form.currency,
      createdAt: widget.initial?.createdAt ?? DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      isSynced: false,
      attachmentUrl: widget.initial?.attachmentUrl,
      isDeleted: false,
      transferTo: form.type == TransactionType.transfer
          ? form.transferTo?.trim()
          : null,
    );

    await ref.read(upsertTxUCProvider).call(entity);
    // enqueue for background sync
    ref.read(syncQueueProvider).enqueueTransactionUpsert(entity);
    if (!mounted) return;

    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context);
    _toast(isEdit ? l10n.transactionUpdated : l10n.transactionAdded);
    await ref.read(analyticsProvider).logEvent(
      isEdit ? 'txn_edited' : 'txn_added',
      params: {
        'type': form.type.name,
        'amount': resolvedAmount,
      },
    );
    context.canPop() ? context.pop() : context.goNamed('transactions');
  }

  Future<void> _confirmDelete(String id) async {
    final sure = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(ctx).deleteTransaction),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(AppLocalizations.of(ctx).cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(AppLocalizations.of(ctx).delete),
              ),
            ],
          ),
        ) ??
        false;

    if (!sure) return;

    try {
      await ref.read(deleteTxSoftUCProvider).call(id);
      ref.read(syncQueueProvider).enqueueTransactionDelete(id);
      if (!mounted) return;
      _toast(AppLocalizations.of(context).transactionDeleted);
      await ref.read(analyticsProvider).logEvent('txn_deleted', params: {
        'id': id,
      });
      context.canPop() ? context.pop() : context.goNamed('transactions');
    } catch (e) {
      if (!mounted) return;
      _toast(AppLocalizations.of(context).errorGeneric);
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

  static Color _accentByType(TransactionType t) {
    switch (t) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blueGrey;
    }
  }
}
