import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'duas_details_screen.dart';

/// صفحة الأدعية — قائمة عمودية بتصنيفات الأدعية المأثورة
class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'دعاء الشفاء',
      'subtitle': 'لطلب الشفاء من الأمراض ودفع البأس',
      'icon': Icons.healing_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'دعاء قبل النوم',
      'subtitle': 'أدعية مأثورة عند الإيواء إلى الفراش',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'دعاء الاستخارة',
      'subtitle': 'دعاء طلب الخيرة عند التردد في أمر',
      'icon': Icons.explore_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'دعاء السفر',
      'subtitle': 'أدعية الركوب والسفر والعودة',
      'icon': Icons.flight_takeoff_rounded,
      'color': Color(0xFF0EA5E9),
    },
    {
      'title': 'دعاء الرزق',
      'subtitle': 'لطلب الرزق الحلال الطيب والبركة',
      'icon': Icons.savings_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'دعاء الفرج',
      'subtitle': 'دعاء تفريج الكرب والهم والضيق',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'دعاء القنوت',
      'subtitle': 'أدعية القنوت في الوتر وقيام الليل',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'دعاء متفرق',
      'subtitle': 'جوامع الدعاء وأدعية متنوعة',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0C4A6E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── العنوان العلوي ─────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.pan_tool_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الأدعية',
                            style: AppTextStyles.headline.copyWith(fontSize: 22)),
                        Text('دعوات مأثورة لكل الحالات',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),

              // ── القائمة العمودية للتصنيفات ─────────
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _DuaCategoryVerticalTile(
                      category: _categories[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuaCategoryVerticalTile extends StatefulWidget {
  final Map<String, dynamic> category;

  const _DuaCategoryVerticalTile({required this.category});

  @override
  State<_DuaCategoryVerticalTile> createState() =>
      _DuaCategoryVerticalTileState();
}

class _DuaCategoryVerticalTileState extends State<_DuaCategoryVerticalTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.category['color'] as Color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DuasDetailsScreen(category: widget.category),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _pressed ? AppColors.skyLight : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed ? AppColors.skyPrimary : AppColors.divider,
            ),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: color.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.category['icon'] as IconData,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category['title'],
                      style: AppTextStyles.title.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.category['subtitle'],
                      style: AppTextStyles.tiny.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
