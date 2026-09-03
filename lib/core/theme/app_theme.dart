import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.purple,
      secondary: AppColors.blue,
      surface: AppColors.panel,
      error: AppColors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.text,
      onError: Colors.white,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
      fontFamilyFallback: const ['Noto Sans', 'Noto Sans JP', 'sans-serif'],
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.text,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: AppColors.text,
          fontSize: 15,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerColor: AppColors.borderSoft,
      iconTheme: const IconThemeData(color: AppColors.textMuted),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.backgroundRaised,
        indicatorColor: Color(0x338754FF),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.backgroundRaised,
        indicatorColor: Color(0x338754FF),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: const Color(0xFF1A1200),
          minimumSize: const Size(52, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.text,
          minimumSize: const Size(52, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.purpleBright;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.purple.withOpacity(0.35);
          }
          return AppColors.borderSoft;
        }),
      ),
    );
  }
}
