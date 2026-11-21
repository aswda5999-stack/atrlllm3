import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// السمة الشاملة لتطبيق "أثر مسلم"
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.skyDark,
      scaffoldBackgroundColor: AppColors.background,

      // ── نظام الألوان ──────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.skyPrimary,
        brightness: Brightness.light,
        primary: AppColors.skyDark,
        secondary: AppColors.skyPrimary,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),

      // ── شريط التطبيق ─────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.skyDark),
        titleTextStyle: AppTextStyles.headline,
      ),

      // ── البطاقات ──────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
      ),

      // ── الأزرار النصية ───────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.skyDark,
          textStyle: AppTextStyles.buttonSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ── الأزرار المرتفعة ─────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.skyDark,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ── الحقول النصية ────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.skyPrimary, width: 1.5),
        ),
      ),

      // ── شريط التنقل السفلي ───────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.skyDark,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.skyDark,
        ),
        unselectedLabelStyle: AppTextStyles.caption,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        showUnselectedLabels: true,
      ),

      // ── فواصل ────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── أيقونات ──────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.skyDark,
        size: 24,
      ),

      // ── شريط التمرير ─────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          AppColors.skyPrimary.withOpacity(0.5),
        ),
        radius: const Radius.circular(8),
        thickness: MaterialStateProperty.all(6),
      ),
    );
  }
}
