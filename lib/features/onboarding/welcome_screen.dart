// lib/features/splash/view/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/language_toggle.dart';
import 'package:pocketa/l10n/app_localization.dart';

import '../../config/provider/theme_provider.dart';
import '../../core/component/app_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);
    final _languageToggleRow = const LanguageToggleRow();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.horizontalPadding(context),
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
                      fontSize: ResponsiveUtils.font(context, 48),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                               ),
               ),
              ResponsiveUtils.spacing(context),
              Text(L.of(context).appName, style: theme.textTheme.displayLarge),
              Spacer(),
              Text(
                L.of(context).welcomeMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveUtils.font(context, 24),
                ),
              ),
              ResponsiveUtils.spacing(context),
              Text(
                L.of(context).tagLine,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              AppButton(
                label: L.of(context).getStarted,
                onPressed:
                    () => Navigator.pushNamed(
                      context,
                      '/onboarding/income-source',
                    ),
                isPrimary: true,
              ),
              ResponsiveUtils.spacing(context),
              _languageToggleRow,
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
