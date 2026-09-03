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
        headlineLarge: TextStyle(color: AppColors.text, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.8),
        headlineMedium: TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 15, height: 1.45),
        bodyMedium: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4),
        labelLarge: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w700),
      ),
      dividerColor: AppColors.borderSoft,
      iconTheme: const IconThemeData(color: AppColors.textMuted),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundRaised.withOpacity(0.96),
        indicatorColor: const Color(0x338754FF),
        height: 78,
        labelTextStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? AppColors.purpleBright : AppColors.textMuted, size: 22);
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.backgroundRaised,
        indicatorColor: Color(0x338754FF),
        selectedIconTheme: IconThemeData(color: AppColors.purpleBright),
        selectedLabelTextStyle: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
        unselectedLabelTextStyle: TextStyle(color: AppColors.textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: const Color(0xFF1E1502),
          minimumSize: const Size(52, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.text,
          minimumSize: const Size(52, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textMuted,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundRaised,
        selectedColor: AppColors.purple.withOpacity(0.18),
        side: const BorderSide(color: AppColors.borderSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        labelStyle: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w700),
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
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.panel,
        dragHandleColor: AppColors.border,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
