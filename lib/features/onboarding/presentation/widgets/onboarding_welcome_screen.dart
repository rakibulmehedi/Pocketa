import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/services/snackbar_service.dart';
import 'package:pocketa/shared/widgets/custom_snackbar.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

class OnboardingWelcomeScreen extends ConsumerStatefulWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  ConsumerState<OnboardingWelcomeScreen> createState() => _OnboardingWelcomeScreenState();
}

class _OnboardingWelcomeScreenState extends ConsumerState<OnboardingWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _chipsController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _chipsFadeAnimation;
  late Animation<Offset> _chipsSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _chipsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _chipsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _chipsController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _chipsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _chipsController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _chipsController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _chipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final device = context.device;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              // Enhanced Logo with Animations
              AnimatedBuilder(
                animation: Listenable.merge([_logoScaleAnimation, _logoRotationAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotationAnimation.value,
                      child: Container(
                        width: layout.responsiveSize(
                          phone: 200,
                          tablet: 280,
                          desktop: 320,
                        ),
                        height: layout.responsiveSize(
                          phone: 200,
                          tablet: 280,
                          desktop: 320,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withValues(alpha: 0.15),
                              Theme.of(context).primaryColor.withValues(alpha: 0.08),
                              Theme.of(context).primaryColor.withValues(alpha: 0.05),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(
                            layout.responsiveSize(
                              phone: 100,
                              tablet: 140,
                              desktop: 160,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              blurRadius: 60,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/pocketa.png',
                            width: layout.responsiveSize(
                              phone: 120,
                              tablet: 180,
                              desktop: 220,
                            ),
                            height: layout.responsiveSize(
                              phone: 120,
                              tablet: 180,
                              desktop: 220,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

              // Enhanced Title with Animations
              AnimatedBuilder(
                animation: Listenable.merge([_textFadeAnimation, _textSlideAnimation]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _textSlideAnimation.value.dy * 50),
                    child: Opacity(
                      opacity: _textFadeAnimation.value,
                      child: Text(
                        l10n.onb_welcome_title,
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
                    ),
                  );
                },
              ),

              SizedBox(height: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),

              // Enhanced Subtitle with Animations
              AnimatedBuilder(
                animation: Listenable.merge([_textFadeAnimation, _textSlideAnimation]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _textSlideAnimation.value.dy * 30),
                    child: Opacity(
                      opacity: _textFadeAnimation.value * 0.9,
                      child: Text(
                        l10n.onb_welcome_subtitle,
                        style: layout.responsiveTextStyle(
                          phone: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                          tablet: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                          desktop: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

              // Enhanced Feature chips with Animations
              AnimatedBuilder(
                animation: Listenable.merge([_chipsFadeAnimation, _chipsSlideAnimation]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _chipsSlideAnimation.value.dy * 40),
                    child: Opacity(
                      opacity: _chipsFadeAnimation.value,
                      child: device == DeviceSize.desktop 
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_secure,
                                Icons.security,
                                'secure',
                                0,
                              ),
                              SizedBox(width: layout.spaceM),
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_simple,
                                Icons.touch_app,
                                'simple',
                                1,
                              ),
                              SizedBox(width: layout.spaceM),
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_smart,
                                Icons.psychology,
                                'smart',
                                2,
                              ),
                            ],
                          )
                        : Wrap(
                            spacing: layout.spaceS,
                            runSpacing: layout.spaceS,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_secure,
                                Icons.security,
                                'secure',
                                0,
                              ),
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_simple,
                                Icons.touch_app,
                                'simple',
                                1,
                              ),
                              _buildAnimatedFeatureChip(
                                context,
                                l10n.onb_features_smart,
                                Icons.psychology,
                                'smart',
                                2,
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

  Widget _buildAnimatedFeatureChip(
    BuildContext context,
    String label,
    IconData icon,
    String chipType,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: FeatureChip(
              label: label,
              icon: icon,
              onTap: () => _onChipTapped(context, chipType),
            ),
          ),
        );
      },
    );
  }

  void _onChipTapped(BuildContext context, String chipType) {
    HapticFeedback.lightImpact();
    
    String message = '';
    IconData icon = Icons.info;
    
    switch (chipType) {
      case 'secure':
        message = 'Your data is encrypted and stored locally. No cloud sync, maximum privacy.';
        icon = Icons.security;
        break;
      case 'simple':
        message = 'Clean, intuitive interface designed for easy expense tracking.';
        icon = Icons.touch_app;
        break;
      case 'smart':
        message = 'AI-powered insights and smart categorization for better financial management.';
        icon = Icons.psychology;
        break;
    }
    
    // Use centralized snackbar service for consistent UX
    SnackbarService.showCustom(
      context,
      message: message,
      type: SnackbarType.info,
      icon: icon,
      duration: const Duration(seconds: 3),
      showCloseButton: true,
    );
  }

}