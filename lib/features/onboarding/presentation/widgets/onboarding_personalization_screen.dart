import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/providers/theme_provider.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/locale/local_notifier.dart';

class OnboardingPersonalizationScreen extends ConsumerWidget {
  final OnboardingFormNotifier notifier;

  const OnboardingPersonalizationScreen({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    // Optimize rebuilds with select() for specific fields
    final state = ref.watch(onboardingStateProvider);
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                children: [
                  // Header
                  Text(
                    l10n.onb_persona_title,
                    style: layout.responsiveTextStyle(
                      phone: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      tablet: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      desktop: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: layout.spaceL),

                  Text(
                    l10n.onb_persona_helper,
                    style: layout.responsiveTextStyle(
                      phone: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      tablet: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      desktop: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: layout.space2xl),

                  // Personalization options
                  _buildSection(
                    context,
                    l10n.onb_currency_label,
                    [
                      _buildOption(
                        context,
                        'USD',
                        'US Dollar',
                        state.data.currency == 'USD',
                        () => notifier.updateCurrency('USD'),
                      ),
                      _buildOption(
                        context,
                        'EUR',
                        'Euro',
                        state.data.currency == 'EUR',
                        () => notifier.updateCurrency('EUR'),
                      ),
                      _buildOption(
                        context,
                        'BDT',
                        'Bangladeshi Taka',
                        state.data.currency == 'BDT',
                        () => notifier.updateCurrency('BDT'),
                      ),
                    ],
                    layout,
                  ),

                  SizedBox(height: layout.space2xl),

                  _buildSection(
                    context,
                    l10n.onb_language_label,
                    [
                      _buildOption(
                        context,
                        'English',
                        'English',
                        currentLocale.languageCode == 'en',
                        () {
                          notifier.updateLanguage('en');
                          localeNotifier.setLocale(const Locale('en'));
                        },
                      ),
                      _buildOption(
                        context,
                        'বাংলা',
                        'Bengali',
                        currentLocale.languageCode == 'bn',
                        () {
                          notifier.updateLanguage('bn');
                          localeNotifier.setLocale(const Locale('bn'));
                        },
                      ),
                    ],
                    layout,
                  ),

                  SizedBox(height: layout.space2xl),

                  _buildSection(
                    context,
                    'Theme',
                    [
                      _buildOption(
                        context,
                        'Light',
                        'Light Theme',
                        themeMode == ThemeMode.light,
                        () => themeNotifier.setLight(),
                      ),
                      _buildOption(
                        context,
                        'Dark',
                        'Dark Theme',
                        themeMode == ThemeMode.dark,
                        () => themeNotifier.setDark(),
                      ),
                      _buildOption(
                        context,
                        'System',
                        'System Default',
                        themeMode == ThemeMode.system,
                        () => themeNotifier.setSystem(),
                      ),
                    ],
                    layout,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> options,
    AppSize layout,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: layout.responsiveTextStyle(
            phone: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tablet: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            desktop: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),
        layout.isDesktop 
          ? Row(
              children: options.map((option) => 
                Expanded(child: Padding(
                  padding: EdgeInsets.only(right: layout.spaceM),
                  child: option,
                ))
              ).toList(),
            )
          : Wrap(
              spacing: layout.spaceM,
              runSpacing: layout.spaceS,
              children: options,
            ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final layout = context.layout;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(layout.spaceM),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primaryStrong(context)
            : AppColors.surfaceElevated(context),
          borderRadius: BorderRadius.circular(layout.radiusM),
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : AppColors.borderMedium(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: layout.responsiveSize(
                phone: 4,
                tablet: 6,
                desktop: 8,
              ),
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                  ? AppColors.buttonTextPrimary(context)
                  : AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected 
                  ? AppColors.buttonTextPrimary(context).withValues(alpha: 0.8)
                  : AppColors.textTertiary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
