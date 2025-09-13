import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui/app_background_scaffold.dart';
import 'package:pocketa/shared/ui/footer_cta_bar.dart';
import 'package:pocketa/shared/ui/motion/app_motion.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

    // fire analytics when the screen is built
    ref.read(analyticsProvider).logEvent('onb_step_viewed');

    return AppBackgroundScaffold(
      body: SafeArea(
        child: Padding(
          padding: layout.pageGutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar with Language Toggle
              const _TopBar(),

              // Main Content
              SizedBox(height: layout.space2xl),
              
              // Welcome Illustration and Text
              Expanded(
                child: _Content(theme: theme, layout: layout),
              ),
              
              SizedBox(height: layout.space2xl),
            ],
          ),
        ),
      ),
      footer: FooterCtaBar(
        primaryLabel: l10n.getStarted,
        onPrimary: () async {
          final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
          await prefs.put('onboarding_done', true);
          await ref
              .read(analyticsProvider)
              .logEvent('onb_continue_clicked');
          if (context.mounted) context.go('/');
        },
        primaryIcon: Icons.arrow_forward_ios_rounded,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.theme, required this.layout});

  final ThemeData theme;
  final AppSize layout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: layout.spaceS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Welcome Illustration with motion
            AppMotion.fadeSlide(
              delay: const Duration(milliseconds: 60),
              child: SizedBox(
                height: layout.responsiveSize(phone: 200, tablet: 240, desktop: 280),
                child: Image.asset(
                  'assets/welcome_vector.png',
                  fit: BoxFit.contain,
                  semanticLabel: 'Welcome illustration',
                ),
              ),
            ),
            
            SizedBox(height: layout.space2xl),
            
            // Title with motion
            AppMotion.fadeSlide(
              delay: const Duration(milliseconds: 160),
              child: Text(
                AppLocalizations.of(context).welcomeTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: layout.spaceM),
            
            // Subtitle with motion
            AppMotion.fadeSlide(
              delay: const Duration(milliseconds: 220),
              child: Text(
                AppLocalizations.of(context).tagline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return AppMotion.fadeSlide(
      delay: const Duration(milliseconds: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: layout.spaceM,
              vertical: layout.spaceS,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(layout.radiusS),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: layout.iconS,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: layout.spaceS),
                Text(
                  'EN',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
