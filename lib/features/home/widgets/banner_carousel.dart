import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// بانر متغير تلقائياً كل 5 ثوانٍ
/// يعرض صوراً أو محتوى ترويجياً (يمكن استبدالها بصورك)
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.95);
  Timer? _timer;
  int _currentPage = 0;

  // ── بيانات البانرات (استبدل النصوص/الصور بصورك) ────
  static const List<_BannerData> _banners = [
    _BannerData(
      title: '﴿ وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا ﴾',
      subtitle: 'استمع لتلاوات أشهر القراء',
      icon: Icons.menu_book_rounded,
      gradient: [Color(0xFF0284C7), Color(0xFF38BDF8)],
    ),
    _BannerData(
      title: 'أذكار الصباح والمساء',
      subtitle: 'حصّن يومك بذكر الله',
      icon: Icons.nights_stay_rounded,
      gradient: [Color(0xFF0C4A6E), Color(0xFF0EA5E9)],
    ),
    _BannerData(
      title: 'مواقيت الصلاة',
      subtitle: 'لا تفوّت صلاتك، تابع الأوقات بدقة',
      icon: Icons.mosque_rounded,
      gradient: [Color(0xFF0369A1), Color(0xFF7DD3FC)],
    ),
    _BannerData(
      title: 'أدعية مأثورة',
      subtitle: 'دعاء الشفاء، قبل النوم، وغيرها',
      icon: Icons.pan_tool_rounded,
      gradient: [Color(0xFF0C4A6E), Color(0xFF0284C7)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextPage = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ── البانرات ────────────────────────────────
          PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _BannerCard(data: _banners[index]);
            },
          ),

          // ── نقاط المؤشر (Indicators) ─────────────────
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_banners.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  بطاقة البانر الواحدة
// ══════════════════════════════════════════════════════

class _BannerData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;

  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: data.gradient,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: data.gradient.first.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── نقش زخرفي شفاف ─────────────────────
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                data.icon,
                size: 160,
                color: Colors.white.withOpacity(0.08),
              ),
            ),

            // ── المحتوى ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(data.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data.title,
                    style: AppTextStyles.titleOnDark.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.subtitle,
                    style: AppTextStyles.captionOnDark.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
