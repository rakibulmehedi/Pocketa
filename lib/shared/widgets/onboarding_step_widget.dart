import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// A reusable widget for individual onboarding steps
class OnboardingStepWidget extends StatelessWidget {
  const OnboardingStepWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.icon,
    this.illustration,
    this.actions,
    this.showProgress = true,
    this.progressValue = 0.5,
    this.stepNumber = 1,
    this.totalSteps = 5,
  });

  final String title;
  final String subtitle;
  final Widget content;
  final Widget? icon;
  final Widget? illustration;
  final List<Widget>? actions;
  final bool showProgress;
  final double progressValue;
  final int stepNumber;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(layout.pageGutter.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Indicator
          if (showProgress) _buildProgressIndicator(context, layout),

          SizedBox(height: layout.spaceXL),

          // Icon or Illustration
          if (icon != null || illustration != null)
            Center(
              child: UnifiedAnimations.scaleIn(
                child: icon ?? illustration!,
                duration: UnifiedAnimations.normal,
                curve: UnifiedAnimations.easeOut,
              ),
            ),

          if (icon != null || illustration != null)
            SizedBox(height: layout.spaceXL),

          // Title
          UnifiedAnimations.fadeSlideIn(
            child: Text(
              title,
              style: AppTextStyles.responsiveDisplay(context),
              textAlign: TextAlign.center,
            ),
            duration: UnifiedAnimations.normal,
            curve: UnifiedAnimations.easeOut,
            delay: const Duration(milliseconds: 100),
          ),

          SizedBox(height: layout.spaceL),

          // Subtitle
          UnifiedAnimations.fadeSlideIn(
            child: Text(
              subtitle,
              style: AppTextStyles.responsiveBody(context),
              textAlign: TextAlign.center,
            ),
            duration: UnifiedAnimations.normal,
            curve: UnifiedAnimations.easeOut,
            delay: const Duration(milliseconds: 200),
          ),

          SizedBox(height: layout.spaceXL),

          // Content
          UnifiedAnimations.fadeSlideIn(
            child: content,
            duration: UnifiedAnimations.slow,
            curve: UnifiedAnimations.easeOut,
            delay: const Duration(milliseconds: 300),
          ),

          if (actions != null) ...[
            SizedBox(height: layout.spaceXL),
            UnifiedAnimations.fadeSlideIn(
              child: Column(
                children: actions!,
              ),
              duration: UnifiedAnimations.normal,
              curve: UnifiedAnimations.easeOut,
              delay: const Duration(milliseconds: 400),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, AppSize layout) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Progress Bar
        Container(
          height: layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 2, tablet: 3, desktop: 4)),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressValue,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 2, tablet: 3, desktop: 4)),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: layout.spaceM),
        // Progress Text
        Text(
          '$stepNumber/$totalSteps',
          style: AppTextStyles.responsiveCaption(context),
        ),
      ],
    );
  }
}

/// A specialized widget for feature awareness slides
class FeatureAwarenessSlide extends StatelessWidget {
  const FeatureAwarenessSlide({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.illustration,
    this.isActive = false,
    this.onTap,
  });

  final String title;
  final String description;
  final Widget icon;
  final Widget? illustration;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: UnifiedAnimations.normal,
        curve: UnifiedAnimations.easeInOut,
        padding: EdgeInsets.all(layout.responsiveSize(phone: 20, tablet: 24, desktop: 28)),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 16, tablet: 20, desktop: 24)),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: layout.responsiveSize(phone: 8, tablet: 12, desktop: 16),
                    spreadRadius: layout.responsiveSize(phone: 2, tablet: 4, desktop: 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            UnifiedAnimations.scaleIn(
              child: icon,
              duration: UnifiedAnimations.normal,
              curve: UnifiedAnimations.easeOut,
            ),
            
            SizedBox(height: layout.spaceL),
            
            // Title
            Text(
              title,
              style: AppTextStyles.responsiveTitle(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: layout.spaceM),
            
            // Description
            Text(
              description,
              style: AppTextStyles.responsiveBody(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A specialized widget for personalization cards
class PersonalizationCard extends StatelessWidget {
  const PersonalizationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isSelected = false,
    this.isCompleted = false,
    this.onTap,
  });

  final String title;
  final String description;
  final Widget icon;
  final bool isSelected;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: UnifiedAnimations.fast,
        curve: UnifiedAnimations.easeInOut,
        padding: EdgeInsets.all(layout.responsiveSize(phone: 16, tablet: 20, desktop: 24)),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: layout.responsiveSize(phone: 6, tablet: 8, desktop: 10),
                    spreadRadius: layout.responsiveSize(phone: 1, tablet: 2, desktop: 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            // Icon with completion indicator
            Stack(
              children: [
                UnifiedAnimations.scaleIn(
                  child: icon,
                  duration: UnifiedAnimations.fast,
                  curve: UnifiedAnimations.easeOut,
                ),
                if (isCompleted)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: layout.responsiveSize(phone: 20, tablet: 24, desktop: 28),
                      height: layout.responsiveSize(phone: 20, tablet: 24, desktop: 28),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: theme.colorScheme.onPrimary,
                        size: layout.responsiveSize(phone: 12, tablet: 14, desktop: 16),
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: layout.spaceM),
            
            // Title
            Text(
              title,
              style: AppTextStyles.responsiveLabel(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: layout.spaceS),
            
            // Description
            Text(
              description,
              style: AppTextStyles.responsiveNote(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
