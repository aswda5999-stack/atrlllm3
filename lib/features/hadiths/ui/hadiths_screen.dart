import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الأحاديث الشريفة — تصنيفات الأحاديث
class HadithsScreen extends StatelessWidget {
  const HadithsScreen({super.key});

  // ── تصنيفات الأحاديث ─────────────────────────────
  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'أحاديث الأخلاق',
      'subtitle': 'ما يحث على حسن الخلق',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'أحاديث الصلاة',
      'subtitle': 'فضل الصلاة وأحكامها',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'أحاديث الذكر',
      'subtitle': 'فضل الأذكار والأدعية',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'أحاديث الصدق',
      'subtitle': 'فضل الصدق والنهي عن الكذب',
      'icon': Icons.verified_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'أحاديث البر',
      'subtitle': 'بر الوالدين وصلة الأرحام',
      'icon': Icons.people_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'أحاديث العلم',
      'subtitle': 'فضل طلب العلم وتعليمه',
      'icon': Icons.school_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'أحاديث الجهاد',
      'subtitle': 'فضل الجهاد والصبر',
      'icon': Icons.shield_rounded,
      'color': Color(0xFF0C4A6E),
    },
    {
      'title': 'أحاديث متفرقة',
      'subtitle': 'أحاديث منوعة في أبواب شتى',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0EA5E9),
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
                    child: const Icon(Icons.article_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الأحاديث الشريفة',
                          style: AppTextStyles.headline.copyWith(fontSize: 22)),
                      Text('من هدي النبي ﷺ',
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
                  return _HadithCategoryCard(category: _categories[index]);
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

class _HadithCategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;

  const _HadithCategoryCard({required this.category});

  @override
  State<_HadithCategoryCard> createState() => _HadithCategoryCardState();
}

class _HadithCategoryCardState extends State<_HadithCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.category['color'] as Color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: الانتقال إلى قائمة الأحاديث لهذا التصنيف
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
