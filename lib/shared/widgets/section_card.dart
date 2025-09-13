import 'package:flutter/material.dart';
import 'package:pocketa/core/design_system/design_system.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing; // optional action button beside title
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool showDivider;
  final bool elevated;

  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.children,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.showDivider = true,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DesignTokens.animationNormal,
      curve: Curves.easeOutCubic,
      margin: margin ?? EdgeInsets.symmetric(
        vertical: DesignTokens.spaceM,
        horizontal: DesignTokens.spaceXs,
      ),
      padding: padding ?? DesignTokens.getCardPadding(context),
      decoration: elevated 
          ? ComponentTokens.elevatedCardDecoration(context)
          : ComponentTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || trailing != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: TypographyTokens.titleLarge(context).copyWith(
                            fontWeight: DesignTokens.fontWeightBold,
                            color: ColorTokens.textPrimary(context),
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: DesignTokens.spaceXs),
                          Container(
                            padding: DesignTokens.getResponsivePadding(
                              context,
                              horizontal: DesignTokens.spaceS,
                              vertical: DesignTokens.spaceXs,
                            ),
                            decoration: BoxDecoration(
                              color: ColorTokens.primaryLight(context),
                              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            ),
                            child: Text(
                              subtitle!,
                              style: TypographyTokens.bodySmall(context).copyWith(
                                color: ColorTokens.primary(context),
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
            if (showDivider)
              Container(
                margin: EdgeInsets.symmetric(vertical: DesignTokens.spaceM),
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorTokens.primaryMedium(context),
                      ColorTokens.borderSubtle(context),
                    ],
                  ),
                ),
              ),
          ],
          ...children,
        ],
      ),
    );
  }
}
