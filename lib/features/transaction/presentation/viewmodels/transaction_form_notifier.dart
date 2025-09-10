
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';

/// Public provider
final transactionFormProvider =
    StateNotifierProvider.autoDispose<
      TransactionFormNotifier,
      TransactionFormState
    >((ref) => TransactionFormNotifier());

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  TransactionFormNotifier() : super(TransactionFormState.initial());

  // ------------------------------ Init / Hydration ------------------------------

  /// Smart initialize for edit-mode. Derives [externalTransfer] from entity fields.
  void initializeForm(TransactionEntity? e) {
    if (e == null) return;

    final bool isTransfer = e.type == TransactionType.transfer;
    final bool hasTargetWallet =
        (e.targetWalletId != null && e.targetWalletId!.isNotEmpty);
    final bool hasTransferTo =
        (e.transferTo != null && e.transferTo!.trim().isNotEmpty);

    final bool external = isTransfer && !hasTargetWallet && hasTransferTo;

    _setIfChanged(
      state.copyWith(
        type: e.type,
        amount: e.amount,
        categoryId: e.categoryId,
        dateUtc: e.date.toUtc(),
        currency: e.currency,
        tags: e.tags ?? const [],
        walletId: e.walletId,
        targetWalletId: e.targetWalletId,
        transferTo: e.transferTo,
        externalTransfer: external,
      ),
    );

    _fixTransferConsistency();
  }

  /// Replace the whole form state (guaranteeing UTC date).
  void updateForm(TransactionFormState next) {
    _setIfChanged(next.copyWith(dateUtc: next.dateUtc.toUtc()));
    _fixTransferConsistency();
  }

  /// JSON hydration (useful for drafts).
  void loadFromJson(Map<String, dynamic> json) {
    final next = TransactionFormState.fromJson(json);
    updateForm(next);
  }

  /// Reset to initial pristine state (useful after submit).
  void reset() => _setIfChanged(TransactionFormState.initial());

  // ------------------------------ Type & Category ------------------------------

  void setType(TransactionType t) {
    if (t == state.type) return;
    _setIfChanged(state.copyWith(type: t));
    _fixTransferConsistency();

    // Auto-pick category for the selected type when not set.
    if (state.categoryId == null) {
      resetCategory(kindFromTxType(t));
    }
  }

  void toggleIncomeExpense() {
    final next = state.type == TransactionType.expense
        ? TransactionType.income
        : TransactionType.expense;
    setType(next);
  }

  void setCategoryId(String id) {
    if (id == state.categoryId) return;
    _setIfChanged(state.copyWith(categoryId: id));
  }

  void clearCategory() => _setIfChanged(state.copyWith(categoryId: null));

  void resetCategory(CategoryKind kind) {
    final first = defaultCategoriesByKind(kind).first;
    if (state.categoryId == first.id) return;
    _setIfChanged(state.copyWith(categoryId: first.id));
  }

  // ------------------------------ Date / Currency ------------------------------

  void setDateUtc(DateTime d) {
    final normalized = d.toUtc();
    if (normalized == state.dateUtc) return;
    _setIfChanged(state.copyWith(dateUtc: normalized));
  }

  void setCurrency(String c) {
    if (c == state.currency || c.trim().isEmpty) return;
    _setIfChanged(state.copyWith(currency: c));
  }

  // ------------------------------ Amount ------------------------------

  void setAmount(double value) {
    final v = (value.isNaN || value.isInfinite) ? 0.0 : value;
    final abs = v.abs();
    if (abs == state.amount) return;
    _setIfChanged(state.copyWith(amount: abs));
  }

  // ------------------------------ Notes / Tags ------------------------------

  void setNote(String? note) {
    final v = note?.trim();
    if (v == (state.note?.trim())) return;
    _setIfChanged(state.copyWith(note: (v?.isEmpty ?? true) ? null : v));
  }

  void addTag(String t) {
    final v = t.trim();
    if (v.isEmpty || state.tags.contains(v)) return;
    _setIfChanged(state.copyWith(tags: [...state.tags, v]));
  }

  void removeTag(String t) {
    final v = t.trim();
    if (!state.tags.contains(v)) return;
    _setIfChanged(
      state.copyWith(tags: state.tags.where((x) => x != v).toList()),
    );
  }

  void clearTags() {
    if (state.tags.isEmpty) return;
    _setIfChanged(state.copyWith(tags: const []));
  }

  void setTags(List<String> tags) {
    final dedup = {for (final s in tags) s.trim()}
      ..removeWhere((e) => e.isEmpty);
    if (_listEquals(dedup.toList(), state.tags)) return;
    _setIfChanged(state.copyWith(tags: dedup.toList()));
  }

  bool hasTag(String t) => state.tags.contains(t.trim());

  // ------------------------------ Wallets / Transfer ------------------------------

  void setWalletId(String id) {
    if (id == state.walletId) return;
    _setIfChanged(state.copyWith(walletId: id));
  }

  /// INTERNAL transfer (wallet → wallet in app)
  void setTargetWalletId(String? id) {
    if (state.type != TransactionType.transfer) {
      if (state.targetWalletId != null) {
        _setIfChanged(state.copyWith(targetWalletId: null));
      }
      return;
    }

    final normalized = (id?.isEmpty ?? true) ? null : id;
    if (normalized == state.targetWalletId &&
        state.transferTo == null &&
        state.externalTransfer == false) {
      return;
    }

    _setIfChanged(
      state.copyWith(
        targetWalletId: normalized,
        transferTo: null, // mutually exclusive
        externalTransfer: false, // internal mode
      ),
    );
  }

  /// Toggle helpers used by the UI chips.
  void enableInternalTransfer() {
    if (!state.externalTransfer && state.transferTo == null) return;
    _setIfChanged(state.copyWith(externalTransfer: false, transferTo: null));
  }

  void enableExternalTransfer([String? seed = '']) {
    final payload = (seed ?? state.transferTo ?? '').trim();
    if (state.externalTransfer && state.transferTo == payload) return;
    _setIfChanged(
      state.copyWith(
        externalTransfer: true,
        targetWalletId: null,
        transferTo: payload.isEmpty ? null : payload,
      ),
    );
  }

  /// EXTERNAL transfer (wallet → someone/bank/mobile wallet)
  void setTransferTo(String? value) {
    if (state.type != TransactionType.transfer) {
      if (state.transferTo != null || state.externalTransfer) {
        _setIfChanged(
          state.copyWith(transferTo: null, externalTransfer: false),
        );
      }
      return;
    }

    final v = (value ?? '').trim();
    final newTo = v.isEmpty ? null : v;

    if (newTo == state.transferTo && state.externalTransfer) return;

    _setIfChanged(
      state.copyWith(
        transferTo: newTo,
        targetWalletId: null, // mutually exclusive
        externalTransfer: newTo != null,
      ),
    );
  }

  void resetWallets() {
    if (state.walletId == null &&
        state.targetWalletId == null &&
        state.transferTo == null &&
        !state.externalTransfer) {
      return;
    }

    _setIfChanged(
      state.copyWith(
        walletId: null,
        targetWalletId: null,
        transferTo: null,
        externalTransfer: false,
      ),
    );
  }

  // ------------------------------ Validation ------------------------------

  String? quickValidate() {
    if (state.amount <= 0) return null; // amount handled in UI with i18n

    if (state.walletId == null || state.walletId!.isEmpty) {
      return 'Wallet is required';
    }

    if (state.type == TransactionType.transfer) {
      final hasInternal =
          state.targetWalletId != null && state.targetWalletId!.isNotEmpty;
      final hasExternal =
          state.transferTo != null && state.transferTo!.trim().isNotEmpty;

      if (!hasInternal && !hasExternal) {
        return 'Choose a target wallet or enter a recipient';
      }
      if (hasInternal && state.walletId == state.targetWalletId) {
        return 'Source and target wallet cannot be same';
      }
    }

    if (state.categoryId == null || state.categoryId!.isEmpty) {
      return 'Category is required';
    }

    return null; // OK
  }

  // ------------------------------ Internals ------------------------------

  /// Centralized guard so non-changes don't rebuild the world.
  void _setIfChanged(TransactionFormState next) {
    if (identical(next, state) || next == state) return;
    state = next;
  }

  void _fixTransferConsistency() {
    // When leaving transfer type → drop transfer-only fields.
    if (state.type != TransactionType.transfer) {
      if (state.targetWalletId != null ||
          state.transferTo != null ||
          state.externalTransfer) {
        _setIfChanged(
          state.copyWith(
            targetWalletId: null,
            transferTo: null,
            externalTransfer: false,
          ),
        );
      }
      return;
    }

    // When transfer type: enforce mutual exclusivity.
    final hasInternal =
        state.targetWalletId != null && state.targetWalletId!.isNotEmpty;
    final hasExternal =
        state.transferTo != null && state.transferTo!.trim().isNotEmpty;

    if (hasInternal && hasExternal) {
      // Prefer the most recent intent: if external flag true → keep external.
      if (state.externalTransfer) {
        _setIfChanged(state.copyWith(targetWalletId: null));
      } else {
        _setIfChanged(state.copyWith(transferTo: null));
      }
    }

    // If neither present but flag says external → keep empty external mode
    // (this lets the UI show the external field and focus it).
    if (!hasInternal && !hasExternal && !state.externalTransfer) {
      // remain internal w/ nothing selected; no-op
    }
  }

  // tiny util: a simple list equality for tags
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
