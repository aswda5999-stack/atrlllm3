import 'package:flutter/material.dart';
import '../../core/widgets/islamic_pattern_background.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../audio/ui/audio_screen.dart';
import '../quran/ui/quran_screen.dart';
import '../adhkar/ui/adhkar_screen.dart';
import '../follow_us/ui/follow_us_screen.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/grid_menu.dart';
import 'widgets/top_search_bar.dart';

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

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        physics: const BouncingScrollPhysics(),
        children: const [
          _HomeTab(),
          AudioScreen(),
          QuranScreen(),
          AdhkarScreen(),
          FollowUsScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: _currentIndex, onTap: _onNavTap),
    );
  }
}

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
