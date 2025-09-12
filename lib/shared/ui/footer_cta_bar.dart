import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
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
    this.primaryIcon,
    this.secondaryIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final device = context.device;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: device == DeviceSize.desktop ? 840 : 640,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.85),
                    border: Border.all(
                      color: colorScheme.outline.withValues(
                        alpha: theme.brightness == Brightness.dark ? 0.16 : 0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        if (secondaryLabel != null && onSecondary != null) ...[
                          Flexible(
                            child: ScaleTap(
                              onTap: disabled ? null : onSecondary,
                              child: OutlinedButton.icon(
                                onPressed: null, // Disable default onPressed since we're using ScaleTap
                                icon: Icon(secondaryIcon ?? Icons.arrow_back_rounded),
                                label: Text(secondaryLabel!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        const Spacer(),
                        Flexible(
                          child: ScaleTap(
                            onTap: disabled || loading ? null : onPrimary,
                            child: FilledButton.icon(
                              onPressed: null, // Disable default onPressed since we're using ScaleTap
                              icon: loading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : Icon(primaryIcon ?? Icons.check),
                              label: Text(loading ? 'Loading...' : primaryLabel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
