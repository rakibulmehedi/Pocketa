import 'package:flutter/material.dart';
import 'package:pocketa/core/design_system/design_tokens.dart';
import 'package:pocketa/core/design_system/color_tokens.dart';
import 'package:pocketa/core/design_system/typography_tokens.dart';

/// Comprehensive component system for consistent UI implementation
class ComponentTokens {
  ComponentTokens._();

  // ── Button Styles ─────────────────────────────────────────────────────────
  
  /// Primary button style
  static ButtonStyle primaryButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: ColorTokens.buttonPrimary(context),
      foregroundColor: ColorTokens.buttonOnPrimary(context),
      disabledBackgroundColor: ColorTokens.buttonDisabled(context),
      disabledForegroundColor: ColorTokens.buttonOnDisabled(context),
      elevation: DesignTokens.elevation1,
      shadowColor: ColorTokens.shadowLight(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusS,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
      ),
      padding: DesignTokens.getButtonPadding(context),
      minimumSize: Size(0, DesignTokens.getButtonHeight(context)),
      textStyle: TypographyTokens.buttonText(context),
    );
  }

  /// Secondary button style
  static ButtonStyle secondaryButton(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: ColorTokens.buttonSecondary(context),
      disabledForegroundColor: ColorTokens.buttonOnDisabled(context),
      side: BorderSide(
        color: ColorTokens.borderMedium(context),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusS,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
      ),
      padding: DesignTokens.getButtonPadding(context),
      minimumSize: Size(0, DesignTokens.getButtonHeight(context)),
      textStyle: TypographyTokens.buttonText(context),
    );
  }

  /// Text button style
  static ButtonStyle textButton(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: ColorTokens.primary(context),
      disabledForegroundColor: ColorTokens.buttonOnDisabled(context),
      padding: DesignTokens.getResponsivePadding(
        context,
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      minimumSize: Size(0, DesignTokens.getMinTouchTarget(context)),
      textStyle: TypographyTokens.buttonText(context),
    );
  }

  /// Icon button style
  static ButtonStyle iconButton(BuildContext context) {
    return IconButton.styleFrom(
      foregroundColor: ColorTokens.iconPrimary(context),
      disabledForegroundColor: ColorTokens.iconDisabled(context),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(DesignTokens.spaceS),
      minimumSize: Size(
        DesignTokens.getMinTouchTarget(context),
        DesignTokens.getMinTouchTarget(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
      ),
    );
  }

  // ── Card Styles ───────────────────────────────────────────────────────────
  
  /// Standard card style
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.surface(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusM,
          tablet: DesignTokens.radiusL,
          desktop: DesignTokens.radiusL,
        ),
      ),
      border: Border.all(
        color: ColorTokens.borderSubtle(context),
        width: 1,
      ),
      boxShadow: DesignTokens.getShadowLight(context),
    );
  }

  /// Elevated card style
  static BoxDecoration elevatedCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.surface(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusM,
          tablet: DesignTokens.radiusL,
          desktop: DesignTokens.radiusL,
        ),
      ),
      border: Border.all(
        color: ColorTokens.borderSubtle(context),
        width: 1,
      ),
      boxShadow: DesignTokens.getShadowMedium(context),
    );
  }

  /// Glass card style
  static BoxDecoration glassCardDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: ColorTokens.glassGradient(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusM,
          tablet: DesignTokens.radiusL,
          desktop: DesignTokens.radiusL,
        ),
      ),
      border: Border.all(
        color: ColorTokens.borderSubtle(context),
        width: 1,
      ),
      boxShadow: DesignTokens.getShadowLight(context),
    );
  }

  /// Success card style
  static BoxDecoration successCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.successContainer(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusM,
          tablet: DesignTokens.radiusL,
          desktop: DesignTokens.radiusL,
        ),
      ),
      border: Border.all(
        color: ColorTokens.success(context).withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: ColorTokens.success(context).withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ── Input Styles ──────────────────────────────────────────────────────────
  
  /// Input decoration theme
  static InputDecorationTheme inputDecorationTheme(BuildContext context) {
    return InputDecorationTheme(
      filled: true,
      fillColor: ColorTokens.surface(context),
      hintStyle: TypographyTokens.bodyMedium(context).copyWith(
        color: ColorTokens.textHint(context),
      ),
      labelStyle: TypographyTokens.bodyMedium(context).copyWith(
        color: ColorTokens.textSecondary(context),
      ),
      floatingLabelStyle: TypographyTokens.bodyMedium(context).copyWith(
        color: ColorTokens.primary(context),
        fontWeight: DesignTokens.fontWeightSemiBold,
      ),
      contentPadding: DesignTokens.getInputPadding(context),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusM,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
        borderSide: BorderSide(
          color: ColorTokens.borderMedium(context),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusM,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
        borderSide: BorderSide(
          color: ColorTokens.borderFocus(context),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusM,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
        borderSide: BorderSide(
          color: ColorTokens.error(context),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          DesignTokens.getResponsiveRadius(
            context,
            phone: DesignTokens.radiusM,
            tablet: DesignTokens.radiusM,
            desktop: DesignTokens.radiusM,
          ),
        ),
        borderSide: BorderSide(
          color: ColorTokens.error(context),
          width: 2,
        ),
      ),
      prefixIconColor: ColorTokens.iconSecondary(context),
      suffixIconColor: ColorTokens.iconSecondary(context),
    );
  }

  // ── Chip Styles ───────────────────────────────────────────────────────────
  
  /// Standard chip style
  static BoxDecoration chipDecoration(BuildContext context, {bool isSelected = false}) {
    return BoxDecoration(
      color: isSelected 
          ? ColorTokens.primaryContainer(context)
          : ColorTokens.surfaceElevated(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusS,
          tablet: DesignTokens.radiusM,
          desktop: DesignTokens.radiusM,
        ),
      ),
      border: Border.all(
        color: isSelected 
            ? ColorTokens.primary(context).withValues(alpha: 0.3)
            : ColorTokens.borderMedium(context),
        width: isSelected ? 2 : 1,
      ),
      boxShadow: isSelected ? [
        BoxShadow(
          color: ColorTokens.primary(context).withValues(alpha: 0.2),
          blurRadius: DesignTokens.getResponsiveSpacing(
            context,
            phone: 4,
            tablet: 6,
            desktop: 8,
          ),
          offset: const Offset(0, 2),
        ),
      ] : null,
    );
  }

  /// Success chip style
  static BoxDecoration successChipDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.successContainer(context),
      borderRadius: BorderRadius.circular(
        DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusS,
          tablet: DesignTokens.radiusM,
          desktop: DesignTokens.radiusM,
        ),
      ),
      border: Border.all(
        color: ColorTokens.success(context).withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  // ── Progress Indicator Styles ─────────────────────────────────────────────
  
  /// Linear progress indicator style
  static BoxDecoration linearProgressDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.surfaceElevated(context),
      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
    );
  }

  /// Circular progress indicator style
  static BoxDecoration circularProgressDecoration(BuildContext context) {
    return BoxDecoration(
      color: ColorTokens.surfaceElevated(context),
      shape: BoxShape.circle,
    );
  }

  // ── List Tile Styles ──────────────────────────────────────────────────────
  
  /// List tile theme
  static ListTileThemeData listTileTheme(BuildContext context) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      minLeadingWidth: DesignTokens.getResponsiveSpacing(
        context,
        phone: 20,
        tablet: 24,
        desktop: 28,
      ),
      contentPadding: DesignTokens.getResponsivePadding(
        context,
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      iconColor: ColorTokens.iconSecondary(context),
      textColor: ColorTokens.textPrimary(context),
    );
  }

  // ── App Bar Styles ────────────────────────────────────────────────────────
  
  /// App bar theme
  static AppBarTheme appBarTheme(BuildContext context) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ColorTokens.textPrimary(context),
      elevation: 0,
      scrolledUnderElevation: DesignTokens.elevation2,
      centerTitle: false,
      titleSpacing: DesignTokens.spaceS,
      iconTheme: IconThemeData(
        color: ColorTokens.iconPrimary(context),
        size: DesignTokens.getResponsiveIconSize(
          context,
          phone: DesignTokens.iconL,
          tablet: DesignTokens.iconL + 2,
          desktop: DesignTokens.iconL + 4,
        ),
      ),
      titleTextStyle: TypographyTokens.headlineMedium(context),
      actionsIconTheme: IconThemeData(
        color: ColorTokens.iconSecondary(context),
        size: DesignTokens.getResponsiveIconSize(
          context,
          phone: DesignTokens.iconL,
          tablet: DesignTokens.iconL + 2,
          desktop: DesignTokens.iconL + 4,
        ),
      ),
    );
  }

  // ── Navigation Bar Styles ────────────────────────────────────────────────
  
  /// Navigation bar theme
  static NavigationBarThemeData navigationBarTheme(BuildContext context) {
    return NavigationBarThemeData(
      backgroundColor: ColorTokens.surface(context),
      indicatorColor: ColorTokens.primaryContainer(context),
      elevation: DesignTokens.elevation1,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected 
              ? ColorTokens.primary(context)
              : ColorTokens.iconSecondary(context),
          size: DesignTokens.getResponsiveIconSize(
            context,
            phone: DesignTokens.iconM,
            tablet: DesignTokens.iconM + 2,
            desktop: DesignTokens.iconM + 4,
          ),
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return TypographyTokens.labelMedium(context).copyWith(
          color: isSelected 
              ? ColorTokens.primary(context)
              : ColorTokens.textSecondary(context),
          fontWeight: isSelected 
              ? DesignTokens.fontWeightSemiBold
              : DesignTokens.fontWeightNormal,
        );
      }),
    );
  }

  // ── Dialog Styles ─────────────────────────────────────────────────────────
  
  /// Dialog theme
  static DialogTheme dialogTheme(BuildContext context) {
    return DialogTheme(
      backgroundColor: ColorTokens.surface(context),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      titleTextStyle: TypographyTokens.headlineMedium(context),
      contentTextStyle: TypographyTokens.bodyMedium(context),
    );
  }

  /// Bottom sheet theme
  static BottomSheetThemeData bottomSheetTheme(BuildContext context) {
    return BottomSheetThemeData(
      backgroundColor: ColorTokens.surface(context),
      modalBackgroundColor: ColorTokens.surface(context),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      showDragHandle: true,
      dragHandleColor: ColorTokens.borderMedium(context),
    );
  }

  // ── Snackbar Styles ───────────────────────────────────────────────────────
  
  /// Snackbar theme
  static SnackBarThemeData snackBarTheme(BuildContext context) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorTokens.surface(context),
      contentTextStyle: TypographyTokens.bodyMedium(context).copyWith(
        color: ColorTokens.textPrimary(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      elevation: DesignTokens.elevation2,
    );
  }

  // ── Tooltip Styles ────────────────────────────────────────────────────────
  
  /// Tooltip theme
  static TooltipThemeData tooltipTheme(BuildContext context) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: ColorTokens.surface(context),
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(
          color: ColorTokens.borderSubtle(context),
          width: 1,
        ),
        boxShadow: DesignTokens.getShadowMedium(context),
      ),
      textStyle: TypographyTokens.labelSmall(context).copyWith(
        color: ColorTokens.textPrimary(context),
      ),
      waitDuration: DesignTokens.animationVerySlow,
      showDuration: const Duration(seconds: 4),
    );
  }

  // ── Divider Styles ────────────────────────────────────────────────────────
  
  /// Divider theme
  static DividerThemeData dividerTheme(BuildContext context) {
    return DividerThemeData(
      color: ColorTokens.borderMedium(context),
      thickness: 1,
      space: DesignTokens.spaceL,
    );
  }

  // ── Scrollbar Styles ──────────────────────────────────────────────────────
  
  /// Scrollbar theme
  static ScrollbarThemeData scrollbarTheme(BuildContext context) {
    return ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(DesignTokens.radiusM),
      thumbColor: WidgetStateProperty.all(
        ColorTokens.textSecondary(context).withValues(alpha: 0.3),
      ),
    );
  }
}
