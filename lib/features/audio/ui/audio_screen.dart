import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'reciter_surahs_screen.dart';

/// صفحة الصوتيات المطوّرة — قائمة القراء مع المفضلة والانتقال المباشر للسور
class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  String _searchQuery = '';
  bool _onlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteIds = {};

  static const List<Map<String, String>> _reciters = [
    {'name': 'مشاري العفاسي', 'id': 'afs'},
    {'name': 'عبد الباسط عبد الصمد (مرتل)', 'id': 'basit'},
    {'name': 'عبد الباسط عبد الصمد (مجود)', 'id': 'basit_mjwd'},
    {'name': 'محمود خليل الحصري', 'id': 'sds'},
    {'name': 'محمد صديق المنشاوي (مرتل)', 'id': 'minsh'},
    {'name': 'محمد صديق المنشاوي (مجود)', 'id': 'minsh_mjwd'},
    {'name': 'أحمد بن علي العجمي', 'id': 'ajm'},
    {'name': 'سعد الغامدي', 'id': 's_gmd'},
    {'name': 'ياسر الدوسري', 'id': 'yasser'},
    {'name': 'عبد الرحمن السديس', 'id': 'sds'},
    {'name': 'ماهر المعيقلي', 'id': 'maher'},
    {'name': 'سعود الشريم', 'id': 'shur'},
    {'name': 'علي الحذيفي', 'id': 'huthifi'},
    {'name': 'محمد أيوب', 'id': 'ayyub'},
    {'name': 'خالد الجليل', 'id': 'jleel'},
    {'name': 'ناصر القطامي', 'id': 'qtm'},
    {'name': 'فارس عباد', 'id': 'frs_a'},
    {'name': 'أحمد الحواشي', 'id': 'hawashi'},
    {'name': 'عبد الله بصفر', 'id': 'bsfr'},
    {'name': 'محمد الطبلاوي', 'id': 'tblawi'},
    {'name': 'عبد الولي الأركاني', 'id': 'arkani'},
    {'name': 'إبراهيم الأخضر', 'id': 'akdar'},
    {'name': 'محمود علي البنا', 'id': 'banna'},
    {'name': 'صلاح بوخاطر', 'id': 'bu_khatir'},
    {'name': 'أحمد صابر', 'id': 'saber'},
    {'name': 'عبد المحسن القاسم', 'id': 'qasm'},
    {'name': 'عبد الله عواد الجهني', 'id': 'jhn'},
    {'name': 'ياسر الفيلكاوي', 'id': 'filkawi'},
    {'name': 'محمد المحيسني', 'id': 'mhsny'},
    {'name': 'عبد الله المطرود', 'id': 'mtrod'},
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_reciters') ?? [];
    if (mounted) {
      setState(() => _favoriteIds.addAll(saved));
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    await prefs.setStringList('favorite_reciters', _favoriteIds.toList());
  }

  List<Map<String, String>> get _filteredReciters {
    return _reciters.where((r) {
      final matchesQuery =
          _searchQuery.isEmpty || r['name']!.contains(_searchQuery);
      final matchesFav =
          !_onlyFavorites || _favoriteIds.contains(r['id']!);
      return matchesQuery && matchesFav;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredReciters;

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── العنوان العلوي + زر تصفية المفضلة ───
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.headphones_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الصوتيات',
                              style: AppTextStyles.headline.copyWith(fontSize: 22)),
                          Text('${_reciters.length} قارئاً · اختر القارئ للاستماع',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'القراء المفضلون',
                      onPressed: () =>
                          setState(() => _onlyFavorites = !_onlyFavorites),
                      icon: Icon(
                        _onlyFavorites
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: _onlyFavorites
                            ? AppColors.warning
                            : AppColors.textSecondary,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              // ── شريط البحث ──────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search_rounded,
                          color: AppColors.skyDark, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val.trim()),
                          style: AppTextStyles.body.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن قارئ...',
                            hintStyle: AppTextStyles.caption,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              size: 18, color: AppColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // ── قائمة القراء العمودية ─────────────────
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          _onlyFavorites
                              ? 'لا يوجد قراء مفضلون بعد.'
                              : 'لا توجد نتائج مطابقة.',
                          style: AppTextStyles.body,
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final reciter = list[index];
                          final rId = reciter['id']!;
                          final rName = reciter['name']!;
                          final isFav = _favoriteIds.contains(rId);

                          return _ReciterCard(
                            name: rName,
                            index: index + 1,
                            isFavorite: isFav,
                            onToggleFavorite: () => _toggleFavorite(rId),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReciterSurahsScreen(
                                    reciterName: rName,
                                    reciterId: rId,
                                  ),
                                ),
                              );
                            },
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

class _ReciterCard extends StatefulWidget {
  final String name;
  final int index;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _ReciterCard({
    required this.name,
    required this.index,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  State<_ReciterCard> createState() => _ReciterCardState();
}

class _ReciterCardState extends State<_ReciterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.skyLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? AppColors.skyPrimary : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.skyLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.headphones_rounded,
                  color: AppColors.skyDark, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.name,
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
            ),
            IconButton(
              onPressed: widget.onToggleFavorite,
              icon: Icon(
                widget.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: widget.isFavorite
                    ? AppColors.warning
                    : AppColors.textSecondary,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
