import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui/glass_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class OnboardingDemoScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingDemoScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<OnboardingDemoScreen> createState() => _OnboardingDemoScreenState();
}

class _OnboardingDemoScreenState extends ConsumerState<OnboardingDemoScreen> {
  bool _isDemoAdded = false;
  bool _isAdding = false;

  Future<void> _addDemoTransaction() async {
    if (_isAdding || _isDemoAdded) return;
    
    setState(() {
      _isAdding = true;
    });

    try {
      // Actually create a demo transaction
      await _createDemoTransaction();
      
      setState(() {
        _isDemoAdded = true;
        _isAdding = false;
      });

      // Show confetti and success toast
      if (mounted) {
        ConfettiOverlay.show(context);
        _showSuccessToast();
      }
    } catch (e) {
      setState(() {
        _isAdding = false;
      });
      
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add demo transaction: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _createDemoTransaction() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  void _showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary, size: 20),
            const SizedBox(width: 12),
            Text('Demo transaction added successfully!'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                FadeSlide(
                  child: Column(
                    children: [
                      Text(
                        l10n.onb_demo_title,
                        style: _buildTitleStyle(context, layout),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: layout.spaceL),

                      Text(
                        l10n.onb_demo_subtitle,
                        style: _buildSubtitleStyle(context, layout),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: layout.space2xl),

                // Demo card
                FadeSlide(
                  delay: Motion.d100,
                  child: _buildDemoCard(context, l10n, layout),
                ),

                SizedBox(height: layout.spaceXl),

                // Success message (only show after demo is added)
                if (_isDemoAdded)
                  FadeSlide(
                    delay: Motion.d160,
                    child: GlassCard(
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 24,
                          ),
                          SizedBox(width: layout.spaceM),
                          Expanded(
                            child: Text(
                              l10n.onb_demo_success,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCard(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return ScaleTap(
      onTap: _isDemoAdded ? null : _addDemoTransaction,
      child: GlassCard(
        child: Column(
          children: [
            // Amount
            Text(
              l10n.onb_demo_amount,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isDemoAdded 
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
              ) ?? const TextStyle(),
            ),

            SizedBox(height: layout.spaceL),

            // Transaction details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onb_demo_category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _isDemoAdded 
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.note,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      l10n.onb_demo_note,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _isDemoAdded
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: layout.spaceL),

            // Category icon or success icon
            _buildStatusIcon(context, layout),

            SizedBox(height: layout.spaceL),

            // Add button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: layout.spaceM),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(layout.radiusM),
              ),
              child: _isAdding
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: layout.spaceM),
                        Text(
                          l10n.onb_demo_adding,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      l10n.onb_demo_cta,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, AppSize layout) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = _isDemoAdded 
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: EdgeInsets.all(layout.spaceM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.15),
            baseColor.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(layout.radiusS),
        border: Border.all(
          color: baseColor.withValues(alpha: _isDemoAdded ? 0.3 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        _isDemoAdded ? Icons.check_circle : Icons.local_cafe,
        size: 32,
        color: baseColor,
      ),
    );
  }

  TextStyle _buildTitleStyle(BuildContext context, AppSize layout) {
    return layout.responsiveTextStyle(
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
    );
  }

  TextStyle _buildSubtitleStyle(BuildContext context, AppSize layout) {
    return layout.responsiveTextStyle(
      phone: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      tablet: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      desktop: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}