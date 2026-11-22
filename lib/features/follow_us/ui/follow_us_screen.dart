import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

class FollowUsScreen extends StatelessWidget {
  FollowUsScreen({super.key});

  static final List> _socialLinks = [
    {
      'title': 'قناة يوتيوب',
      'subtitle': 'تلاوات ومقاطع دعوية وتربوية',
      'icon': Icons.play_circle_fill,
      'color': Color(0xFFFF0000),
    },
    {
      'title': 'قناة تيليغرام',
      'subtitle': 'تحديثات التطبيق وفوائد يومية',
      'icon': Icons.send,
      'color': Color(0xFF0088CC),
    },
    {
      'title': 'صفحة فيسبوك',
      'subtitle': 'منشورات ومشاركات المجتمع',
      'icon': Icons.public,
      'color': Color(0xFF1877F2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تابعنا', style: AppTextStyles.screenTitle),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _socialLinks.length,
          itemBuilder: (context, index) {
            final item = _socialLinks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyDark.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: (item['color'] as Color).withOpacity(0.12),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item['subtitle'] as String,
                  style: AppTextStyles.caption,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        ),
      ),
    );
  }
}
