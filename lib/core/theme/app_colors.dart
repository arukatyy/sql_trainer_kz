import 'package:flutter/material.dart';

class AppColors {
  // Gamified 2.0 Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC); // Clean crisp canvas
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Gamified 2.0 Dark Mode
  static const Color darkBackground = Color(0xFF0B101D); // Deep modern slate navy
  static const Color darkCardBackground = Color(0xFF182234);
  static const Color darkCardBorder = Color(0xFF28354A);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Gamified Palette (Duolingo 2.0 Vibrant & Tactile)
  static const Color primary = Color(0xFF5856D6); // Royal Violet / Indigo
  static const Color primaryShadow = Color(0xFF4341B8);
  static const Color primaryLight = Color(0xFF7A78E8);

  static const Color secondary = Color(0xFF0EA5E9); // Electric Sky Blue
  static const Color secondaryShadow = Color(0xFF0284C7);

  static const Color success = Color(0xFF22C55E); // Duolingo Green
  static const Color successShadow = Color(0xFF16A34A);

  static const Color warning = Color(0xFFFF7A00); // Streak Orange
  static const Color warningShadow = Color(0xFFE65100);

  static const Color error = Color(0xFFEF4444); // Crisp Red
  static const Color errorShadow = Color(0xFFDC2626);

  static const Color xp = Color(0xFFFFB800); // Gold / Lightning Yellow
  static const Color xpShadow = Color(0xFFD97706);

  static const Color purple = Color(0xFFA855F7);
  static const Color purpleShadow = Color(0xFF9333EA);

  static const Color pink = Color(0xFFEC4899);
  static const Color pinkShadow = Color(0xFFDB2777);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightCardBackground,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.lightText),
        titleTextStyle: TextStyle(color: AppColors.lightText, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.3),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xEEFFFFFF),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF94A3B8),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightText, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14, height: 1.5),
        titleLarge: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkCardBackground,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.3),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xEE182234),
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: Color(0xFF64748B),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14, height: 1.5),
        titleLarge: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      ),
    );
  }
}
