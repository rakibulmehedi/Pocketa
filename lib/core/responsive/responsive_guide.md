
# 📱 Pocketa Responsive System Guide

**Author:** @Rakibul Islam Mehedi  
**Source:** `lib/core/responsive/responsive.dart`  
**Version:** Flutter 3.x / Dart 3.x  

---

## 1. What & Why
- **One top-level scope → cheap subtree**  
  MediaQuery/LayoutBuilder একবারই পড়া হয়। ডীপ উইজেটগুলো শুধু Inherited scope ব্যবহার করে।  

- **Lean + Rich API একসাথে**  
  - Lean → `context.device`, `context.vw`, `context.vh`  
  - Rich → `context.layout` (spacing, gutter, textScale, grid helpers ইত্যাদি)  

- **Rotation-safe**: shortest side ব্যবহার করে breakpoint সেট হয়।  
- **Accessibility-aware**: textScale user setting রেসপেক্ট করে, পরে clamp করা হয়।  

---

## 2. Install Once
```dart
return MaterialApp(
  builder: (ctx, child) => Responsive.builder(
    child: child ?? const SizedBox(),
  ),
);

⚠️ প্রতি route subtree-তে মাত্র ১টা scope। Nested Responsive.builder ব্যবহার করবে না।

⸻

3. Common Use-Cases

Page with centered content

final L = context.layout;
Padding(
  padding: L.pageGutter,
  child: Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: L.isDesktop ? 1000 : (L.isTablet ? 720 : double.infinity),
      ),
      child: child,
    ),
  ),
);

Grid auto columns

final L = context.layout;
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: L.columnsFor(280),
    crossAxisSpacing: L.spaceM,
    mainAxisSpacing: L.spaceM,
  ),
  itemCount: 12,
  itemBuilder: (_, i) => const _StatCard(),
);

Adaptive AppBar

SliverAppBar(
  toolbarHeight: L.isDesktop ? L.rem(9) : L.rem(7),
  expandedHeight: (0.22.h(context)).clamp(180.0, 260.0),
  leading: Icon(Icons.arrow_back, size: L.iconM),
  title: Text(S.of(context).dashboard),
);

Typography + Spacing

Text(
  S.of(context).welcome_title,
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    fontSize: L.t2xl,
  ),
);
SizedBox(height: L.space2xl);


⸻

4. Migration Cheatsheet

Before	After
MediaQuery.of(context).size.width	context.vw
MediaQuery.of(context).size.height	context.vh
EdgeInsets.symmetric(horizontal: 16)	context.layout.pageGutter
if (w > 800)	context.layout.isTablet
Nested LayoutBuilder	Use top Responsive.builder
Hardcoded text scale	context.layout.textScale


⸻

5. API Reference

Lean
	•	context.device → DeviceSize.phone / tablet / desktop
	•	context.vw / context.vh

Rich
	•	context.layout.spaceS / spaceM / spaceL / spaceXl
	•	context.layout.insetsAll(2)
	•	context.layout.iconM
	•	context.layout.t2xl
	•	context.layout.isMobile / isTablet / isDesktop
	•	context.layout.columnsFor(minTileWidth)

Numeric sugar
	•	2.rem(context)
	•	16.sp(context)
	•	24.ic(context)
	•	0.5.w(context) / 0.3.h(context)

⸻

6. Performance Notes
	•	Scope recompute only once → deep subtree cheap.
	•	Always use const where possible.
	•	Avoid nested MediaQuery/LayoutBuilder.
	•	Use maxLines + TextOverflow.ellipsis to prevent overflow.

⸻

7. Edge Cases
	•	Small phones (<360) → compact breakpoint.
	•	Desktop web → slight scale boost (~0.98).
	•	Keyboard open → layout.viewInsetsBottom already adjusts gutters.

⸻

8. Testing

testWidgets('columns adapt at breakpoints', (tester) async {
  await tester.pumpWidget(_wrap(const _Probe(), w: 360));
  expect(find.textContaining('cols=1'), findsOneWidget);

  await tester.pumpWidget(_wrap(const _Probe(), w: 800));
  expect(find.textContaining('cols='), findsOneWidget);
});


⸻

9. Commit Message Template

feat(responsive): centralize layouts via responsive scope and tokens


⸻

10. Migration Plan
	1.	Add Responsive.builder at app root.
	2.	Search/Replace MediaQuery → context.vw/context.vh.
	3.	Replace paddings → context.layout.pageGutter.
	4.	Remove SizeConfig/ScreenUtil clones.
	5.	Validate 360/800/1200 px screens.
