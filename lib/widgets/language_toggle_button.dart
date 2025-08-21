import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/l10n/app_localizations.dart';

enum AppLanguage { en, bn }

class LanguageToggleBtn extends ConsumerWidget {
  const LanguageToggleBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final t = AppLocalizations.of(context);

    final selected = locale.languageCode == 'en'
        ? AppLanguage.en
        : AppLanguage.bn;

    // Material 3 segmented control (single select)
    return SegmentedButton<AppLanguage>(
      segments: <ButtonSegment<AppLanguage>>[
        ButtonSegment(
          value: AppLanguage.en,
          label: Text(t.english), // লোকালাইজড
          icon: const Icon(Icons.language),
        ),
        ButtonSegment(
          value: AppLanguage.bn,
          label: Text(t.bengali), // লোকালাইজড
          icon: const Icon(Icons.translate),
        ),
      ],
      selected: {selected},
      multiSelectionEnabled: false,
      showSelectedIcon: false,

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(
            context,
          ).colorScheme.surfaceContainerLow.withValues(alpha: .2),
        ),
        minimumSize: WidgetStateProperty.all(const Size(140, 44)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        // Border subtle রাখতে চাইলে (outlineVariant)
        side: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                );
        }),
      ),

      onSelectionChanged: (newSelection) async {
        final next = newSelection.first;
        HapticFeedback.selectionClick();
        await ref
            .read(localeProvider.notifier)
            .setLocale(
              next == AppLanguage.en ? const Locale('en') : const Locale('bn'),
            );
      },
    );
  }
}
