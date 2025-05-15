import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/provider/language_provider.dart';

class LanguageToggleRow extends ConsumerWidget {
  const LanguageToggleRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLanguage = ref.watch(languageProvider);

    final TextStyle selectedStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
    );

    final TextStyle unselectedStyle = theme.textTheme.titleMedium!.copyWith(
      color:
          theme.brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[600],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:
              () => ref
                  .read(languageProvider.notifier)
                  .toggleLanguage(AppLanguage.bangla),
          child: Text(
            'বাংলা',
            style:
                selectedLanguage == AppLanguage.bangla
                    ? selectedStyle
                    : unselectedStyle,
          ),
        ),
        const Text('  |  ', style: TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap:
              () => ref
                  .read(languageProvider.notifier)
                  .toggleLanguage(AppLanguage.english),
          child: Text(
            'English',
            style:
                selectedLanguage == AppLanguage.english
                    ? selectedStyle
                    : unselectedStyle,
          ),
        ),
      ],
    );
  }
}
