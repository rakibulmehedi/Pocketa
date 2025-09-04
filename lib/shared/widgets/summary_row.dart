// lib/shared/widgets/summary_row.dart
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/glass_container.dart';

/// SummaryRow
/// - Always shows **Income & Expense in a single Row**
/// - Net card sits below as a full-width tile (wraps nicely on small screens)
/// - Overflow-safe, responsive, and fast (no nested LayoutBuilders in deep tree)
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

    final compact = L.isMobile || L.isCompact;
    final spacing = L.spaceS;

    return Padding(
      // keep header/body rhythm consistent
      padding:
          EdgeInsets.fromLTRB(L.rem(1.5), kToolbarHeight, L.rem(1.5), L.rem(1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row: Income • Expense ───────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: t.income,
                  value: income,
                  accent: Colors.greenAccent.shade400,
                  icon: Icons.south_west_rounded,
                  compact: compact,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _StatTile(
                  label: t.expense,
                  value: expense,
                  accent: Colors.redAccent.shade400,
                  icon: Icons.north_east_rounded,
                  compact: compact,
                ),
              ),
            ],
          ),

          SizedBox(height: L.spaceM),

          // ── Net (full-width; clamps nicely on wide screens) ────────────────
          ConstrainedBox(
            constraints: BoxConstraints(
              // center-ish width on tablet/desktop so it doesn't look too wide
              maxWidth:
                  L.isDesktop ? 640 : (L.isTablet ? 560 : double.infinity),
            ),
            child: _NetTile(
              title: t.netBalance,
              net: net,
              positiveAccent: Colors.greenAccent.shade400,
              negativeAccent: Colors.redAccent.shade400,
              compact: compact,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Tiles
// ──────────────────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final double value;
  final Color accent;
  final IconData icon;
  final bool compact;

  const _StatTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final theme = Theme.of(context);

    return GlassContainer(
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
          Icon(icon, size: compact ? 18 : 20, color: accent.withOpacity(0.9)),
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
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
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
    );
  }
}

class _NetTile extends StatelessWidget {
  final String title;
  final double net;
  final Color positiveAccent;
  final Color negativeAccent;
  final bool compact;

  const _NetTile({
    required this.title,
    required this.net,
    required this.positiveAccent,
    required this.negativeAccent,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final theme = Theme.of(context);

    final isPositive = net >= 0;
    final accent = isPositive ? positiveAccent : negativeAccent;
    final icon =
        isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return GlassContainer(
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
              color: accent.withOpacity(0.12),
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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isPositive
                  ? AppLocalizations.of(context).surplus
                  : AppLocalizations.of(context).deficit,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
