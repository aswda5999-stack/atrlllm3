import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../data/hadiths_data.dart';

class HadithsDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  const HadithsDetailsScreen({super.key, required this.category});

  @override
  State<HadithsDetailsScreen> createState() => _HadithsDetailsScreenState();
}

class _HadithsDetailsScreenState extends State<HadithsDetailsScreen> {
  late final List<Map<String, dynamic>> _hadiths;
  final Set<String> _favorites = {};
  final Set<String> _expandedBenefits = {};

  @override
  void initState() {
    super.initState();
    _hadiths = HadithsData.getByCategory(widget.category['title']);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_hadiths') ?? [];
    if (mounted) {
      setState(() => _favorites.addAll(saved));
    }
  }

  Future<void> _toggleFavorite(String text) async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(text)) {
        _favorites.remove(text);
      } else {
        _favorites.add(text);
      }
    });
    await prefs.setStringList('favorite_hadiths', _favorites.toList());
  }

  void _toggleBenefit(String text) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_expandedBenefits.contains(text)) {
        _expandedBenefits.remove(text);
      } else {
        _expandedBenefits.add(text);
      }
    });
  }

  String _formatShareText(Map<String, dynamic> h) {
    final buf = StringBuffer()
      ..writeln(h['text'])
      ..writeln('الراوي: ${h['narrator']}')
      ..writeln('المصدر: ${h['source']}');
    return buf.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final accent = (widget.category['color'] as Color?) ?? AppColors.skyDark;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── الشريط العلوي ──────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _CircleNavButton(
                      icon: Icons.arrow_forward_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.category['title'],
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title.copyWith(fontSize: 19),
                          ),
                          Text(
                            '${_hadiths.length} أحاديث نبوية',
                            style: AppTextStyles.tiny,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // ── قائمة الأحاديث العمودية ──────────────
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _hadiths.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _hadiths[index];
                    final text = item['text'] as String;
                    final isFav = _favorites.contains(text);
                    final showBenefit = _expandedBenefits.contains(text);

                    return _HadithItemCard(
                      index: index + 1,
                      item: item,
                      accent: accent,
                      isFav: isFav,
                      showBenefit: showBenefit,
                      onToggleFav: () => _toggleFavorite(text),
                      onToggleBenefit: () => _toggleBenefit(text),
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: _formatShareText(item)));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ نص الحديث والمصدر')),
                        );
                      },
                      onShare: () => Share.share(_formatShareText(item)),
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

class _HadithItemCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> item;
  final Color accent;
  final bool isFav;
  final bool showBenefit;
  final VoidCallback onToggleFav;
  final VoidCallback onToggleBenefit;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const _HadithItemCard({
    required this.index,
    required this.item,
    required this.accent,
    required this.isFav,
    required this.showBenefit,
    required this.onToggleFav,
    required this.onToggleBenefit,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // رقم الحديث + المفضلة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'حديث #$index',
                  style: AppTextStyles.tiny.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onToggleFav,
                icon: Icon(
                  isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isFav ? AppColors.skyDark : AppColors.textSecondary,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // نص الحديث
          Text(
            item['text'] as String,
            style: AppTextStyles.quranAyahSmall.copyWith(
              fontSize: 19,
              height: 1.75,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // الراوي والمصدر
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الراوي: ${item['narrator']}',
                  style: AppTextStyles.tiny.copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المصدر: ${item['source']}',
                  style: AppTextStyles.tiny.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // الفائدة المختصرة عند التوسيع
          if (showBenefit && item['benefit'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.skyLight.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.skySoft),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: AppColors.skyDark, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['benefit'] as String,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.skyDeep,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // شريط الأدوات: فائدة، نسخ، مشاركة
          Row(
            children: [
              TextButton.icon(
                onPressed: onToggleBenefit,
                icon: Icon(
                  showBenefit
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.auto_stories_rounded,
                  size: 18,
                ),
                label: Text(showBenefit ? 'إخفاء الفائدة' : 'فائدة الحديث'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'نسخ',
                onPressed: onCopy,
                icon: const Icon(Icons.copy_rounded,
                    size: 20, color: AppColors.textSecondary),
              ),
              IconButton(
                tooltip: 'مشاركة',
                onPressed: onShare,
                icon: const Icon(Icons.share_rounded,
                    size: 20, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.skyDark, size: 22),
      ),
    );
  }
}
