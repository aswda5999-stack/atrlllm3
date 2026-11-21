import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الأذكار — تصنيفات الأذكار
class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'أذكار الصباح',
      'subtitle': 'تُقال بعد صلاة الفجر حتى الضحى',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'أذكار المساء',
      'subtitle': 'تُقال بعد صلاة العصر حتى المغرب',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'أذكار النوم',
      'subtitle': 'قبل الذهاب إلى الفراش',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'أذكار الاستيقاظ',
      'subtitle': 'عند الاستيقاظ من النوم',
      'icon': Icons.alarm_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'أذكار بعد الصلاة',
      'subtitle': 'بعد الانتهاء من الصلوات المفروضة',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0C4A6E),
    },
    {
      'title': 'أذكار متفرقة',
      'subtitle': 'أذكار متنوعة ليومك',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF8B5CF6),
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
                    child: const Icon(Icons.nights_stay_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الأذكار',
                          style: AppTextStyles.headline.copyWith(fontSize: 22)),
                      Text('حصّن يومك بذكر الله',
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
                  return _CategoryCard(category: _categories[index]);
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

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;

  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.category['color'] as Color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: الانتقال إلى قائمة الأذكار لهذا التصنيف
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
              // الأيقونة
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
              // العنوان
              Text(
                widget.category['title'],
                style: AppTextStyles.title.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // الوصف
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
