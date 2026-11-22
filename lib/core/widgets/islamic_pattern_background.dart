import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// خلفية إسلامية خفيفة مع نقش هندسي وتدرج سماوي
/// تغلف أي ويدجت وتُستخدم كخلفية للصفحات الرئيسية
class IslamicPatternBackground extends StatelessWidget {
  final Widget child;

  const IslamicPatternBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.softGradient,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _IslamicPatternPainter(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.skyPrimary.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const double spacing = 70.0;
    const double radius = 22.0;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawIslamicStar(canvas, paint, Offset(x, y), radius);
      }
    }
  }

  void _drawIslamicStar(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
  ) {
    final path = Path();
    const int points = 8;
    final double angleStep = (3.141592653589793 * 2) / points;

    for (int i = 0; i < points; i++) {
      final double outerAngle = i * angleStep;
      final double innerAngle = outerAngle + angleStep / 2;

      final double outerX = center.dx + radius * _cos(outerAngle);
      final double outerY = center.dy + radius * _sin(outerAngle);
      final double innerX = center.dx + (radius * 0.4) * _cos(innerAngle);
      final double innerY = center.dy + (radius * 0.4) * _sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double x) => _sin(x + 1.5707963267948966);
  double _sin(double x) {
    x = x % 6.283185307179586;
    if (x < 0) x += 6.283185307179586;
    double result = 0;
    double term = x;
    for (int i = 1; i < 10; i += 2) {
      result += term;
      term *= -x * x / ((i + 1) * (i + 2));
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
