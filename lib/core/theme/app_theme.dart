import 'package:flutter/material.dart';
import 'package:pocketa/core/theme/app_typography.dart';

class AppTheme {
  // Brand seeds
  static const _blueSeed = Color(0xFF1E88E5); // primary
  static const _greenSeed = Color(0xFF43A047); // secondary/accent

  // Public themes
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  // --------------------------
  // Core builder
  // --------------------------
  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Color schemes
    final base = ColorScheme.fromSeed(
      seedColor: _blueSeed,
      brightness: brightness,
    );
    final accent = ColorScheme.fromSeed(
      seedColor: _greenSeed,
      brightness: brightness,
    );

    final surface = isDark ? const Color(0xFF111317) : Colors.white;
    final surfaceContainerHighest = isDark
        ? const Color(0xFF1C1F24)
        : const Color(0xFFEAECEF);

    final scheme = base.copyWith(
      secondary: accent.secondary,
      onSecondary: accent.onSecondary,
      secondaryContainer: accent.secondaryContainer,
      onSecondaryContainer: accent.onSecondaryContainer,
      surface: surface,
      surfaceContainerHighest: surfaceContainerHighest,
    );

    final textTheme = AppTypography.build(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),

      // Buttons (DRY helpers used below)
      textButtonTheme: TextButtonThemeData(style: _textBtnStyle(scheme)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _elevatedBtnStyle(scheme),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _filledBtnStyle(scheme)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedBtnStyle(scheme),
      ),

      inputDecorationTheme: _inputTheme(scheme),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          final baseStyle = textTheme.labelMedium!;
          return baseStyle.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          );
        }),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),

      // Optional: chips look
      chipTheme: ChipThemeData(
        elevation: 0,
        side: BorderSide(color: scheme.outlineVariant),
        selectedColor: scheme.primaryContainer,
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: textTheme.labelMedium!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // --------------------------
  // Button styles (DRY)
  // --------------------------
  static ButtonStyle _baseRoundedBtn(ColorScheme s) => ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevation: const WidgetStatePropertyAll(0),
  );

  static ButtonStyle _textBtnStyle(ColorScheme s) =>
      _baseRoundedBtn(s).copyWith(
        foregroundColor: WidgetStatePropertyAll(s.primary),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
      );

  static ButtonStyle _elevatedBtnStyle(ColorScheme s) =>
      _baseRoundedBtn(s).copyWith(
        backgroundColor: WidgetStatePropertyAll(s.primary),
        foregroundColor: WidgetStatePropertyAll(s.onPrimary),
        minimumSize: const WidgetStatePropertyAll(Size(200, 48)),
      );

  static ButtonStyle _filledBtnStyle(ColorScheme s) =>
      _baseRoundedBtn(s).copyWith(
        backgroundColor: WidgetStatePropertyAll(s.primaryContainer),
        foregroundColor: WidgetStatePropertyAll(s.onPrimaryContainer),
        minimumSize: const WidgetStatePropertyAll(Size(200, 48)),
      );

  static ButtonStyle _outlinedBtnStyle(ColorScheme s) =>
      _baseRoundedBtn(s).copyWith(
        side: WidgetStatePropertyAll(BorderSide(color: s.outline)),
        foregroundColor: WidgetStatePropertyAll(s.primary),
        minimumSize: const WidgetStatePropertyAll(Size(200, 48)),
      );

  // --------------------------
  // Inputs
  // --------------------------
  static InputDecorationTheme _inputTheme(ColorScheme s) {
    OutlineInputBorder o(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: s.surface,
      hintStyle: TextStyle(color: s.onSurfaceVariant),
      labelStyle: TextStyle(color: s.onSurfaceVariant),
      floatingLabelStyle: TextStyle(
        color: s.primary,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: o(s.outlineVariant),
      focusedBorder: o(s.primary, 1.6),
      errorBorder: o(s.error),
      focusedErrorBorder: o(s.error, 1.6),
    );
  }
}
