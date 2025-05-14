// lib/features/splash/view/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/widgets/theme_toggle.dart';
import 'package:pocketa/core/constants/strings.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import '../../core/provider/language_provider.dart';
import '../../core/provider/theme_provider.dart';
import '../../core/component/app_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildBody(context, theme, isDark, ref),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, bool isDark, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        _buildAppLogoAndTitle(theme),
        const Spacer(),
        const ThemeToggle(),
        const SizedBox(height: 24),
        AppButton(
          label: AppString.getStarted,
          onPressed:
              () => Navigator.pushNamed(context, '/onboarding/income-source'),
          isPrimary: true,
        ),
        const SizedBox(height: 16),
        _buildLanguageToggleRow(context, ref),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAppLogoAndTitle(ThemeData theme) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary,
          child: Text(
            'P',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(AppString.appName, style: theme.textTheme.displayLarge),
        const SizedBox(height: 12),
        Text(
          AppString.tagLine,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildLanguageToggleRow(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLanguage = ref.watch(languageProvider);

    TextStyle selectedStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
    );

    TextStyle unselectedStyle = theme.textTheme.titleMedium!.copyWith(
      color:
          theme.brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[600],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(languageProvider.notifier).state = AppLanguage.bangla;
          },
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
          onTap: () {
            ref.read(languageProvider.notifier).state = AppLanguage.english;
          },
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
