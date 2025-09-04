import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/shared/widgets/glass_container.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class SummaryRow extends StatelessWidget {
  final double income, expense, net;
  const SummaryRow({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final L = context.layout;

    Widget statTile({
      required String label,
      required double value,
      required Color accent,
      required IconData icon,
      required double tileWidth,
      required bool compact,
    }) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: tileWidth.clamp(140, double.infinity),
          maxWidth: tileWidth,
          minHeight: compact ? 56 : 64,
        ),
        child: GlassContainer(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 10 : 12,
            horizontal: compact ? 12 : 14,
          ),
          blur: compact ? 12 : 16,
          opacity: compact ? 0.18 : 0.12,
          borderRadius: BorderRadius.circular(compact ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: compact ? 18 : 20,
                  color: accent.withValues(alpha: 0.9)),
              SizedBox(width: L.spaceS),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: compact ? 12 : 14.5,
                      ),
                    ),
                    SizedBox(height: L.spaceXs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatAmount(value, currency: '৳'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: compact ? 16 : 18,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget netTile({
      required double tileWidth,
      required bool compact,
    }) {
      final isPositive = net >= 0;
      final accent =
          isPositive ? Colors.greenAccent.shade400 : Colors.redAccent.shade400;
      final icon =
          isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;

      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: tileWidth.clamp(160, double.infinity),
          maxWidth: tileWidth,
          minHeight: compact ? 64 : 72,
        ),
        child: GlassContainer(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 12 : 14,
            horizontal: compact ? 14 : 16,
          ),
          blur: compact ? 12 : 16,
          opacity: compact ? 0.18 : 0.12,
          borderRadius: BorderRadius.circular(compact ? 12 : 16),
          child: Row(
            children: [
              Container(
                height: compact ? 36 : 48,
                width: compact ? 36 : 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent),
              ),
              SizedBox(width: L.spaceS),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.netBalance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: L.spaceXs),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatAmount(net, currency: '৳ '),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isPositive ? t.surplus : t.deficit,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (ctx, c) {
        final compact = L.isMobile || L.isCompact;
        final spacing = L.spaceS;
        // phone: 1 col, tablet/desktop: 3 col
        final cols = L.isDesktop ? 3 : (L.isTablet ? 3 : 1);
        final totalGap = spacing * (cols - 1);
        final tileW = (c.maxWidth - totalGap) / cols;

        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: L.rem(1.5), vertical: L.rem(1)),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              statTile(
                label: t.income,
                value: income,
                accent: Colors.greenAccent.shade400,
                icon: Icons.south_west_rounded,
                tileWidth: tileW,
                compact: compact,
              ),
              statTile(
                label: t.expense,
                value: expense,
                accent: Colors.redAccent.shade400,
                icon: Icons.north_east_rounded,
                tileWidth: tileW,
                compact: compact,
              ),
              netTile(tileWidth: tileW, compact: compact),
            ],
          ),
        );
      },
    );
  }
}
