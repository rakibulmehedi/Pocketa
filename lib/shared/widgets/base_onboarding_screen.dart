import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// Base onboarding screen that provides common functionality and layout
/// for all onboarding screens in the app.
abstract class BaseOnboardingScreen extends ConsumerStatefulWidget {
  const BaseOnboardingScreen({super.key});

  /// The current step of the onboarding process
  String get currentStep;

  /// Whether to show the progress indicator
  bool get showProgressIndicator => true;

  /// Whether to show the dots indicator
  bool get showDotsIndicator => true;

  /// Whether to show the bottom footer
  bool get showBottomFooter => true;

  /// The main content widget for this onboarding step
  Widget buildContent(BuildContext context, AppSize layout);

  /// Optional custom header widget
  Widget? buildHeader(BuildContext context, AppSize layout) => null;

  /// Optional custom footer widget
  Widget? buildCustomFooter(BuildContext context, AppSize layout) => null;

  /// Called when the next button is pressed
  void onNext(BuildContext context, WidgetRef ref);

  /// Called when the previous button is pressed
  void onPrevious(BuildContext context, WidgetRef ref);

  /// Whether the next button should be enabled
  bool isNextEnabled(BuildContext context, WidgetRef ref) => true;

  /// Whether the previous button should be shown
  bool showPreviousButton(BuildContext context, WidgetRef ref) => true;

  /// The text for the next button
  String getNextButtonText(BuildContext context) => 'Next';

  /// The text for the previous button
  String getPreviousButtonText(BuildContext context) => 'Previous';

  @override
  ConsumerState<BaseOnboardingScreen> createState() => _BaseOnboardingScreenState();
}

class _BaseOnboardingScreenState extends ConsumerState<BaseOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            if (widget.buildHeader(context, layout) != null)
              UnifiedAnimations.fadeSlideIn(
                child: widget.buildHeader(context, layout)!,
                duration: UnifiedAnimations.normal,
                curve: UnifiedAnimations.easeOut,
              ),

            // Progress Indicator
            if (widget.showProgressIndicator)
              _buildProgressIndicator(context, layout),

            // Main Content
            Expanded(
              child: UnifiedAnimations.fadeSlideIn(
                child: widget.buildContent(context, layout),
                duration: UnifiedAnimations.slow,
                curve: UnifiedAnimations.easeOut,
              ),
            ),

            // Dots Indicator
            if (widget.showDotsIndicator)
              _buildDotsIndicator(context, layout),

            // Bottom Footer
            if (widget.showBottomFooter)
              _buildBottomFooter(context, layout),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, AppSize layout) {
    final theme = Theme.of(context);
    
    return UnifiedAnimations.fadeIn(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: layout.pageGutter.horizontal,
          vertical: layout.spaceL,
        ),
        child: Column(
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
                widthFactor: _getProgressValue(),
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
              '${_getCurrentStepNumber()}/${_getTotalSteps()}',
              style: AppTextStyles.responsiveCaption(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsIndicator(BuildContext context, AppSize layout) {
    final theme = Theme.of(context);
    
    return UnifiedAnimations.fadeIn(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: layout.pageGutter.horizontal,
          vertical: layout.spaceL,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _getTotalSteps(),
            (index) => _buildDot(context, layout, index, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(BuildContext context, AppSize layout, int index, ThemeData theme) {
    final isActive = index == _getCurrentStepNumber() - 1;
    final isCompleted = index < _getCurrentStepNumber() - 1;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: layout.responsiveSize(phone: 4, tablet: 6, desktop: 8)),
      child: AnimatedContainer(
        duration: UnifiedAnimations.fast,
        curve: UnifiedAnimations.easeInOut,
        width: layout.responsiveSize(
          phone: isActive ? 24 : 8,
          tablet: isActive ? 28 : 10,
          desktop: isActive ? 32 : 12,
        ),
        height: layout.responsiveSize(phone: 8, tablet: 10, desktop: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 4, tablet: 5, desktop: 6)),
          color: isActive || isCompleted
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context, AppSize layout) {
    final theme = Theme.of(context);
    
    return UnifiedAnimations.fadeSlideIn(
      child: Container(
        padding: EdgeInsets.all(layout.pageGutter.horizontal),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Previous Button
            if (widget.showPreviousButton(context, ref))
              Expanded(
                child: _buildButton(
                  context,
                  layout,
                  text: widget.getPreviousButtonText(context),
                  isPrimary: false,
                  onPressed: () => widget.onPrevious(context, ref),
                ),
              ),
            
            if (widget.showPreviousButton(context, ref))
              SizedBox(width: layout.spaceM),
            
            // Next Button
            Expanded(
              flex: 2,
              child: _buildButton(
                context,
                layout,
                text: widget.getNextButtonText(context),
                isPrimary: true,
                onPressed: widget.isNextEnabled(context, ref)
                    ? () => widget.onNext(context, ref)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    AppSize layout,
    {
    required String text,
    required bool isPrimary,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        foregroundColor: isPrimary
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(
          vertical: layout.responsiveSize(phone: 16, tablet: 20, desktop: 24),
          horizontal: layout.responsiveSize(phone: 24, tablet: 32, desktop: 40),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 12, tablet: 16, desktop: 20)),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: Text(
        text,
        style: AppTextStyles.responsiveButton(context),
      ),
    );
  }

  double _getProgressValue() {
    // This should be implemented by subclasses based on their specific progress logic
    return 0.5; // Default implementation
  }

  int _getCurrentStepNumber() {
    // This should be implemented by subclasses based on their specific step logic
    return 1; // Default implementation
  }

  int _getTotalSteps() {
    // This should be implemented by subclasses based on their total steps
    return 5; // Default implementation
  }
}
