import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/islamic_pattern_background.dart';
import '../adhkar/ui/adhkar_screen.dart';
import '../audio/ui/audio_screen.dart';
import '../follow_us/ui/follow_us_screen.dart';
import '../quran/ui/quran_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = <Widget>[
    _HomeDashboardTab(
      onNavigateTab: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    QuranScreen(),
    AudioScreen(),
    AdhkarScreen(),
    FollowUsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeDashboardTab extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const _HomeDashboardTab({required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final List> quickActions = >[
      <String, dynamic>{
        'title': 'المصحف الشريف',
        'subtitle': 'قراءة وتلاوة القرآن الكريم',
        'icon': Icons.menu_book_rounded,
        'tabIndex': 1,
      },
      <String, dynamic>{
        'title': 'التلاوات الصوتية',
        'subtitle': 'استماع للقراء والمشايخ',
        'icon': Icons.headphones_rounded,
        'tabIndex': 2,
      },
      <String, dynamic>{
        'title': 'الأذكار والتسبيح',
        'subtitle': 'أذكار الصباح والمساء وعداد التسبيح',
        'icon': Icons.wb_sunny_rounded,
        'tabIndex': 3,
      },
      <String, dynamic>{
        'title': 'تابعنا',
        'subtitle': 'قنواتنا ومنصاتنا الرسمية',
        'icon': Icons.share_rounded,
        'tabIndex': 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أثر مسلم',
          style: AppTextStyles.body.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.skyLight, width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'مرحباً بك في أثر مسلم',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'رفيقك اليومي للقرآن الكريم، التلاوات الصوتية، والأذكار.',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GridMenu(items: quickActions, onSelectTab: onNavigateTab),
          ],
        ),
      ),
    );
  }
}

class GridMenu extends StatelessWidget {
  final List> items;
  final ValueChanged<int> onSelectTab;

  const GridMenu({
    super.key,
    required this.items,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onSelectTab(item['tabIndex'] as int),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.skyLight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.skyLight,
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppColors.skyDark,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
