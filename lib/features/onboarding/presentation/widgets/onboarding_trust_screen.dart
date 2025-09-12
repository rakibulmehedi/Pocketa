import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui/glass_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class OnboardingTrustScreen extends StatelessWidget {
  final OnboardingNotifier notifier;

  const OnboardingTrustScreen({
    super.key,
    required this.notifier,
  });

  static const _trustPoints = [
    (Icons.cloud_off_outlined, 'onb_trust_bullet_offline'),
    (Icons.lock_outline, 'onb_trust_bullet_privacy'),
    (Icons.fingerprint, 'onb_trust_bullet_lock'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FadeSlide(child: _buildHeader(context, layout, theme)),
                SizedBox(height: layout.space2xl),
                FadeSlide(delay: Motion.d060, child: _buildTrustPoints(context, l10n, layout, theme)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppSize layout, ThemeData theme) {
    return Column(
      children: [
        Semantics(
          label: 'Security and privacy icon',
          child: Container(
            width: layout.responsiveSize(phone: 80, tablet: 100, desktop: 120),
            height: layout.responsiveSize(phone: 80, tablet: 100, desktop: 120),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 40, tablet: 50, desktop: 60)),
            ),
            child: Icon(
              Icons.security,
              size: layout.responsiveIconSize(phone: 40, tablet: 50, desktop: 60),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        SizedBox(height: layout.spaceXl),
        Text(
          AppLocalizations.of(context).onb_trust_title,
          style: _getTitleStyle(theme, layout),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTrustPoints(BuildContext context, AppLocalizations l10n, AppSize layout, ThemeData theme) {
    return StaggerList(
      children: _trustPoints.map((point) {
        return Padding(
          padding: EdgeInsets.only(bottom: layout.spaceXl),
          child: _buildTrustPoint(context, point.$1, _getLocalizedText(l10n, point.$2), layout, theme),
        );
      }).toList(),
    );
  }


  Widget _buildTrustPoint(BuildContext context, IconData icon, String text, AppSize layout, ThemeData theme) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(layout.spaceM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(layout.radiusS),
            ),
            child: Icon(icon, size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32), color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(width: layout.space2xl),
          Flexible(child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, height: 1.4))),
        ],
      ),
    );
  }

  TextStyle _getTitleStyle(ThemeData theme, AppSize layout) {
    return theme.textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
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
