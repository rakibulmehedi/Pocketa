import 'package:flutter/material.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/core/theme/app_colors.dart';

/// Unified text styling system for consistent typography across the app
class AppTextStyles {
  AppTextStyles._();

  /// Responsive display text style (largest)
  static TextStyle responsiveDisplay(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
      tablet: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 32,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
      desktop: theme.textTheme.headlineLarge!.copyWith(
        fontSize: 36,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
    );
  }

  /// Responsive title text style
  static TextStyle responsiveTitle(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.titleMedium!.copyWith(
        fontSize: 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.3,
      ),
      tablet: theme.textTheme.titleMedium!.copyWith(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.3,
      ),
      desktop: theme.textTheme.titleMedium!.copyWith(
        fontSize: 24,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.3,
      ),
    );
  }

  /// Responsive body text style
  static TextStyle responsiveBody(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.4,
      ),
      tablet: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 15,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.4,
      ),
      desktop: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.25,
        height: height ?? 1.4,
      ),
    );
  }

  /// Responsive caption text style
  static TextStyle responsiveCaption(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.4,
        height: height ?? 1.3,
      ),
      tablet: theme.textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.4,
        height: height ?? 1.3,
      ),
      desktop: theme.textTheme.bodySmall!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.4,
        height: height ?? 1.3,
      ),
    );
  }

  /// Responsive button text style
  static TextStyle responsiveButton(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.labelLarge!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.buttonTextPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
      tablet: theme.textTheme.labelLarge!.copyWith(
        fontSize: 15,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.buttonTextPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
      desktop: theme.textTheme.labelLarge!.copyWith(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.buttonTextPrimary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.2,
      ),
    );
  }

  /// Responsive label text style
  static TextStyle responsiveLabel(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.labelMedium!.copyWith(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.3,
      ),
      tablet: theme.textTheme.labelMedium!.copyWith(
        fontSize: 13,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.3,
      ),
      desktop: theme.textTheme.labelMedium!.copyWith(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.5,
        height: height ?? 1.3,
      ),
    );
  }

  /// Responsive note text style
  static TextStyle responsiveNote(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodySmall!.copyWith(
        fontSize: 11,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
      tablet: theme.textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
      desktop: theme.textTheme.bodySmall!.copyWith(
        fontSize: 13,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
    );
  }

  /// Responsive date text style
  static TextStyle responsiveDate(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.bodySmall!.copyWith(
        fontSize: 10,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.2,
        height: height ?? 1.1,
      ),
      tablet: theme.textTheme.bodySmall!.copyWith(
        fontSize: 11,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.2,
        height: height ?? 1.1,
      ),
      desktop: theme.textTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.textSecondary(context),
        letterSpacing: letterSpacing ?? 0.2,
        height: height ?? 1.1,
      ),
    );
  }

  /// Responsive amount text style
  static TextStyle responsiveAmount(BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return layout.responsiveTextStyle(
      phone: theme.textTheme.titleMedium!.copyWith(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
      tablet: theme.textTheme.titleMedium!.copyWith(
        fontSize: 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
      desktop: theme.textTheme.titleMedium!.copyWith(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.textPrimary(context),
        letterSpacing: letterSpacing ?? 0.3,
        height: height ?? 1.2,
      ),
    );
  }
}