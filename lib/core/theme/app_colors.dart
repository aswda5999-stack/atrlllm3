import 'package:flutter/material.dart';

/// ألوان تطبيق "أثر مسلم" — نظام سماوي فاتح/غامق
class AppColors {
  AppColors._();

  // ── ألوان السماء الأساسية ─────────────────────────
  static const Color skyLight    = Color(0xFFE0F2FE); // سماوي فاتح جداً
  static const Color skySoft     = Color(0xFFBAE6FD); // سماوي ناعم
  static const Color skyPrimary  = Color(0xFF38BDF8); // سماوي أساسي
  static const Color skyMedium   = Color(0xFF0EA5E9); // سماوي متوسط
  static const Color skyDark     = Color(0xFF0284C7); // سماوي غامق
  static const Color skyDeep     = Color(0xFF0C4A6E); // أزرق داكن جداً

  // ── ألوان الحالة (تفاعل الأزرار) ──────────────────
  static const Color pressedLight = Color(0xFF7DD3FC); // عند الضغط (فاتح)
  static const Color pressedDark  = Color(0xFF0369A1); // عند الضغط (غامق)

  // ── ألوان محايدة ──────────────────────────────────
  static const Color background   = Color(0xFFF0F9FF); // خلفية الصفحة
  static const Color surface      = Color(0xFFFFFFFF); // سطح البطاقات
  static const Color surfaceSoft  = Color(0xFFF8FAFC); // سطح ناعم
  static const Color textPrimary  = Color(0xFF0F172A); // نص أساسي
  static const Color textSecondary= Color(0xFF64748B); // نص ثانوي
  static const Color textOnDark   = Color(0xFFF1F5F9); // نص على خلفية داكنة
  static const Color divider      = Color(0xFFE2E8F0); // فواصل
  static const Color border       = Color(0xFFCBD5E1); // حدود

  // ── ألوان دلالية ──────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ── ظلال ──────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: skyPrimary.withOpacity(0.10),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: skyDark.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ── تدرجات جاهزة ──────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [skyDark, skyPrimary],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyLight, background],
  );
}
