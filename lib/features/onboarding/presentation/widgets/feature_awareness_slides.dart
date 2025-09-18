import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class FeatureAwarenessSlides extends ConsumerStatefulWidget {
  const FeatureAwarenessSlides({super.key});

  @override
  ConsumerState<FeatureAwarenessSlides> createState() => _FeatureAwarenessSlidesState();
}

class _FeatureAwarenessSlidesState extends ConsumerState<FeatureAwarenessSlides>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value.dy * 50),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentSlide = index;
                      });
                    },
                    children: [
                      _buildSlide1(context, l10n, layout),
                      _buildSlide2(context, l10n, layout),
                      _buildSlide3(context, l10n, layout),
                    ],
                  ),
                ),
                SizedBox(height: layout.spaceL),
                _buildDotsIndicator(context, layout, _currentSlide),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlide1(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return Padding(
      padding: layout.pageGutter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual elements
          Container(
            height: layout.responsiveSize(phone: 200, tablet: 250, desktop: 300),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(layout.radiusXl),
            ),
            child: Stack(
              children: [
                // Taka symbol
                Positioned(
                  top: layout.space2xl,
                  left: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Text(
                      '৳',
                      style: TextStyle(
                        fontSize: layout.responsiveSize(phone: 32, tablet: 40, desktop: 48),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Student bag icon
                Positioned(
                  top: layout.space2xl,
                  right: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                // Laptop icon
                Positioned(
                  bottom: layout.space2xl,
                  left: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.laptop_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                // Family home icon
                Positioned(
                  bottom: layout.space2xl,
                  right: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.home_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: layout.space2xl),
          // Title
          Text(
            l10n.onb_welcome_title,
            style: layout.responsiveTextStyle(
              phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
              tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
              desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: layout.spaceL),
          // Subtitle
          Text(
            l10n.onb_welcome_subtitle,
            style: layout.responsiveTextStyle(
              phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
                letterSpacing: 0.2,
              ),
              tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
                letterSpacing: 0.2,
              ),
              desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
                letterSpacing: 0.2,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSlide2(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return Padding(
      padding: layout.pageGutter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual elements
          Container(
            height: layout.responsiveSize(phone: 200, tablet: 250, desktop: 300),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(layout.radiusXl),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(layout.space2xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(layout.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '৳৫০',
                      style: TextStyle(
                        fontSize: layout.responsiveSize(phone: 32, tablet: 40, desktop: 48),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: layout.spaceS),
                    Text(
                      l10n.onb_demo_category,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: layout.spaceS),
                    Text(
                      l10n.onb_demo_note,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: layout.space2xl),
          // Title
          Text(
            l10n.onb_demo_title,
            style: AppTextStyles.responsiveDisplay(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: layout.spaceL),
          // Subtitle
          Text(
            l10n.onb_demo_helper,
            style: AppTextStyles.responsiveBody(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSlide3(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return Padding(
      padding: layout.pageGutter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual elements
          Container(
            height: layout.responsiveSize(phone: 200, tablet: 250, desktop: 300),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(layout.radiusXl),
            ),
            child: Stack(
              children: [
                // Lock icon
                Positioned(
                  top: layout.space2xl,
                  left: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                // Shield icon
                Positioned(
                  top: layout.space2xl,
                  right: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.shield_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // Phone icon
                Positioned(
                  bottom: layout.space2xl,
                  left: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.phone_android_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                // Checkmark icon
                Positioned(
                  bottom: layout.space2xl,
                  right: layout.space2xl,
                  child: Container(
                    padding: EdgeInsets.all(layout.spaceL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(layout.radiusL),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: layout.space2xl),
          // Title
          Text(
            l10n.onb_trust_title,
            style: layout.responsiveTextStyle(
              phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
              tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
              desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: layout.spaceL),
          // Trust points
          Column(
            children: [
              _buildTrustPoint(context, l10n.onb_trust_bullet_offline, layout),
              SizedBox(height: layout.spaceM),
              _buildTrustPoint(context, l10n.onb_trust_bullet_privacy, layout),
              SizedBox(height: layout.spaceM),
              _buildTrustPoint(context, l10n.onb_trust_bullet_lock, layout),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustPoint(BuildContext context, String text, AppSize layout) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
        ),
        SizedBox(width: layout.spaceS),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotsIndicator(BuildContext context, AppSize layout, int currentSlide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: layout.spaceS),
          width: currentSlide == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentSlide == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
