import 'package:flutter/material.dart';

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
    // Primary scheme from blue seed
    final base = ColorScheme.fromSeed(
      seedColor: _blueSeed,
      brightness: brightness,
    );
    // Secondary palette from green seed (merge only the secondary family)
    final accent = ColorScheme.fromSeed(
      seedColor: _greenSeed,
      brightness: brightness,
    );

    // Force clean fintech surfaces: white in light, near‑black in dark
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0B0B0F) : Colors.white;
    final surface = isDark ? const Color(0xFF111317) : Colors.white;
    final sVar = isDark ? const Color(0xFF1C1F24) : const Color(0xFFEAECEF);

    final scheme = base.copyWith(
      secondary: accent.secondary,
      onSecondary: accent.onSecondary,
      secondaryContainer: accent.secondaryContainer,
      onSecondaryContainer: accent.onSecondaryContainer,
      // Surfaces tuned for fintech readability
      background: bg,
      surface: surface,
      surfaceVariant: sVar,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // Make sure app looks white/clean in light, deep in dark
      scaffoldBackgroundColor: scheme.background,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
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

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(scheme.primary),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.primary),
          foregroundColor: MaterialStatePropertyAll(scheme.onPrimary),
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.primaryContainer),
          foregroundColor: MaterialStatePropertyAll(scheme.onPrimaryContainer),
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: MaterialStatePropertyAll(BorderSide(color: scheme.outline)),
          foregroundColor: MaterialStatePropertyAll(scheme.primary),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),

      inputDecorationTheme: _inputTheme(scheme),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final selected = states.contains(MaterialState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final baseStyle = const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
          final selected = states.contains(MaterialState.selected);
          return baseStyle.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme s) {
    OutlineInputBorder o(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: s.surface, // on white
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
