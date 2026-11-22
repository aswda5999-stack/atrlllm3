import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../data/hadiths_data.dart';
import 'hadiths_details_screen.dart';

/// صفحة الأحاديث الشريفة — واجهة دخول متطورة بحديث مختار، بحث فوري، وقائمة تصنيفات عمودية
class HadithsScreen extends StatefulWidget {
  const HadithsScreen({super.key});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final List<Map<String, dynamic>> _allHadiths;
  late int _featuredIndex;

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'أحاديث الأخلاق',
      'subtitle': 'ما يحث على حسن الخلق ومكارم الصفات',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'title': 'أحاديث الصلاة',
      'subtitle': 'فضل الصلاة وخشوعها وهدي النبي ﷺ',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'أحاديث الذكر',
      'subtitle': 'فضل الذكر والتسبيح وطمأنينة القلب',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'أحاديث الصدق',
      'subtitle': 'فضل الصدق وطمأنينة النفس والنهي عن الكذب',
      'icon': Icons.verified_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'أحاديث البر',
      'subtitle': 'بر الوالدين وصلة الأرحام والوفاء',
      'icon': Icons.people_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'أحاديث العلم',
      'subtitle': 'فضل طلب العلم النافع ونشره',
      'icon': Icons.school_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'أحاديث الصبر واليقين',
      'subtitle': 'الثبات عند الابتلاء والرضا بقضاء الله',
      'icon': Icons.shield_rounded,
      'color': Color(0xFF0C4A6E),
    },
    {
      'title': 'أحاديث متفرقة',
      'subtitle': 'جوامع الكلم وأحاديث متنوعة',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0EA5E9),
    },
  ];

  @override
  void initState() {
    super.initState();
    _allHadiths = HadithsData.getAllHadithsWithCategory();
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    _featuredIndex = _allHadiths.isEmpty ? 0 : dayOfYear % _allHadiths.length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shuffleFeaturedHadith() {
    if (_allHadiths.length <= 1) return;
    HapticFeedback.lightImpact();
    final rng = Random();
    int next = rng.nextInt(_allHadiths.length);
    if (next == _featuredIndex) {
      next = (next + 1) % _allHadiths.length;
    }
    setState(() => _featuredIndex = next);
  }

  List<Map<String, dynamic>> get _searchResults {
    if (_searchQuery.isEmpty) return const [];
    final q = _searchQuery.toLowerCase();
    return _allHadiths.where((h) {
      final text = (h['text'] ?? '').toString().toLowerCase();
      final narrator = (h['narrator'] ?? '').toString().toLowerCase();
      final source = (h['source'] ?? '').toString().toLowerCase();
      final cat = (h['category'] ?? '').toString().toLowerCase();
      return text.contains(q) ||
          narrator.contains(q) ||
          source.contains(q) ||
          cat.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final featured = _allHadiths[_featuredIndex];
    final isSearching = _searchQuery.isNotEmpty;
    final results = _searchResults;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── العنوان العلوي + زر حديث عشوائي ────
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الأحاديث الشريفة',
                              style: AppTextStyles.headline.copyWith(fontSize: 22)),
                          Text('من هدي النبي ﷺ وأقواله الجامعة',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'حديث آخر',
                      onPressed: _shuffleFeaturedHadith,
                      icon: const Icon(Icons.shuffle_rounded,
                          color: AppColors.skyDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── شريط البحث السريع في الأحاديث ───────
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.skyPrimary.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'ابحث في نص الحديث، الراوي، أو المصدر...',
                      hintStyle: AppTextStyles.caption,
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.skyDark),
                      suffixIcon: isSearching
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                if (isSearching) ...[
                  Text(
                    'نتائج البحث (${results.length})',
                    style: AppTextStyles.title.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  if (results.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(
                        'لا توجد أحاديث مطابقة لبحثك.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body,
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final h = results[i];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h['category'] as String,
                                style: AppTextStyles.tiny.copyWith(
                                  color: AppColors.skyDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                h['text'] as String,
                                style: AppTextStyles.quranAyahSmall
                                    .copyWith(fontSize: 17, height: 1.6),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${h['narrator']} · ${h['source']}',
                                style: AppTextStyles.tiny,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ] else ...[
                  // ── بطاقة حديث اليوم / المختار عند الدخول ─
                  _FeaturedHadithBanner(
                    hadith: featured,
                    onShuffle: _shuffleFeaturedHadith,
                    onCopy: () {
                      final txt =
                          '${featured['text']}
الراوي: ${featured['narrator']}
المصدر: ${featured['source']}';
                      Clipboard.setData(ClipboardData(text: txt));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ الحديث المختار')),
                      );
                    },
                    onShare: () {
                      final txt =
                          '${featured['text']}
الراوي: ${featured['narrator']}
المصدر: ${featured['source']}';
                      Share.share(txt);
                    },
                  ),
                  const SizedBox(height: 22),

                  // ── عنوان قائمة التصنيفات العمودية ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('أبواب الأحاديث',
                          style: AppTextStyles.title.copyWith(fontSize: 18)),
                      Text('${_categories.length} أبواب',
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── قائمة التصنيفات العمودية ─────────
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _HadithCategoryVerticalTile(
                        category: _categories[index],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedHadithBanner extends StatelessWidget {
  final Map<String, dynamic> hadith;
  final VoidCallback onShuffle;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const _FeaturedHadithBanner({
    required this.hadith,
    required this.onShuffle,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyDark.withOpacity(0.24),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      'حديث مختار · ${hadith['category']}',
                      style: AppTextStyles.captionOnDark.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'تبديل الحديث',
                onPressed: onShuffle,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hadith['text'] as String,
            style: AppTextStyles.quranAyahSmall.copyWith(
              color: Colors.white,
              fontSize: 19,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'الراوي: ${hadith['narrator']} · ${hadith['source']}',
            style: AppTextStyles.captionOnDark.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _BannerActionChip(
                icon: Icons.copy_rounded,
                label: 'نسخ',
                onTap: onCopy,
              ),
              const SizedBox(width: 10),
              _BannerActionChip(
                icon: Icons.share_rounded,
                label: 'مشاركة',
                onTap: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BannerActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.captionOnDark.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HadithCategoryVerticalTile extends StatefulWidget {
  final Map<String, dynamic> category;

  const _HadithCategoryVerticalTile({required this.category});

  @override
  State<_HadithCategoryVerticalTile> createState() =>
      _HadithCategoryVerticalTileState();
}

class _HadithCategoryVerticalTileState extends State<_HadithCategoryVerticalTile> {
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
            builder: (context) => HadithsDetailsScreen(category: widget.category),
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
