import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'adhkar_details_screen.dart';

class AdhkarScreen extends StatelessWidget {
  AdhkarScreen({super.key});

  static final List> _categories = [
    {
      'title': 'أذكار الصباح',
      'subtitle': 'حصن المسلم في بداية اليوم',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'title': 'أذكار المساء',
      'subtitle': 'سكينة وطمأنينة آخر النهار',
      'icon': Icons.nights_stay_outlined,
    },
    {
      'title': 'أذكار بعد الصلاة',
      'subtitle': 'تسبيح واستغفار عقب الفرائض',
      'icon': Icons.mosque_outlined,
    },
    {
      'title': 'أذكار النوم',
      'subtitle': 'أذكار تسبق النوم والراحة',
      'icon': Icons.bedtime_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار', style: AppTextStyles.screenTitle),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
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
                    MaterialPageRoute(
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
