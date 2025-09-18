import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets.dart';

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
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              // Illustration - Responsive sizing
              Container(
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
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
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
                    // Performance optimization: cache image at target size
                    cacheWidth: (layout.responsiveSize(
                      phone: 120,
                      tablet: 180,
                      desktop: 220,
                    ) * MediaQuery.of(context).devicePixelRatio).round(),
                    cacheHeight: (layout.responsiveSize(
                      phone: 120,
                      tablet: 180,
                      desktop: 220,
                    ) * MediaQuery.of(context).devicePixelRatio).round(),
                  ),
                ),
              ),

              SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

              // Title - Responsive text sizing
              Text(
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

              SizedBox(height: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),

              // Subtitle - Responsive text sizing
              Text(
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

              SizedBox(height: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40)),

              // Feature chips - Responsive layout
              device == DeviceSize.desktop 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeatureChip(
                        label: l10n.onb_features_secure,
                        icon: Icons.security,
                        onTap: () => _onChipTapped(context, 'secure'),
                      ),
                      SizedBox(width: layout.spaceM),
                      FeatureChip(
                        label: l10n.onb_features_simple,
                        icon: Icons.touch_app,
                        onTap: () => _onChipTapped(context, 'simple'),
                      ),
                      SizedBox(width: layout.spaceM),
                      FeatureChip(
                        label: l10n.onb_features_smart,
                        icon: Icons.psychology,
                        onTap: () => _onChipTapped(context, 'smart'),
                      ),
                    ],
                  )
                : Wrap(
                    spacing: layout.spaceS,
                    runSpacing: layout.spaceS,
                    alignment: WrapAlignment.center,
                    children: [
                      FeatureChip(
                        label: l10n.onb_features_secure,
                        icon: Icons.security,
                        onTap: () => _onChipTapped(context, 'secure'),
                      ),
                      FeatureChip(
                        label: l10n.onb_features_simple,
                        icon: Icons.touch_app,
                        onTap: () => _onChipTapped(context, 'simple'),
                      ),
                      FeatureChip(
                        label: l10n.onb_features_smart,
                        icon: Icons.psychology,
                        onTap: () => _onChipTapped(context, 'smart'),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
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
            Icon(icon, color: AppColors.buttonTextPrimary(context), size: 20),
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