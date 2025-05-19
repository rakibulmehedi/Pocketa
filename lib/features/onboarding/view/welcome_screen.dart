// lib/features/splash/view/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/language_toggle.dart';
import 'package:pocketa/core/widgets/theme_toggle.dart';

import '../../../config/provider/theme_provider.dart';
import '../../../core/component/app_button.dart';
import '../../../l10n/app_localization.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);
    final _languageToggleRow = const LanguageToggleRow();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtilities.horizontalPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'P',
                    style: TextStyle(
                      fontSize: ResponsiveUtilities.font(context, 48),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ResponsiveUtilities.spacing(context),
              Text(context.l10n.appName, style: theme.textTheme.displayLarge),
              Spacer(),
              Text(
                context.l10n.welcomeMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveUtilities.font(context, 24),
                ),
              ),
              ResponsiveUtilities.spacing(context),
              Text(
                context.l10n.tagLine,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              ThemeToggle(),
              const SizedBox(height: 16),
              AppButton(
                label: context.l10n.getStarted,
                onPressed: () => Navigator.pushNamed(context, '/onboarding'),
                isEnabled: true,
              ),
              ResponsiveUtilities.spacing(context),
              _languageToggleRow,
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
