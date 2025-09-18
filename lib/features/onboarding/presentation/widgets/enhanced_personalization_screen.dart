import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_card.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class EnhancedPersonalizationScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const EnhancedPersonalizationScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<EnhancedPersonalizationScreen> createState() => _EnhancedPersonalizationScreenState();
}

class _EnhancedPersonalizationScreenState extends ConsumerState<EnhancedPersonalizationScreen>
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
    final onboardingState = ref.watch(onboardingStateProvider);
    final currentLocale = ref.watch(localeProvider);

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
                                style: AppTextStyles.responsiveDisplay(context),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: layout.spaceL),
                              Text(
                                l10n.onb_persona_helper,
                                style: AppTextStyles.responsiveBody(context),
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
                              _buildLanguageSection(context, l10n, layout, onboardingState, currentLocale),
                              SizedBox(height: layout.space2xl),
                              _buildIncomeTypeSection(context, l10n, layout, onboardingState),
                              SizedBox(height: layout.space2xl),
                              _buildCurrencySection(context, l10n, layout, onboardingState),
                              SizedBox(height: layout.space2xl),
                              // _buildSpendingFrequencySection(context, l10n, layout, onboardingState),
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

  Widget _buildLanguageSection(
    BuildContext context, 
    AppLocalizations l10n, 
    AppSize layout, 
    OnboardingState state,
    Locale currentLocale,
  ) {
    return _buildSection(
      context,
      l10n.onb_language_label,
      Icons.language_rounded,
      [
        OnboardingCard(
          title: 'বাংলা',
          subtitle: 'Bengali',
          emoji: '🇧🇩',
          isSelected: currentLocale.languageCode == 'bn',
          onTap: () {
            widget.notifier.updateLanguage('bn');
            ref.read(localeProvider.notifier).setLocale(const Locale('bn'));
          },
        ),
        OnboardingCard(
          title: 'English',
          subtitle: 'English',
          emoji: '🇺🇸',
          isSelected: currentLocale.languageCode == 'en',
          onTap: () {
            widget.notifier.updateLanguage('en');
            ref.read(localeProvider.notifier).setLocale(const Locale('en'));
          },
        ),
      ],
      layout,
    );
  }

  Widget _buildIncomeTypeSection(
    BuildContext context, 
    AppLocalizations l10n, 
    AppSize layout, 
    OnboardingState state,
  ) {
    return _buildSection(
      context,
      l10n.onb_income_type_label,
      Icons.person_rounded,
      [
        OnboardingCard(
          title: l10n.onb_income_student,
          subtitle: 'Student',
          emoji: '🎓',
          isSelected: state.data.incomeType == IncomeType.student,
          onTap: () => widget.notifier.updateIncomeType(IncomeType.student),
        ),
        OnboardingCard(
          title: l10n.onb_income_freelancer,
          subtitle: 'Freelancer',
          emoji: '💻',
          isSelected: state.data.incomeType == IncomeType.freelancer,
          onTap: () => widget.notifier.updateIncomeType(IncomeType.freelancer),
        ),
        OnboardingCard(
          title: l10n.onb_income_family,
          subtitle: 'Family',
          emoji: '🏠',
          isSelected: state.data.incomeType == IncomeType.family,
          onTap: () => widget.notifier.updateIncomeType(IncomeType.family),
        ),
      ],
      layout,
    );
  }

  Widget _buildCurrencySection(
    BuildContext context, 
    AppLocalizations l10n, 
    AppSize layout, 
    OnboardingState state,
  ) {
    return _buildSection(
      context,
      l10n.onb_currency_label,
      Icons.attach_money_rounded,
      [
        OnboardingCard(
          title: 'BDT',
          subtitle: 'Bangladeshi Taka',
          emoji: '৳',
          isSelected: state.data.currency == 'BDT',
          onTap: () => widget.notifier.updateCurrency('BDT'),
        ),
        OnboardingCard(
          title: 'USD',
          subtitle: 'US Dollar',
          emoji: '💵',
          isSelected: state.data.currency == 'USD',
          onTap: () => widget.notifier.updateCurrency('USD'),
        ),
        OnboardingCard(
          title: 'EUR',
          subtitle: 'Euro',
          emoji: '💶',
          isSelected: state.data.currency == 'EUR',
          onTap: () => widget.notifier.updateCurrency('EUR'),
        ),
      ],
      layout,
    );
  }

  // Widget _buildSpendingFrequencySection(
  //   BuildContext context, 
  //   AppLocalizations l10n, 
  //   AppSize layout, 
  //   OnboardingState state,
  // ) {
  //   return _buildSection(
  //     context,
  //     'Spending Frequency',
  //     Icons.schedule_rounded,
  //     [
  //       OnboardingCard(
  //         title: 'Daily',
  //         subtitle: 'Track expenses daily',
  //         emoji: '📅',
  //         isSelected: state.data.spendingFrequency == SpendingFrequency.daily,
  //         onTap: () => widget.notifier.updateSpendingFrequency(SpendingFrequency.daily),
  //       ),
  //       OnboardingCard(
  //         title: 'Weekly',
  //         subtitle: 'Track expenses weekly',
  //         emoji: '📊',
  //         isSelected: state.data.spendingFrequency == SpendingFrequency.weekly,
  //         onTap: () => widget.notifier.updateSpendingFrequency(SpendingFrequency.weekly),
  //       ),
  //       OnboardingCard(
  //         title: 'Monthly',
  //         subtitle: 'Track expenses monthly',
  //         emoji: '📈',
  //         isSelected: state.data.spendingFrequency == SpendingFrequency.monthly,
  //         onTap: () => widget.notifier.updateSpendingFrequency(SpendingFrequency.monthly),
  //       ),
  //     ],
  //     layout,
  //   );
  // }

  Widget _buildSection(
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
                phone: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
                tablet: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
                desktop: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: layout.spaceL),
        layout.isDesktop 
          ? Wrap(
              spacing: layout.spaceM,
              runSpacing: layout.spaceS,
              children: options,
            )
          : Column(
              children: options.map((option) => 
                Padding(
                  padding: EdgeInsets.only(bottom: layout.spaceS),
                  child: option,
                )
              ).toList(),
            ),
      ],
    );
  }
}
