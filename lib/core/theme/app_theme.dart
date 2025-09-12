import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/theme/app_typography.dart';
import 'package:pocketa/core/theme/app_elevation.dart';
import 'package:pocketa/core/theme/app_radius.dart';
import 'package:pocketa/core/theme/app_spacing.dart';
import 'package:pocketa/core/theme/app_color_scheme.dart';

class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = isDark ? AppColorScheme.dark : AppColorScheme.light;

    final textTheme = AppTypography.build(brightness);

    RoundedRectangleBorder rounded(double r) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));

    OutlineInputBorder iBorder(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: c, width: w));

    WidgetStateProperty<T> state<T>(T normal,
        {T? selected, T? pressed, T? disabled, T? hovered, T? focused}) {
      return WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.disabled) && disabled != null) {
          return disabled;
        }
        if (s.contains(WidgetState.pressed) && pressed != null) {
          return pressed;
        }
        if (s.contains(WidgetState.selected) && selected != null) {
          return selected;
        }
        if (s.contains(WidgetState.hovered) && hovered != null) {
          return hovered;
        }
        if (s.contains(WidgetState.focused) && focused != null) {
          return focused;
        }
        return normal;
      });
    }

    ButtonStyle baseBtn() => ButtonStyle(
          shape: state<OutlinedBorder>(rounded(AppRadius.md)),
          padding: state(const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          minimumSize: state(const Size(200, 48)),
          elevation: state(AppElevation.level1),
          animationDuration: const Duration(milliseconds: 120),
          splashFactory: InkSparkle.splashFactory,
        );

    final textButtonStyle = baseBtn().copyWith(
      foregroundColor: state(scheme.primary,
          disabled: scheme.onSurface.withValues(alpha: 0.38)),
      overlayColor: state(scheme.primary.withValues(alpha: 0.08),
          pressed: scheme.primary.withValues(alpha: 0.12)),
      padding: state(const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
      minimumSize: state(const Size(0, 40)),
    );

    final filledButtonStyle = baseBtn().copyWith(
      backgroundColor: state(scheme.primaryContainer,
          pressed: scheme.primaryContainer.withValues(alpha: 0.92),
          disabled: scheme.surfaceContainerHighest),
      foregroundColor: state(scheme.onPrimaryContainer,
          disabled: scheme.onSurface.withValues(alpha: 0.38)),
      overlayColor: state(scheme.primary.withValues(alpha: 0.06),
          pressed: scheme.primary.withValues(alpha: 0.10)),
    );

    final elevatedButtonStyle = baseBtn().copyWith(
      backgroundColor: state(scheme.primary,
          pressed: scheme.primary.withValues(alpha: 0.94),
          disabled: scheme.surfaceContainerHighest),
      foregroundColor: state(scheme.onPrimary,
          disabled: scheme.onSurface.withValues(alpha: 0.38)),
      overlayColor: state(scheme.onPrimary.withValues(alpha: 0.06),
          pressed: scheme.onPrimary.withValues(alpha: 0.10)),
      elevation: state(0.0),
      shadowColor: state(Colors.transparent),
    );

    final outlinedButtonStyle = baseBtn().copyWith(
      side: state(BorderSide(color: scheme.outline)),
      foregroundColor: state(scheme.primary,
          disabled: scheme.onSurface.withValues(alpha: 0.38)),
      overlayColor: state(scheme.primary.withValues(alpha: 0.06),
          pressed: scheme.primary.withValues(alpha: 0.10)),
    );

    return ThemeData(
      useMaterial3: true,
      // Core: local fonts + fallback chain (Inter → HindSiliguri → NotoSans)
      fontFamily: 'Inter',
      fontFamilyFallback: const ['HindSiliguri', 'NotoSans'],

      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.background,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 8,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle:
            textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        actionsIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: AppElevation.level1,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: rounded(AppRadius.lg),
        surfaceTintColor: Colors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
        thickness: 1,
        space: AppSpacing.lg,
      ),

      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
      filledButtonTheme: FilledButtonThemeData(style: filledButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: state(const Size(40, 40)),
          padding: state(const EdgeInsets.all(AppSpacing.sm)),
          overlayColor: state(scheme.primary.withValues(alpha: 0.08),
              pressed: scheme.primary.withValues(alpha: 0.12)),
          shape: state(rounded(AppRadius.sm)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle:
            TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
        enabledBorder: iBorder(scheme.outlineVariant),
        focusedBorder: iBorder(scheme.primary, 1.8),
        errorBorder: iBorder(scheme.error),
        focusedErrorBorder: iBorder(scheme.error, 1.8),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          return IconThemeData(
              color: sel ? scheme.primary : scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          final base = textTheme.labelMedium!;
          return base.copyWith(
            color: sel ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          );
        }),
      ),

      chipTheme: ChipThemeData(
        elevation: AppElevation.level0,
        side: BorderSide(color: scheme.outlineVariant),
        selectedColor: scheme.primaryContainer,
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: textTheme.labelMedium!,
        shape: rounded(AppRadius.sm),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: state(scheme.surface),
          surfaceTintColor: state(Colors.transparent),
          shape: state(rounded(AppRadius.sm)),
          elevation: state(AppElevation.level2),
          shadowColor:
              state(Colors.black.withValues(alpha: isDark ? 0.24 : 0.12)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        shape: rounded(AppRadius.sm),
        elevation: AppElevation.level2,
        textStyle: textTheme.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
        shape: rounded(AppRadius.lg),
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outlineVariant,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: rounded(AppRadius.lg),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: ShapeDecoration(
          color: isDark ? const Color(0xFF23262B) : const Color(0xFF101317),
          shape: rounded(AppRadius.sm),
        ),
        textStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 4),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        shape: rounded(AppRadius.sm),
        elevation: AppElevation.level2,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: state(true),
        thickness: state(6),
        radius: const Radius.circular(AppRadius.sm),
        thumbColor: state(scheme.onSurface.withValues(alpha: 0.18),
            hovered: scheme.onSurface.withValues(alpha: 0.28)),
      ),

      listTileTheme: ListTileThemeData(
        shape: rounded(AppRadius.sm),
        minLeadingWidth: 24,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
