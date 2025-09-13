import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class OnboardingTrustScreen extends StatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingTrustScreen({
    super.key,
    required this.notifier,
  });

  @override
  State<OnboardingTrustScreen> createState() => _OnboardingTrustScreenState();
}

class _OnboardingTrustScreenState extends State<OnboardingTrustScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _pointsController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _pointsFadeAnimation;
  late Animation<Offset> _pointsSlideAnimation;

  static const _trustPoints = [
    (Icons.cloud_off_outlined, 'onb_trust_bullet_offline'),
    (Icons.lock_outline, 'onb_trust_bullet_privacy'),
    (Icons.fingerprint, 'onb_trust_bullet_lock'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pointsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _pointsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pointsController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _pointsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pointsController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _pointsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                children: [
                  _buildEnhancedHeader(context, layout, theme),
                  SizedBox(height: layout.space2xl),
                  _buildEnhancedTrustPoints(context, l10n, layout, theme),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, AppSize layout, ThemeData theme) {
    return AnimatedBuilder(
      animation: Listenable.merge([_headerFadeAnimation, _headerSlideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value.dy * 50),
          child: Opacity(
            opacity: _headerFadeAnimation.value,
            child: Column(
              children: [
                Semantics(
                  label: 'Security and privacy icon',
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Transform.rotate(
                          angle: (1 - value) * 0.1,
                          child: Container(
                            width: layout.responsiveSize(phone: 100, tablet: 120, desktop: 140),
                            height: layout.responsiveSize(phone: 100, tablet: 120, desktop: 140),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.success(context),
                                  AppColors.success(context).withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 50, tablet: 60, desktop: 70)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success(context).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: AppColors.success(context).withValues(alpha: 0.1),
                                  blurRadius: 40,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.security_rounded,
                              size: layout.responsiveIconSize(phone: 50, tablet: 60, desktop: 70),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: layout.spaceXl),
                Text(
                  AppLocalizations.of(context).onb_trust_title,
                  style: _getEnhancedTitleStyle(theme, layout),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: layout.spaceL),
                Text(
                  'Your data stays on your device. Always.',
                  style: layout.responsiveTextStyle(
                    phone: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                      letterSpacing: 0.2,
                    ) ?? const TextStyle(),
                    tablet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                      letterSpacing: 0.2,
                    ) ?? const TextStyle(),
                    desktop: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                      letterSpacing: 0.2,
                    ) ?? const TextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildEnhancedTrustPoints(BuildContext context, AppLocalizations l10n, AppSize layout, ThemeData theme) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pointsFadeAnimation, _pointsSlideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _pointsSlideAnimation.value.dy * 30),
          child: Opacity(
            opacity: _pointsFadeAnimation.value,
            child: Column(
              children: _trustPoints.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 800 + (index * 200)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: Opacity(
                        opacity: value,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: layout.spaceXl),
                          child: _buildEnhancedTrustPoint(
                            context, 
                            point.$1, 
                            _getLocalizedText(l10n, point.$2), 
                            layout, 
                            theme,
                            index,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }



  Widget _buildEnhancedTrustPoint(BuildContext context, IconData icon, String text, AppSize layout, ThemeData theme, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showTrustPointDetails(context, icon, text, index);
      },
      child: Container(
        padding: EdgeInsets.all(layout.space2xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(layout.radiusL),
          border: Border.all(
            color: AppColors.success(context).withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.success(context).withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(layout.spaceL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success(context),
                    AppColors.success(context).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(layout.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success(context).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon, 
                size: layout.responsiveIconSize(phone: 28, tablet: 32, desktop: 36), 
                color: Colors.white,
              ),
            ),
            SizedBox(width: layout.space2xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: layout.spaceS),
                  Text(
                    _getTrustPointSubtitle(index),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
              color: AppColors.success(context).withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }


  void _showTrustPointDetails(BuildContext context, IconData icon, String text, int index) {
    final details = _getTrustPointDetails(index);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(icon, color: AppColors.success(context)),
            const SizedBox(width: 12),
            Expanded(child: Text('Security Details')),
          ],
        ),
        content: Text(details),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _getTrustPointSubtitle(int index) {
    switch (index) {
      case 0: return 'No internet required for core features';
      case 1: return 'End-to-end encryption protects your data';
      case 2: return 'Biometric authentication for extra security';
      default: return '';
    }
  }

  String _getTrustPointDetails(int index) {
    switch (index) {
      case 0: return 'All your financial data is stored locally on your device. No cloud sync means no data breaches, no tracking, and complete privacy.';
      case 1: return 'Your data is encrypted using industry-standard AES-256 encryption. Even if someone gains access to your device, your financial information remains protected.';
      case 2: return 'Use your fingerprint or face ID to secure the app. This adds an extra layer of protection beyond your device\'s lock screen.';
      default: return '';
    }
  }

  TextStyle _getEnhancedTitleStyle(ThemeData theme, AppSize layout) {
    return theme.textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
      letterSpacing: 0.5,
    ) ?? const TextStyle();
  }


  String _getLocalizedText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'onb_trust_bullet_offline': return l10n.onb_trust_bullet_offline;
      case 'onb_trust_bullet_privacy': return l10n.onb_trust_bullet_privacy;
      case 'onb_trust_bullet_lock': return l10n.onb_trust_bullet_lock;
      default: return '';
    }
  }
}
