import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui/glass_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class OnboardingWelcomeScreen extends ConsumerWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final device = context.device;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration - Responsive sizing
                FadeSlide(
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
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        layout.responsiveSize(
                          phone: 100,
                          tablet: 140,
                          desktop: 160,
                        ),
                      ),
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

                SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

                // Title - Responsive text sizing
                FadeSlide(
                  delay: Motion.d060,
                  child: Text(
                    l10n.onb_welcome_title,
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

                SizedBox(height: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),

                // Subtitle - Responsive text sizing
                FadeSlide(
                  delay: Motion.d100,
                  child: Text(
                    l10n.onb_welcome_subtitle,
                    style: layout.responsiveTextStyle(
                      phone: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      tablet: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      desktop: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

                // Feature chips - Responsive layout with staggered animation
                device == DeviceSize.desktop 
                  ? StaggerList(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureChip(context, l10n.onb_features_secure, Icons.security, 'secure', layout),
                            SizedBox(width: layout.spaceM),
                            _buildFeatureChip(context, l10n.onb_features_simple, Icons.touch_app, 'simple', layout),
                            SizedBox(width: layout.spaceM),
                            _buildFeatureChip(context, l10n.onb_features_smart, Icons.psychology, 'smart', layout),
                          ],
                        ),
                      ],
                    )
                  : StaggerList(
                      children: [
                        Wrap(
                          spacing: layout.spaceS,
                          runSpacing: layout.spaceS,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildFeatureChip(context, l10n.onb_features_secure, Icons.security, 'secure', layout),
                            _buildFeatureChip(context, l10n.onb_features_simple, Icons.touch_app, 'simple', layout),
                            _buildFeatureChip(context, l10n.onb_features_smart, Icons.psychology, 'smart', layout),
                          ],
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

  Widget _buildFeatureChip(BuildContext context, String label, IconData icon, String chipType, AppSize layout) {
    return ScaleTap(
      onTap: () => _onChipTapped(context, chipType),
      child: GlassCard(
        padding: EdgeInsets.symmetric(horizontal: layout.spaceL, vertical: layout.spaceM),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: layout.iconM, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: layout.spaceS),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

}