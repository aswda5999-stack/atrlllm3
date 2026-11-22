import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

class FollowUsScreen extends StatelessWidget {
  FollowUsScreen({super.key});

  final List<Map<String, dynamic>> _socialLinks = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'قناة يوتيوب',
      'subtitle': 'تلاوات ومقاطع دعوية وتربوية',
      'icon': Icons.play_circle_fill,
      'color': const Color(0xFFFF0000),
    },
    <String, dynamic>{
      'title': 'قناة تيليغرام',
      'subtitle': 'تحديثات التطبيق وفوائد يومية',
      'icon': Icons.send,
      'color': const Color(0xFF0088CC),
    },
    <String, dynamic>{
      'title': 'صفحة فيسبوك',
      'subtitle': 'منشورات ومشاركات المجتمع',
      'icon': Icons.public,
      'color': const Color(0xFF1877F2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تابعنا',
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
          itemCount: _socialLinks.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> item = _socialLinks[index];
            final Color itemColor = item['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
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
                  backgroundColor: itemColor.withOpacity(0.12),
                  child: Icon(
                    item['icon'] as IconData,
                    color: itemColor,
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
