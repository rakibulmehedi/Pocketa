import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/providers/theme_provider.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/shared/ui/glass_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class OnboardingPersonalizationScreen extends ConsumerWidget {
  final OnboardingNotifier notifier;

  const OnboardingPersonalizationScreen({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final state = ref.watch(onboardingStateProvider);
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                FadeSlide(
                  child: Text(
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
                ),

                SizedBox(height: layout.spaceL),

                FadeSlide(
                  delay: Motion.d060,
                  child: Text(
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
                ),

                SizedBox(height: layout.space2xl),

                // Personalization options with staggered animation
                StaggerList(
                  children: [
                    _buildSection(
                      context,
                      l10n.onb_currency_label,
                      [
                        _buildOption(
                          context,
                          'USD',
                          l10n.onb_currency_usd,
                          state.data.currency == 'USD',
                          () => notifier.updateCurrency('USD'),
                        ),
                        _buildOption(
                          context,
                          'EUR',
                          l10n.onb_currency_eur,
                          state.data.currency == 'EUR',
                          () => notifier.updateCurrency('EUR'),
                        ),
                        _buildOption(
                          context,
                          'BDT',
                          l10n.onb_currency_bdt,
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
                          l10n.onb_language_en,
                          currentLocale.languageCode == 'en',
                          () {
                            notifier.updateLanguage('en');
                            localeNotifier.setLocale(const Locale('en'));
                          },
                        ),
                        _buildOption(
                          context,
                          'বাংলা',
                          l10n.onb_language_bn,
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
                          l10n.onb_theme_light,
                          themeMode == ThemeMode.light,
                          () => themeNotifier.setLight(),
                        ),
                        _buildOption(
                          context,
                          'Dark',
                          l10n.onb_theme_dark,
                          themeMode == ThemeMode.dark,
                          () => themeNotifier.setDark(),
                        ),
                        _buildOption(
                          context,
                          'System',
                          l10n.onb_theme_system,
                          themeMode == ThemeMode.system,
                          () => themeNotifier.setSystem(),
                        ),
                      ],
                      layout,
                    ),
                  ],
                ),
              ],
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
    
    return ScaleTap(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.all(layout.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
