import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  // التأكد من تهيئة Flutter قبل استخدام أي حزم (إذا احتجت مستقبلاً)
  WidgetsFlutterBinding.ensureInitialized();

  // فرض الوضع الفاتح لتطبيق "أثر مسلم" (يمكن تغييره لاحقاً)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // منع تدوير الشاشة الأفقي (اختياري: مفيد لتطبيقات المصحف)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AtharMuslimApp());
}
