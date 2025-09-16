import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// Enhanced responsive container with consistent styling
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final bool centerChild;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.gradient,
    this.width,
    this.height,
    this.alignment,
    this.centerChild = false,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    final Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(layout.spaceL),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? layout.radiusL,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: border,
        gradient: gradient,
      ),
      alignment: alignment,
      child: centerChild ? Center(child: child) : child,
    );

    return content;
  }
}

/// Enhanced responsive grid with consistent spacing
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding,
    this.margin,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    final responsiveCrossAxisCount = crossAxisCount ?? layout.responsiveSize(
      phone: 1,
      tablet: 2,
      desktop: 3,
    ).toInt();
    
    final responsiveMainAxisSpacing = mainAxisSpacing ?? layout.spaceM;
    final responsiveCrossAxisSpacing = crossAxisSpacing ?? layout.spaceM;

    return Container(
      margin: margin,
      child: GridView.builder(
        controller: controller,
        padding: padding ?? layout.pageGutter,
        physics: physics,
        shrinkWrap: shrinkWrap,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsiveCrossAxisCount,
          mainAxisSpacing: responsiveMainAxisSpacing,
          crossAxisSpacing: responsiveCrossAxisSpacing,
          childAspectRatio: 1.0,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }
}

/// Enhanced responsive row with consistent spacing
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool wrap;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
    this.padding,
    this.margin,
    this.wrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final responsiveSpacing = spacing ?? layout.spaceM;

    Widget content = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildrenWithSpacing(responsiveSpacing),
    );

    if (wrap) {
      content = Wrap(
        direction: Axis.horizontal,
        alignment: _getWrapAlignment(mainAxisAlignment),
        crossAxisAlignment: _getWrapCrossAlignment(crossAxisAlignment),
        spacing: responsiveSpacing,
        children: children,
      );
    }

    if (padding != null || margin != null) {
      content = Container(
        padding: padding,
        margin: margin,
        child: content,
      );
    }

    return content;
  }

  List<Widget> _buildChildrenWithSpacing(double spacing) {
    if (children.isEmpty) return children;
    
    final result = <Widget>[children.first];
    for (int i = 1; i < children.length; i++) {
      result.add(SizedBox(width: spacing));
      result.add(children[i]);
    }
    return result;
  }

  WrapAlignment _getWrapAlignment(MainAxisAlignment alignment) {
    switch (alignment) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }

  WrapCrossAlignment _getWrapCrossAlignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.stretch:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.baseline:
        return WrapCrossAlignment.start;
    }
  }
}

/// Enhanced responsive column with consistent spacing
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final responsiveSpacing = spacing ?? layout.spaceM;

    Widget content = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _buildChildrenWithSpacing(responsiveSpacing),
    );

    if (padding != null || margin != null) {
      content = Container(
        padding: padding,
        margin: margin,
        child: content,
      );
    }

    return content;
  }

  List<Widget> _buildChildrenWithSpacing(double spacing) {
    if (children.isEmpty) return children;
    
    final result = <Widget>[children.first];
    for (int i = 1; i < children.length; i++) {
      result.add(SizedBox(height: spacing));
      result.add(children[i]);
    }
    return result;
  }
}

/// Enhanced responsive stack with consistent positioning
class ResponsiveStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ResponsiveStack({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );

    if (padding != null || margin != null) {
      content = Container(
        padding: padding,
        margin: margin,
        child: content,
      );
    }

    return content;
  }
}

/// Enhanced responsive divider with consistent styling
class ResponsiveDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final Axis direction;

  const ResponsiveDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Divider(
      height: height ?? layout.spaceM,
      thickness: thickness ?? 1,
      color: color ?? theme.colorScheme.outline.withValues(alpha: 0.2),
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
    );
  }
}

/// Enhanced responsive spacer with consistent sizing
class ResponsiveSpacer extends StatelessWidget {
  final double? flex;
  final double? height;
  final double? width;

  const ResponsiveSpacer({
    super.key,
    this.flex,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    if (height != null || width != null) {
      return SizedBox(
        height: height ?? layout.spaceM,
        width: width ?? layout.spaceM,
      );
    }
    
    return Spacer(flex: flex?.toInt() ?? 1);
  }
}

/// Enhanced responsive safe area with consistent padding
class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets? minimum;
  final bool maintainBottomViewPadding;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}
