import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// A standardized form section widget that provides consistent styling
/// and layout for form fields across the application.
class AppFormSection extends StatelessWidget {
  const AppFormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.isCollapsible = false,
    this.isExpanded = true,
    this.onToggle,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final bool isCollapsible;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    
    return UnifiedAnimations.fadeSlideIn(
      child: Container(
        padding: padding ?? EdgeInsets.all(layout.spaceL),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(layout.radiusL),
          boxShadow: elevation != null
              ? [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: elevation!,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, layout, theme),
            
            // Content
            if (isExpanded) ...[
              SizedBox(height: layout.spaceM),
              ...children,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppSize layout, ThemeData theme) {
    return Row(
      children: [
        // Icon
        if (icon != null) ...[
          Icon(
            icon,
            size: layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24),
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: layout.spaceM),
        ],
        
        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.responsiveTitle(context),
              ),
              if (subtitle != null) ...[
                SizedBox(height: layout.spaceS),
                Text(
                  subtitle!,
                  style: AppTextStyles.responsiveBody(context),
                ),
              ],
            ],
          ),
        ),
        
        // Toggle Button
        if (isCollapsible)
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24),
            ),
          ),
      ],
    );
  }
}

/// A specialized form section for transaction forms
class TransactionFormSection extends StatelessWidget {
  const TransactionFormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.isRequired = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return AppFormSection(
      title: isRequired ? '$title *' : title,
      subtitle: subtitle,
      icon: icon,
      padding: EdgeInsets.all(layout.spaceL),
      children: children,
    );
  }
}

/// A specialized form section for wallet forms
class WalletFormSection extends StatelessWidget {
  const WalletFormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return AppFormSection(
      title: title,
      subtitle: subtitle,
      icon: icon ?? Icons.account_balance_wallet_outlined,
      padding: EdgeInsets.all(layout.spaceL),
      children: children,
    );
  }
}

/// A specialized form section for category forms
class CategoryFormSection extends StatelessWidget {
  const CategoryFormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return AppFormSection(
      title: title,
      subtitle: subtitle,
      icon: icon ?? Icons.category_outlined,
      padding: EdgeInsets.all(layout.spaceL),
      children: children,
    );
  }
}
