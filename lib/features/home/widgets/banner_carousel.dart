import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.95);
  Timer? _timer;
  int _currentPage = 0;

  // ── 10 مناسبات وبطاقات إسلامية ─────────────────────
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
      title: 'استعد لشهر رمضان',
      subtitle: 'اللهم بلغنا رمضان لا فاقدين ولا مفقودين',
      icon: Icons.mosque_rounded,
      gradient: [Color(0xFF0369A1), Color(0xFF7DD3FC)],
    ),
    _BannerData(
      title: '﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾',
      subtitle: 'طمئن قلبك بذكر الله',
      icon: Icons.favorite_rounded,
      gradient: [Color(0xFF0C4A6E), Color(0xFF0284C7)],
    ),
    _BannerData(
      title: 'دعاء الشفاء',
      subtitle: 'اللهم رب الناس أذهب البأس اشفِ أنت الشافي',
      icon: Icons.healing_rounded,
      gradient: [Color(0xFF10B981), Color(0xFF38BDF8)],
    ),
    _BannerData(
      title: 'قيام الليل',
      subtitle: 'شرف المؤمن قيامه بالليل',
      icon: Icons.nightlight_round,
      gradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    ),
    _BannerData(
      title: 'استغفر الله العظيم',
      subtitle: 'من لزم الاستغفار جعل الله له من كل هم فرجاً',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    ),
    _BannerData(
      title: 'فضل يوم الجمعة',
      subtitle: 'أكثروا من الصلاة عليّ يوم الجمعة',
      icon: Icons.mosque,
      gradient: [Color(0xFF0C4A6E), Color(0xFF0EA5E9)],
    ),
    _BannerData(
      title: '﴿ إِنَّ مَعَ الْعُسْرِ يُسْرًا ﴾',
      subtitle: 'تفاءل وكن واثقاً بالله',
      icon: Icons.wb_sunny_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFF38BDF8)],
    ),
    _BannerData(
      title: 'الأربعين النووية',
      subtitle: 'تصفح الأحاديث النبوية الشريفة',
      icon: Icons.article_rounded,
      gradient: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
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
          PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _BannerCard(data: _banners[index]);
            },
          ),
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_banners.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
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
            Positioned(
              left: -20,
              top: -20,
              child: Icon(data.icon, size: 160, color: Colors.white.withOpacity(0.08)),
            ),
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
                    style: AppTextStyles.titleOnDark.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.subtitle,
                    style: AppTextStyles.captionOnDark.copyWith(fontSize: 13),
                    maxLines: 2,
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
