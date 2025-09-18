import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';

class OnboardingCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;
  final Widget? trailing;
  final EdgeInsets? padding;
  final bool showGlow;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
    this.trailing,
    this.padding,
    this.showGlow = true,
  });

  @override
  State<OnboardingCard> createState() => _OnboardingCardState();
}

class _OnboardingCardState extends State<OnboardingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    final accentColor = widget.accentColor ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: widget.padding ?? EdgeInsets.all(layout.spaceL),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor,
                          accentColor.withValues(alpha: 0.8),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.cardBackground(context),
                          AppColors.cardBackground(context).withValues(alpha: 0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(layout.radiusL),
                border: Border.all(
                  color: widget.isSelected
                      ? accentColor
                      : AppColors.borderMedium(context),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isSelected
                        ? accentColor.withValues(alpha: 0.3)
                        : AppColors.shadowLight(context),
                    blurRadius: widget.isSelected ? 12 : 6,
                    offset: Offset(0, widget.isSelected ? 6 : 3),
                  ),
                  if (widget.showGlow && widget.isSelected)
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2 * _glowAnimation.value),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.emoji,
                        style: TextStyle(
                          fontSize: layout.responsiveSize(
                            phone: 20,
                            tablet: 24,
                            desktop: 28,
                          ),
                        ),
                      ),
                      SizedBox(width: layout.spaceM),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: layout.responsiveTextStyle(
                            phone: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? AppColors.buttonTextPrimary(context)
                                  : AppColors.textPrimary(context),
                              letterSpacing: 0.3,
                            ),
                            tablet: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? AppColors.buttonTextPrimary(context)
                                  : AppColors.textPrimary(context),
                              letterSpacing: 0.3,
                            ),
                            desktop: theme.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? AppColors.buttonTextPrimary(context)
                                  : AppColors.textPrimary(context),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      if (widget.isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.buttonTextPrimary(context),
                          size: layout.responsiveIconSize(
                            phone: 20,
                            tablet: 22,
                            desktop: 24,
                          ),
                        ),
                      if (widget.trailing != null) ...[
                        SizedBox(width: layout.spaceS),
                        widget.trailing!,
                      ],
                    ],
                  ),
                  SizedBox(height: layout.spaceS),
                  Text(
                    widget.subtitle,
                    style: layout.responsiveTextStyle(
                      phone: theme.textTheme.bodySmall!.copyWith(
                        color: widget.isSelected
                            ? AppColors.buttonTextPrimary(context).withValues(alpha: 0.8)
                            : AppColors.textSecondary(context),
                        letterSpacing: 0.2,
                      ),
                      tablet: theme.textTheme.bodyMedium!.copyWith(
                        color: widget.isSelected
                            ? AppColors.buttonTextPrimary(context).withValues(alpha: 0.8)
                            : AppColors.textSecondary(context),
                        letterSpacing: 0.2,
                      ),
                      desktop: theme.textTheme.bodyLarge!.copyWith(
                        color: widget.isSelected
                            ? AppColors.buttonTextPrimary(context).withValues(alpha: 0.8)
                            : AppColors.textSecondary(context),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
