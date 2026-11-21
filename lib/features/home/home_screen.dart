import 'package:flutter/material.dart';
import '../../core/widgets/islamic_pattern_background.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/grid_menu.dart';
import 'widgets/top_search_bar.dart';

/// الشاشة الرئيسية لتطبيق "أثر مسلم"
/// تحتوي على شريط تنقل سفلي + 5 صفحات (PageView)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// التنقل عند الضغط على شريط التنقل
  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// التنقل عند السحب (PageView)
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          _HomeTab(),
          _PlaceholderTab(title: 'الصوتيات', icon: Icons.headphones_rounded),
          _PlaceholderTab(title: 'القرآن الكريم', icon: Icons.menu_book_rounded),
          _PlaceholderTab(title: 'الأذكار', icon: Icons.nights_stay_rounded),
          _PlaceholderTab(title: 'تابعنا', icon: Icons.favorite_rounded),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  محتوى الصفحة الرئيسية (Tab 1)
// ══════════════════════════════════════════════════════

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TopSearchBar(),
              SizedBox(height: 18),
              BannerCarousel(),
              SizedBox(height: 18),
              ContinueReadingCard(),
              SizedBox(height: 22),
              GridMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  صفحة مؤقتة للتبويبات الأخرى (سيتم بناؤها لاحقاً)
// ══════════════════════════════════════════════════════

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'قيد التطوير...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
