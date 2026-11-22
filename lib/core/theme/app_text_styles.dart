import 'package:flutter/material.dart';
import 'app_colors.dart';

/// أنماط النصوص الموحدة لتطبيق "أثر مسلم"
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle display = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle tiny = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle titleOnDark = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.35,
  );

  static const TextStyle bodyOnDark = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.6,
  );

  static const TextStyle captionOnDark = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE0F2FE),
    height: 1.4,
  );

  static const TextStyle quranAyah = TextStyle(
    fontFamily: 'Uthmanic',
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 2.0,
  );

  static const TextStyle quranAyahSmall = TextStyle(
    fontFamily: 'Uthmanic',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.9,
  );

  static const TextStyle quranSurahName = TextStyle(
    fontFamily: 'Uthmanic',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.skyDark,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.skyDark,
    height: 1.3,
  );

  static TextStyle withColor(TextStyle base, Color color) =>
      base.copyWith(color: color);

  static TextStyle withWeight(TextStyle base, FontWeight weight) =>
      base.copyWith(fontWeight: weight);

  static TextStyle withSize(TextStyle base, double size) =>
      base.copyWith(fontSize: size);
}
