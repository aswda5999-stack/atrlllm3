import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الأدعية — تصنيفات الأدعية
class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'دعاء الشفاء',
      'subtitle': 'لطلب الشفاء من الأمراض',
      'icon': Icons.healing_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'دعاء قبل النوم',
      'subtitle': 'ما يُقال قبل النوم',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'دعاء الاستخارة',
      'subtitle': 'عند التردد في أمر ما',
      'icon': Icons.explore_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'دعاء السفر',
      'subtitle': 'عند الخروج للسفر',
      'icon': Icons.flight_takeoff_rounded,
      'color': Color(0xFF0EA5E9),
    },
    {
      'title': 'دعاء الرزق',
      'subtitle': 'لطلب الرزق والبركة',
      'icon': Icons.savings_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'دعاء الفرج',
      'subtitle': 'عند الكرب والهم',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'دعاء القنوت',
      'subtitle': 'دعاء قيام الليل',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'دعاء متفرق',
      'subtitle': 'أدعية متنوعة',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0C4A6E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── العنوان ─────────────────────────────
              Row(
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
              const SizedBox(height: 20),

              // ── شبكة التصنيفات ──────────────────────
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _DuaCategoryCard(category: _categories[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  بطاقة التصنيف
// ══════════════════════════════════════════════════════

class _DuaCategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;

  const _DuaCategoryCard({required this.category});

  @override
  State<_DuaCategoryCard> createState() => _DuaCategoryCardState();
}

class _DuaCategoryCardState extends State<_DuaCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.category['color'] as Color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: الانتقال إلى قائمة الأدعية لهذا التصنيف
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.category['icon'] as IconData,
                  color: color,
                  size: 26,
                ),
              ),
              const Spacer(),
              Text(
                widget.category['title'],
                style: AppTextStyles.title.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.category['subtitle'],
                style: AppTextStyles.tiny,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
