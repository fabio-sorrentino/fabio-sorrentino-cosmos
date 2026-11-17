import 'package:flutter/material.dart';

class AppColors {
  // Colori
  static const primary = Color(0xFF08085B);
  static const secondary = Color(0xFF087CB8);
  static const tertiary = Color(0xFF00B5D4);
  static const lightBg = Color(0xFF8DDEEA);
  static const surfaceLight = Color(0xFFC7F0F7);
  static const white = Colors.white;
  static const black = Colors.black;
  static const red = Colors.red;

  // Hover
  static const hoverPrimary = Color(0xFF0B0B7A);
  static const hoverSecondary = Color(0xFF0A8FD1);
  static const hoverTertiary = Color(0xFF00CFEF);
  static const hoverLightBg = Color(0xFFA6EAF1);
  static const hoverSurfaceLight = Color(0xFFD7F6FA);

  // Active
  static const activePrimary = Color(0xFF06064A);
  static const activeSecondary = Color(0xFF07669D);
  static const activeTertiary = Color(0xFF00A2BD);
  static const activeLightBg = Color(0xFF7FD4DB);
  static const activeSurfaceLight = Color(0xFFBDE8ED);

  // Disabled
  static const disabledPrimary = Color(0xFF3A3A7A);
  static const disabledSecondary = Color(0xFF4A9CC4);
  static const disabledTertiary = Color(0xFF7EDDE8);
  static const disabledLightBg = Color(0xFFD1F4F7);
  static const disabledSurfaceLight = Color(0xFFEEF9FB);

  // Semantic
  static const info = Color(0xFF087CB8);
  static const success = Color(0xFF00B5D4);
  static const warning = Color(0xFF8DDEEA);
  static const error = Color(0xFF3B2F8F);
}

class AppTheme {
  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    background: AppColors.primary,
    surface: AppColors.hoverPrimary,
    primary: AppColors.lightBg,
    onPrimary: AppColors.primary,
    text: AppColors.white,
    textMuted: AppColors.disabledLightBg,
  );

  static final ThemeData light = _build(
    brightness: Brightness.light,
    background: AppColors.surfaceLight,
    surface: AppColors.surfaceLight,
    primary: AppColors.secondary,
    onPrimary: AppColors.white,
    text: AppColors.primary,
    textMuted: AppColors.activeSecondary,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color onPrimary,
    required Color text,
    required Color textMuted,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      // Font principale
      fontFamily: 'Inter',

      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: primary,
        onSecondary: onPrimary,
        surface: surface,
        onSurface: text,
        error: AppColors.red,
        onError: AppColors.white,
      ),

      // Stili dei testi
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: text,
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: TextStyle(
          color: text,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
        titleMedium: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: text,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        // Colore del testo suggerimento (Email, Password)
        hintStyle: TextStyle(color: textMuted, fontSize: 14),

        // Colore dell'icona iniziale
        prefixIconColor: textMuted,

        // Colore dell'icona finale (es. mostra/nascondi password)
        suffixIconColor: textMuted,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
