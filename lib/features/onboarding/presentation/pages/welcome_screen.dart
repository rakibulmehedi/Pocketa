import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/core/theme/gradient.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // fire analytics when the screen is built
    ref.read(analyticsProvider).logEvent('onb_step_viewed');

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: CardGradients.softBlueGreen),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: .4)
                      : Colors.transparent,
                ),
              ),
            ),
          ),

          Padding(
            padding: context.layout.pageGutter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Bar with Language Toggle
                const _TopBar(),

                // Main Content
                SizedBox(height: 2.5.rem(context)),
                // Welcome Illustration and Text
                _Content(theme: theme),
                SizedBox(height: 2.5.rem(context)),
                // Get Started Button
                // const _GetStartedButton(),
                PositiveButton(
                    label: l10n.getStarted,
                    onPressed: () async {
                      final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
                      await prefs.put('onboarding_done', true);
                      await ref
                          .read(analyticsProvider)
                          .logEvent('onb_continue_clicked');
                      if (context.mounted) context.go('/');
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.layout.spaceS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/welcome_vector.png',
                  fit: BoxFit.contain,
                  cacheHeight: (220 * context.layout.devicePixelRatio).round(),
                  semanticLabel: AppLocalizations.of(context)
                      .accessibility_welcome_illustration,
                  // This image should be in your assets folder
                ),
              ),
              SizedBox(height: 2.5.rem(context)),
              Text(
                AppLocalizations.of(context).welcomeTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.0.rem(context)),
              Text(
                AppLocalizations.of(context).tagline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [LanguageToggleBtn()],
    );
  }
}
