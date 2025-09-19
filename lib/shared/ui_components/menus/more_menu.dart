import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// More menu with delete and extra options
class MoreMenu extends StatelessWidget {
  /// If null, the Delete row is hidden.
  final VoidCallback? onDelete;

  /// Optional extra items if you want to extend later.
  final List<PopupMenuEntry<String>>? extraItems;

  const MoreMenu({super.key, this.onDelete, this.extraItems});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      tooltip: t.more,
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (ctx) {
        final items = <PopupMenuEntry<String>>[];

        // Extra items first (if any)
        if (extraItems != null && extraItems!.isNotEmpty) {
          items.addAll(extraItems!);
          items.add(const PopupMenuDivider());
        }

        // Delete (only if provided)
        if (onDelete != null) {
          items.add(
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(children: [
                const Icon(Icons.delete_outline, size: 18),
                const SizedBox(width: 8),
                Text(t.delete),
              ]),
            ),
          );
        }

        // If nothing to show, still build an empty list (button will be disabled by Flutter)
        return items;
      },
      onSelected: (value) {
        if (value == 'delete') {
          onDelete?.call();
        }
      },
    );
  }
}
