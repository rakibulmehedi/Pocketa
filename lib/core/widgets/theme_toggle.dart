import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: SwitchListTile(
        value: isDark,
        onChanged: (val) {
          ref.read(isDarkModeProvider.notifier).state = val; // Professional: Uses Notifier method
        },
        title: Text(
          'Dark Mode',
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        secondary: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: isDark ? Colors.amberAccent : Colors.blueGrey,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
