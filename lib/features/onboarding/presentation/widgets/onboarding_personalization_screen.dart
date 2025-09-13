import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/providers/theme_provider.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/locale/local_notifier.dart';

class OnboardingPersonalizationScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingPersonalizationScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<OnboardingPersonalizationScreen> createState() => _OnboardingPersonalizationScreenState();
}

class _OnboardingPersonalizationScreenState extends ConsumerState<OnboardingPersonalizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _sectionsController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _sectionsFadeAnimation;
  late Animation<Offset> _sectionsSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _sectionsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _sectionsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sectionsController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _sectionsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sectionsController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _sectionsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _sectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                children: [
                  // Enhanced Header with Animations
                  AnimatedBuilder(
                    animation: Listenable.merge([_headerFadeAnimation, _headerSlideAnimation]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _headerSlideAnimation.value.dy * 50),
                        child: Opacity(
                          opacity: _headerFadeAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                l10n.onb_persona_title,
                                style: layout.responsiveTextStyle(
                                  phone: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                  tablet: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                  desktop: (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
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
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  tablet: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  desktop: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: layout.space2xl),

                  // Enhanced Personalization options with Animations
                  AnimatedBuilder(
                    animation: Listenable.merge([_sectionsFadeAnimation, _sectionsSlideAnimation]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _sectionsSlideAnimation.value.dy * 30),
                        child: Opacity(
                          opacity: _sectionsFadeAnimation.value,
                          child: Column(
                            children: [
                              _buildEnhancedSection(
                                context,
                                l10n.onb_currency_label,
                                Icons.attach_money_rounded,
                                [
                                  _buildEnhancedOption(
                                    context,
                                    'USD',
                                    'US Dollar',
                                    '💵',
                                    state.data.currency == 'USD',
                                    () => _onOptionSelected(() => widget.notifier.updateCurrency('USD')),
                                  ),
                                  _buildEnhancedOption(
                                    context,
                                    'EUR',
                                    'Euro',
                                    '💶',
                                    state.data.currency == 'EUR',
                                    () => _onOptionSelected(() => widget.notifier.updateCurrency('EUR')),
                                  ),
                                  _buildEnhancedOption(
                                    context,
                                    'BDT',
                                    'Bangladeshi Taka',
                                    '৳',
                                    state.data.currency == 'BDT',
                                    () => _onOptionSelected(() => widget.notifier.updateCurrency('BDT')),
                                  ),
                                ],
                                layout,
                              ),

                              SizedBox(height: layout.space2xl),

                              _buildEnhancedSection(
                                context,
                                l10n.onb_language_label,
                                Icons.language_rounded,
                                [
                                  _buildEnhancedOption(
                                    context,
                                    'English',
                                    'English',
                                    '🇺🇸',
                                    currentLocale.languageCode == 'en',
                                    () => _onOptionSelected(() {
                                      widget.notifier.updateLanguage('en');
                                      localeNotifier.setLocale(const Locale('en'));
                                    }),
                                  ),
                                  _buildEnhancedOption(
                                    context,
                                    'বাংলা',
                                    'Bengali',
                                    '🇧🇩',
                                    currentLocale.languageCode == 'bn',
                                    () => _onOptionSelected(() {
                                      widget.notifier.updateLanguage('bn');
                                      localeNotifier.setLocale(const Locale('bn'));
                                    }),
                                  ),
                                ],
                                layout,
                              ),

                              SizedBox(height: layout.space2xl),

                              _buildEnhancedSection(
                                context,
                                'Theme',
                                Icons.palette_rounded,
                                [
                                  _buildEnhancedOption(
                                    context,
                                    'Light',
                                    'Light Theme',
                                    '☀️',
                                    themeMode == ThemeMode.light,
                                    () => _onOptionSelected(() => themeNotifier.setLight()),
                                  ),
                                  _buildEnhancedOption(
                                    context,
                                    'Dark',
                                    'Dark Theme',
                                    '🌙',
                                    themeMode == ThemeMode.dark,
                                    () => _onOptionSelected(() => themeNotifier.setDark()),
                                  ),
                                  _buildEnhancedOption(
                                    context,
                                    'System',
                                    'System Default',
                                    '⚙️',
                                    themeMode == ThemeMode.system,
                                    () => _onOptionSelected(() => themeNotifier.setSystem()),
                                  ),
                                ],
                                layout,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onOptionSelected(VoidCallback onTap) {
    HapticFeedback.lightImpact();
    onTap();
  }

  Widget _buildEnhancedSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> options,
    AppSize layout,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(layout.spaceS),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(layout.radiusS),
              ),
              child: Icon(
                icon,
                size: layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: layout.spaceM),
            Text(
              title,
              style: layout.responsiveTextStyle(
                phone: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
                tablet: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
                desktop: (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: layout.responsiveSize(phone: 16, tablet: 20, desktop: 24)),
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


  Widget _buildEnhancedOption(
    BuildContext context,
    String title,
    String subtitle,
    String emoji,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final layout = context.layout;
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(layout.spaceL),
              decoration: BoxDecoration(
                gradient: isSelected 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                      ],
                    ),
                borderRadius: BorderRadius.circular(layout.radiusL),
                border: Border.all(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                      : Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: isSelected ? 12 : 6,
                    offset: Offset(0, isSelected ? 6 : 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        emoji,
                        style: TextStyle(
                          fontSize: layout.responsiveSize(phone: 20, tablet: 24, desktop: 28),
                        ),
                      ),
                      SizedBox(width: layout.spaceM),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24),
                        ),
                    ],
                  ),
                  SizedBox(height: layout.spaceS),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
