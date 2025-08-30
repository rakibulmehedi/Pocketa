import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/theme/gradient.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  // Top Bar with Language Toggle
                  const _TopBar(),

                  // Main Content
                  const SizedBox(height: 20),
                  // Welcome Illustration and Text
                  _Content(theme: theme),
                  const SizedBox(height: 20),
                  // Get Started Button
                  // const _GetStartedButton(),
                  PositiveButton(label: l10n.getStarted, onPressed: () {
                    context.go('/');
                  }),
                ],
              ),
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
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/welcome_vector.png',
                  fit: BoxFit.contain,
                  semanticLabel: 'Welcome illustration',
                  // This image should be in your assets folder
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).welcomeTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
