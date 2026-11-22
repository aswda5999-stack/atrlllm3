import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'adhkar_details_screen.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'title': 'أذكار الصباح', 'subtitle': 'تُقال بعد صلاة الفجر حتى الضحى', 'icon': Icons.wb_sunny_rounded, 'color': Color(0xFFF59E0B)},
    {'title': 'أذكار المساء', 'subtitle': 'تُقال بعد صلاة العصر حتى المغرب', 'icon': Icons.nights_stay_rounded, 'color': Color(0xFF6366F1)},
    {'title': 'أذكار النوم', 'subtitle': 'قبل الذهاب إلى الفراش', 'icon': Icons.bedtime_rounded, 'color': Color(0xFF0284C7)},
    {'title': 'أذكار الاستيقاظ', 'subtitle': 'عند الاستيقاظ من النوم', 'icon': Icons.alarm_rounded, 'color': Color(0xFF10B981)},
    {'title': 'أذكار بعد الصلاة', 'subtitle': 'بعد الانتهاء من الصلوات المفروضة', 'icon': Icons.mosque_rounded, 'color': Color(0xFF0C4A6E)},
    {'title': 'أذكار متفرقة', 'subtitle': 'أذكار متنوعة ليومك', 'icon': Icons.auto_awesome_rounded, 'color': Color(0xFF8B5CF6)},
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
                    child: const Icon(Icons.nights_stay_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الأذكار', style: AppTextStyles.headline.copyWith(fontSize: 22)),
                      Text('حصّن يومك بذكر الله', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── قائمة الأسطر ────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _CategoryTile(category: _categories[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final Map<String, dynamic> category;
  const _CategoryTile({required this.category});

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
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
            builder: (context) => AdhkarDetailsScreen(category: widget.category),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.skyLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _pressed ? AppColors.skyPrimary : AppColors.divider),
          boxShadow: _pressed ? [] : [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            // أيقونة صغيرة
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.category['icon'], color: color, size: 22),
            ),
            const SizedBox(width: 14),
            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.category['title'], style: AppTextStyles.title.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(widget.category['subtitle'], style: AppTextStyles.tiny.copyWith(fontSize: 11)),
                ],
              ),
            ),
            // سهم
            const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
