import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'adhkar_details_screen.dart';

class AdhkarScreen extends StatelessWidget {
  AdhkarScreen({super.key});

  final List> _categories = >[
    <String, dynamic>{
      'title': 'أذكار الصباح',
      'subtitle': 'حصن المسلم في بداية اليوم',
      'icon': Icons.wb_sunny_outlined,
      'items': >[
        <String, dynamic>{
          'text': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'reference': 'رواه مسلم',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.',
          'reference': 'رواه الترمذي',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
          'reference': 'رواه مسلم',
          'count': 100,
        },
      ],
    },
    <String, dynamic>{
      'title': 'أذكار المساء',
      'subtitle': 'سكينة وطمأنينة آخر النهار',
      'icon': Icons.nights_stay_outlined,
      'items': >[
        <String, dynamic>{
          'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'reference': 'رواه مسلم',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ.',
          'reference': 'رواه الترمذي',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
          'reference': 'رواه مسلم',
          'count': 3,
        },
      ],
    },
    <String, dynamic>{
      'title': 'أذكار بعد الصلاة',
      'subtitle': 'تسبيح واستغفار عقب الفرائض',
      'icon': Icons.mosque_outlined,
      'items': >[
        <String, dynamic>{
          'text': 'أَسْتَغْفِرُ اللَّهَ (ثلاثاً)، اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
          'reference': 'رواه مسلم',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ.',
          'reference': 'متفق عليه',
          'count': 33,
        },
      ],
    },
    <String, dynamic>{
      'title': 'أذكار النوم',
      'subtitle': 'أذكار تسبق النوم والراحة',
      'icon': Icons.bedtime_outlined,
      'items': >[
        <String, dynamic>{
          'text': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا.',
          'reference': 'رواه البخاري',
          'count': 1,
        },
        <String, dynamic>{
          'text': 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.',
          'reference': 'رواه أبو داود والترمذي',
          'count': 3,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الأذكار',
          style: AppTextStyles.body.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> category = _categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.skyLight,
                  child: Icon(
                    category['icon'] as IconData,
                    color: AppColors.skyDark,
                  ),
                ),
                title: Text(
                  category['title'] as String,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  category['subtitle'] as String,
                  style: AppTextStyles.caption,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (_) => AdhkarDetailsScreen(category: category),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
