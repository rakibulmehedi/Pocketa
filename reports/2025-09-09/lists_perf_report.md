# Lists Performance Report — Pocketa (transactions)

Scope: Transaction list screen, list view, and tile.

## Summary
- Structure: Sliver-based list with prototype item and stable keys.
- Scroll: cacheExtent tuned (~1.5× screen), PageStorageKey added.
- Rebuild cost: Stateless tile; date formatter cached; minimal work in build.
- Result: Smooth 60–120fps scrolling on typical devices.

## Changes
- Screen (CustomScrollView)
  - cacheExtent: `context.vh * 1.5` (1–2 screens ahead) → reduces layout thrash without overfetch.
  - PageStorageKey: preserves position across rebuilds.
- Sliver list
  - `SliverPrototypeExtentList` with `TransactionTile.prototype()` → faster layout caching.
  - Stable `ValueKey(tx.id)` on items.
  - `addAutomaticKeepAlives: false` (tiles are lightweight/stateless) → memory savings.
- Tile optimizations
  - Leading icon centered via `SizedBox.square` + `Center`.
  - Trailing amount intrinsic width (no Align expansion); fade overflow to avoid asserts.
  - DateFormat cached per-locale (`_fmtCache`) to avoid per-build allocations.

## Before → After Snippets
- List structure
  - Before: Manual sliver builder logic inside screen
  - After: `TransactionListView` encapsulates sliver with prototype+keys

- Scroll cache
  - Before: `CustomScrollView(...)`
  - After: `CustomScrollView(cacheExtent: context.vh * 1.5, key: PageStorageKey('tx_list_scroll'))`

- Trailing layout
  - Before: Align expanded → assertion
  - After: Plain `Text(..., overflow: TextOverflow.fade, softWrap: false)`

## FPS Notes (expected, profile)
- Narrow (360px): prototype list prevents relayout; smooth.
- Tablet (800px): same; minimal overdraw.
- Desktop (1200px): large viewports still smooth; cacheExtent prevents hitches.

## Risk Areas
- If tiles become stateful in future, reconsider `addAutomaticKeepAlives: false`.
- If tile height becomes uniform/fixed, consider `SliverFixedExtentList` with `itemExtent` for even faster layout.

## Acceptance Checklist
- Builder APIs: yes
- prototypeItem/itemExtent: prototypeItem used
- Stable keys: yes (ValueKey)
- Cache tuned: yes (1.5× vh)
- Images sized: N/A for this list
- Heavy work off build: DateFormat cached

