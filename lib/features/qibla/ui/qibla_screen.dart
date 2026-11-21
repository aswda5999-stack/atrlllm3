import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة البوصلة — اتجاه القبلة
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  String _status = 'جارٍ تحديد الموقع...';

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  /// حساب زاوية القبلة بناءً على موقع المستخدم
  Future<void> _initQibla() async {
    try {
      // التحقق من صلاحيات الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _status = 'يرجى تفعيل صلاحية الموقع لحساب القبلة');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      
      // إحداثيات الكعبة المشرفة
      const kaabaLat = 21.4225;
      const kaabaLng = 39.8262;

      // حساب زاوية القبلة باستخدام المعادلة الرياضية
      final lat1 = _toRadians(position.latitude);
      final lon1 = _toRadians(position.longitude);
      final lat2 = _toRadians(kaabaLat);
      final lon2 = _toRadians(kaabaLng);

      final dLon = lon2 - lon1;
      final y = math.sin(dLon) * math.cos(lat2);
      final x = math.cos(lat1) * math.sin(lat2) -
          math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
      
      final bearing = math.atan2(y, x);
      final bearingDegrees = (bearing * 180 / math.pi + 360) % 360;

      setState(() {
        _qiblaDirection = bearingDegrees;
        _status = 'اتجاه القبلة محدد بدقة';
      });
    } catch (e) {
      setState(() => _status = 'تعذر تحديد الموقع: $e');
    }
  }

  double _toRadians(double degree) => degree * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        backgroundColor: Colors.transparent,
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Center(
            child: _qiblaDirection == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(_status, style: AppTextStyles.body),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── البوصلة ────────────────────────
                      StreamBuilder<CompassEvent>(
                        stream: FlutterCompass.events,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('خطأ في البوصلة: ${snapshot.error}');
                          }
                          if (snapshot.data == null) {
                            return const CircularProgressIndicator();
                          }

                          // زاوية الهاتف الحالية
                          final heading = snapshot.data!.heading ?? 0;
                          
                          // زاوية القبلة بالنسبة للهاتف
                          final rotation =
                              (_qiblaDirection! - heading) * math.pi / 180;

                          return SizedBox(
                            width: 280,
                            height: 280,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // دائرة البوصلة
                                Container(
                                  width: 280,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface,
                                    border: Border.all(
                                      color: AppColors.divider,
                                      width: 2,
                                    ),
                                    boxShadow: AppColors.mediumShadow,
                                  ),
                                ),
                                
                                // الاتجاهات (شمال، جنوب، شرق، غرب)
                                ..._buildDirections(),
                                
                                // سهم القبلة (يدور مع الهاتف)
                                Transform.rotate(
                                  angle: rotation,
                                  child: const Icon(
                                    Icons.navigation_rounded,
                                    size: 80,
                                    color: AppColors.skyDark,
                                  ),
                                ),
                                
                                // الكعبة في المنتصف
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mosque_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Text(_status, style: AppTextStyles.body),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// بناء الاتجاهات الأربعة حول البوصلة
  List<Widget> _buildDirections() {
    return [
      const Positioned(
        top: 16,
        child: Text('ش',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      ),
      const Positioned(
        bottom: 16,
        child: Text('ج',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
      const Positioned(
        right: 16,
        child: Text('ق',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
      const Positioned(
        left: 16,
        child: Text('غ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    ];
  }
}
