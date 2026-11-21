import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

/// الكلاس الرئيسي لتطبيق "أثر مسلم"
class AtharMuslimApp extends StatelessWidget {
  const AtharMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أثر مسلم',
      debugShowCheckedModeBanner: false,
      
      // ── السمة ─────────────────────────────────────────
      theme: AppTheme.lightTheme,
      
      // ── اللغة والاتجاه (عربي RTL) ─────────────────────
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // ── فرض الاتجاه من اليمين لليسار ──────────────────
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      
      // ── الصفحة الرئيسية ───────────────────────────────
      home: const HomeScreen(),
    );
  }
}
