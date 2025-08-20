import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/l10n/app_localizations.dart';

enum AppLanguage { en, bn }

class LanguageToggleBtn extends ConsumerWidget {
  const LanguageToggleBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEN = locale.languageCode == 'en';

    // Null-safe localizations
    AppLocalizations.of(context);
    final enLabel = 'English';
    final bnLabel = 'বাংলা';

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: _LanguageSwitch(
        value: isEN ? AppLanguage.en : AppLanguage.bn,
        labels: {'en': enLabel, 'bn': bnLabel},
        onChanged: (next) async {
          await ref
              .read(localeProvider.notifier)
              .setLocale(
                next == AppLanguage.en
                    ? const Locale('en')
                    : const Locale('bn'),
              );
        },
      ),
    );
  }
}

/// Minimal internal switch widget for toggling languages.
/// It uses a simple InkWell to toggle between English and Bengali.
/// The switch is styled with a gradient background and animated alignment.
/// It displays the current language in a segmented style.
class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({
    required this.value,
    required this.onChanged,
    required this.labels,
  });

  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    final isEN = value == AppLanguage.en;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(isEN ? AppLanguage.bn : AppLanguage.en),
      child: Container(
        height: 36,
        width: 120,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              alignment: isEN ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.14),
                ),
              ),
            ),
            Row(
              children: [
                _seg(labels['en'] ?? 'EN', isEN),
                _seg(labels['bn'] ?? 'BN', !isEN),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _seg(String text, bool active) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: active ? null : Colors.white.withOpacity(0.75),
          ),
        ),
      ),
    );
  }
}
