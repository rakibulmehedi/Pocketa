import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_color_scheme.dart';
import 'package:pocketa/shared/ui/motion.dart';

/// Unified footer component with Back + Primary CTA
/// Replaces FooterCtas and all other footer implementations
/// Features:
/// - Safe area handling
/// - Responsive constraints (640px phone/tablet, 840px desktop)
/// - Glass/blur effect with proper bounds
/// - Loading and disabled states
/// - Accessibility support
class FooterCtaBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel; // e.g., Back
  final VoidCallback? onSecondary;
  final bool loading;
  final bool disabled;
  final bool isPrimaryEnabled;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;
  final EdgeInsets? padding; // default from context.layout

  const FooterCtaBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.loading = false,
    this.disabled = false,
    this.isPrimaryEnabled = true,
    this.primaryIcon,
    this.secondaryIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final layout = context.layout;

    return SafeArea(
      top: false,
      bottom: true,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              layout.pageGutter.horizontal,
              layout.spaceL,
              layout.pageGutter.horizontal,
              layout.spaceL + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.85),
                  colorScheme.surface.withValues(alpha: 0.95),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.12),
                  width: 0.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, -12),
                ),
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: _buildButtons(context, layout, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, AppSize layout, ThemeData theme) {
    return Row(
      children: [
        // Back button (if enabled)
        if (secondaryLabel != null && onSecondary != null) ...[
          ScaleTap(
            scale: 0.96,
            duration: Motion.d120,
            hapticType: HapticFeedbackType.light,
            onTap: disabled ? null : onSecondary,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColorScheme.cardGradient(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                secondaryIcon ?? Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: layout.spaceM),
        ],

        // Primary button
        Expanded(
          child: ScaleTap(
            scale: 0.96,
            duration: Motion.d120,
            hapticType: HapticFeedbackType.medium,
            onTap: (isPrimaryEnabled && !loading) ? onPrimary : null,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: (isPrimaryEnabled && !loading)
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.85),
                        ],
                      )
                    : AppColorScheme.cardGradient(context),
                borderRadius: BorderRadius.circular(16),
                border: (isPrimaryEnabled && !loading)
                    ? null
                    : Border.all(
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.15),
                        width: 1,
                      ),
                boxShadow: (isPrimaryEnabled && !loading)
                    ? [
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color:
                              theme.colorScheme.shadow.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color:
                              theme.colorScheme.shadow.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: layout.spaceXL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loading) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: layout.spaceS),
                    ],
                    Text(
                      loading ? 'Loading...' : primaryLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: (isPrimaryEnabled && !loading)
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isPrimaryEnabled && !loading) ...[
                      SizedBox(width: layout.spaceS),
                      Icon(
                        primaryIcon ?? Icons.arrow_forward_ios_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
