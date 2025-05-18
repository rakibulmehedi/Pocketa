// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/provider/language_provider.dart';
import 'app_colors.dart';
import '../utils/responsive_utils.dart';

TextStyle getFontStyle(
  AppLanguage lang,
  double size,
  FontWeight weight,
  Color color,
) {
  return lang == AppLanguage.bangla
      ? GoogleFonts.notoSansBengali(
        fontSize: size,
        fontWeight: weight,
        color: color,
      )
      : GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);
}

class AppTheme {
  static ThemeData lightTheme(BuildContext context, AppLanguage lang) =>
      ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textDark,
          elevation: 0,
        ),
        textTheme: TextTheme(
          displayLarge: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 32),
            FontWeight.bold,
            AppColors.primary,
          ),
          titleMedium: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 18),
            FontWeight.w500,
            AppColors.textDark,
          ),
          bodyMedium: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 14),
            FontWeight.normal,
            AppColors.grey,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: getFontStyle(
              lang,
              ResponsiveUtilities.font(context, 16),
              FontWeight.w600,
              Colors.white,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 14),
            FontWeight.normal,
            AppColors.grey,
          ),
        ),
      );

  static ThemeData darkTheme(BuildContext context, AppLanguage lang) =>
      ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
        textTheme: TextTheme(
          displayLarge: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 32),
            FontWeight.bold,
            AppColors.primary,
          ),
          titleMedium: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 18),
            FontWeight.w500,
            AppColors.textLight,
          ),
          bodyMedium: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 14),
            FontWeight.normal,
            AppColors.grey,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: getFontStyle(
              lang,
              ResponsiveUtilities.font(context, 16),
              FontWeight.w600,
              Colors.white,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.textDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: getFontStyle(
            lang,
            ResponsiveUtilities.font(context, 14),
            FontWeight.normal,
            AppColors.grey,
          ),
        ),
      );
}
