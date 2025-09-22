import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/ui/base_dialog.dart';
import 'package:flow/core/forms/base_form_notifier.dart';
import 'package:flow/core/forms/base_form_state.dart';
import 'package:flow/features/wallets/domain/entities/wallet_entity.dart';
import 'package:flow/features/wallets/presentation/viewmodels/wallet_providers.dart';

/// Form state for wallet dialog
class WalletFormState extends BaseFormState {
  final String name;
  final WalletType type;
  final bool isDefault;

  const WalletFormState({
    super.isLoading,
    super.isValid,
    super.error,
    super.fieldErrors,
    this.name = '',
    this.type = WalletType.cash,
    this.isDefault = false,
  });

  factory WalletFormState.initial() => const WalletFormState();

  @override
  WalletFormState copyWith({
    bool? isLoading,
    bool? isValid,
    String? error,
    Map<String, String>? fieldErrors,
    String? name,
    WalletType? type,
    bool? isDefault,
  }) {
    return WalletFormState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      name: name ?? this.name,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  List<Object?> get props => [
    isLoading,
    isValid,
    error,
    fieldErrors,
    name,
    type,
    isDefault,
  ];
}

/// Form notifier for wallet dialog
class WalletFormNotifier extends BaseFormNotifier<WalletFormState> {
  WalletFormNotifier() : super(WalletFormState.initial());

  @override
  WalletFormState updateLoadingState(WalletFormState state, bool loading) {
    return state.copyWith(isLoading: loading);
  }

  @override
  WalletFormState updateErrorState(WalletFormState state, String? error) {
    return state.copyWith(error: error);
  }

  @override
  WalletFormState updateFieldErrorState(WalletFormState state, String fieldName, String? error) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    if (error == null) {
      newFieldErrors.remove(fieldName);
    } else {
      newFieldErrors[fieldName] = error;
    }
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  WalletFormState clearErrorState(WalletFormState state) {
    return state.copyWith(error: null, fieldErrors: {});
  }

  @override
  WalletFormState clearFieldErrorState(WalletFormState state, String fieldName) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    newFieldErrors.remove(fieldName);
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  WalletFormState updateValidationState(WalletFormState state, bool isValid, Map<String, String> fieldErrors) {
    return state.copyWith(isValid: isValid, fieldErrors: fieldErrors);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
    _validateForm();
  }

  void updateType(WalletType type) {
    state = state.copyWith(type: type);
    _validateForm();
  }

  void updateIsDefault(bool isDefault) {
    state = state.copyWith(isDefault: isDefault);
    _validateForm();
  }

  void _validateForm() {
    final errors = <String, String>{};
    
    if (state.name.trim().isEmpty) {
      errors['name'] = 'Wallet name is required';
    }
    
    state = updateValidationState(state, errors.isEmpty, errors);
  }
}

/// Provider for wallet form notifier
final walletFormNotifierProvider = StateNotifierProvider<WalletFormNotifier, WalletFormState>(
  (ref) => WalletFormNotifier(),
);

/// Centralized wallet dialog using BaseDialog
class CentralizedWalletDialog extends ConsumerWidget {
  final WalletEntity? wallet;
  final VoidCallback? onSaved;

  const CentralizedWalletDialog({
    super.key,
    this.wallet,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(walletFormNotifierProvider);
    final formNotifier = ref.read(walletFormNotifierProvider.notifier);
    final saveWallet = ref.read(saveWalletProvider);

    // Initialize form with wallet data if editing
    if (wallet != null && formState.name.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        formNotifier.updateName(wallet!.name);
        formNotifier.updateType(wallet!.type);
        formNotifier.updateIsDefault(wallet!.isDefault);
      });
    }

    return BaseDialog(
      title: wallet == null ? 'Add Wallet' : 'Edit Wallet',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Wallet Name',
              errorText: formState.getFieldError('name'),
            ),
            onChanged: formNotifier.updateName,
            controller: TextEditingController(text: formState.name),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WalletType>(
            decoration: const InputDecoration(labelText: 'Wallet Type'),
            value: formState.type,
            items: WalletType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) formNotifier.updateType(type);
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Set as default wallet'),
            value: formState.isDefault,
            onChanged: (value) {
              if (value != null) formNotifier.updateIsDefault(value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: formState.isValid && !formState.isLoading
              ? () => _saveWallet(context, ref, formState, saveWallet)
              : null,
          child: formState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(wallet == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  Future<void> _saveWallet(
    BuildContext context,
    WidgetRef ref,
    WalletFormState formState,
    Future<void> Function(WalletEntity) saveWallet,
  ) async {
    final formNotifier = ref.read(walletFormNotifierProvider.notifier);
    
    try {
      formNotifier.setLoading(true);
      formNotifier.clearErrors();

      final walletEntity = WalletEntity(
        id: wallet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: formState.name.trim(),
        type: formState.type,
        isDefault: formState.isDefault,
        createdAt: wallet?.createdAt ?? DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await saveWallet(walletEntity);
      
      Navigator.of(context).pop();
      onSaved?.call();
    } catch (e) {
      formNotifier.setError('Failed to save wallet: ${e.toString()}');
    } finally {
      formNotifier.setLoading(false);
    }
  }
}

/// Helper function to show wallet dialog
Future<void> showWalletDialog(
  BuildContext context, {
  WalletEntity? wallet,
  VoidCallback? onSaved,
}) {
  return showDialog(
    context: context,
    builder: (context) => CentralizedWalletDialog(
      wallet: wallet,
      onSaved: onSaved,
    ),
  );
}
