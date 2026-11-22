import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'quran_page_screen.dart';

/// صفحة القرآن الكريم — فهرس السور الـ 114
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  // ── بيانات السور الـ 114 كاملة مع أرقام الصفحات ──
  static const List<Map<String, dynamic>> _surahs = [
    {'id': 1, 'name': 'الفاتحة', 'verses': 7, 'type': 'مكية', 'page': 1},
    {'id': 2, 'name': 'البقرة', 'verses': 286, 'type': 'مدنية', 'page': 2},
    {'id': 3, 'name': 'آل عمران', 'verses': 200, 'type': 'مدنية', 'page': 50},
    {'id': 4, 'name': 'النساء', 'verses': 176, 'type': 'مدنية', 'page': 77},
    {'id': 5, 'name': 'المائدة', 'verses': 120, 'type': 'مدنية', 'page': 106},
    {'id': 6, 'name': 'الأنعام', 'verses': 165, 'type': 'مكية', 'page': 128},
    {'id': 7, 'name': 'الأعراف', 'verses': 206, 'type': 'مكية', 'page': 151},
    {'id': 8, 'name': 'الأنفال', 'verses': 75, 'type': 'مدنية', 'page': 177},
    {'id': 9, 'name': 'التوبة', 'verses': 129, 'type': 'مدنية', 'page': 187},
    {'id': 10, 'name': 'يونس', 'verses': 109, 'type': 'مكية', 'page': 208},
    {'id': 11, 'name': 'هود', 'verses': 123, 'type': 'مكية', 'page': 221},
    {'id': 12, 'name': 'يوسف', 'verses': 111, 'type': 'مكية', 'page': 235},
    {'id': 13, 'name': 'الرعد', 'verses': 43, 'type': 'مدنية', 'page': 249},
    {'id': 14, 'name': 'إبراهيم', 'verses': 52, 'type': 'مكية', 'page': 255},
    {'id': 15, 'name': 'الحجر', 'verses': 99, 'type': 'مكية', 'page': 262},
    {'id': 16, 'name': 'النحل', 'verses': 128, 'type': 'مكية', 'page': 267},
    {'id': 17, 'name': 'الإسراء', 'verses': 111, 'type': 'مكية', 'page': 282},
    {'id': 18, 'name': 'الكهف', 'verses': 110, 'type': 'مكية', 'page': 293},
    {'id': 19, 'name': 'مريم', 'verses': 98, 'type': 'مكية', 'page': 305},
    {'id': 20, 'name': 'طه', 'verses': 135, 'type': 'مكية', 'page': 312},
    {'id': 21, 'name': 'الأنبياء', 'verses': 112, 'type': 'مكية', 'page': 322},
    {'id': 22, 'name': 'الحج', 'verses': 78, 'type': 'مدنية', 'page': 332},
    {'id': 23, 'name': 'المؤمنون', 'verses': 118, 'type': 'مكية', 'page': 342},
    {'id': 24, 'name': 'النور', 'verses': 64, 'type': 'مدنية', 'page': 350},
    {'id': 25, 'name': 'الفرقان', 'verses': 77, 'type': 'مكية', 'page': 359},
    {'id': 26, 'name': 'الشعراء', 'verses': 227, 'type': 'مكية', 'page': 367},
    {'id': 27, 'name': 'النمل', 'verses': 93, 'type': 'مكية', 'page': 377},
    {'id': 28, 'name': 'القصص', 'verses': 88, 'type': 'مكية', 'page': 385},
    {'id': 29, 'name': 'العنكبوت', 'verses': 69, 'type': 'مكية', 'page': 396},
    {'id': 30, 'name': 'الروم', 'verses': 60, 'type': 'مكية', 'page': 404},
    {'id': 31, 'name': 'لقمان', 'verses': 34, 'type': 'مكية', 'page': 411},
    {'id': 32, 'name': 'السجدة', 'verses': 30, 'type': 'مكية', 'page': 415},
    {'id': 33, 'name': 'الأحزاب', 'verses': 73, 'type': 'مدنية', 'page': 418},
    {'id': 34, 'name': 'سبأ', 'verses': 54, 'type': 'مكية', 'page': 428},
    {'id': 35, 'name': 'فاطر', 'verses': 45, 'type': 'مكية', 'page': 434},
    {'id': 36, 'name': 'يس', 'verses': 83, 'type': 'مكية', 'page': 440},
    {'id': 37, 'name': 'الصافات', 'verses': 182, 'type': 'مكية', 'page': 446},
    {'id': 38, 'name': 'ص', 'verses': 88, 'type': 'مكية', 'page': 453},
    {'id': 39, 'name': 'الزمر', 'verses': 75, 'type': 'مكية', 'page': 458},
    {'id': 40, 'name': 'غافر', 'verses': 85, 'type': 'مكية', 'page': 467},
    {'id': 41, 'name': 'فصلت', 'verses': 54, 'type': 'مكية', 'page': 477},
    {'id': 42, 'name': 'الشورى', 'verses': 53, 'type': 'مكية', 'page': 483},
    {'id': 43, 'name': 'الزخرف', 'verses': 89, 'type': 'مكية', 'page': 489},
    {'id': 44, 'name': 'الدخان', 'verses': 59, 'type': 'مكية', 'page': 496},
    {'id': 45, 'name': 'الجاثية', 'verses': 37, 'type': 'مكية', 'page': 499},
    {'id': 46, 'name': 'الأحقاف', 'verses': 35, 'type': 'مكية', 'page': 502},
    {'id': 47, 'name': 'محمد', 'verses': 38, 'type': 'مدنية', 'page': 507},
    {'id': 48, 'name': 'الفتح', 'verses': 29, 'type': 'مدنية', 'page': 511},
    {'id': 49, 'name': 'الحجرات', 'verses': 18, 'type': 'مدنية', 'page': 515},
    {'id': 50, 'name': 'ق', 'verses': 45, 'type': 'مكية', 'page': 518},
    {'id': 51, 'name': 'الذاريات', 'verses': 60, 'type': 'مكية', 'page': 520},
    {'id': 52, 'name': 'الطور', 'verses': 49, 'type': 'مكية', 'page': 523},
    {'id': 53, 'name': 'النجم', 'verses': 62, 'type': 'مكية', 'page': 526},
    {'id': 54, 'name': 'القمر', 'verses': 55, 'type': 'مكية', 'page': 528},
    {'id': 55, 'name': 'الرحمن', 'verses': 78, 'type': 'مدنية', 'page': 531},
    {'id': 56, 'name': 'الواقعة', 'verses': 96, 'type': 'مكية', 'page': 534},
    {'id': 57, 'name': 'الحديد', 'verses': 29, 'type': 'مدنية', 'page': 537},
    {'id': 58, 'name': 'المجادلة', 'verses': 22, 'type': 'مدنية', 'page': 542},
    {'id': 59, 'name': 'الحشر', 'verses': 24, 'type': 'مدنية', 'page': 545},
    {'id': 60, 'name': 'الممتحنة', 'verses': 13, 'type': 'مدنية', 'page': 549},
    {'id': 61, 'name': 'الصف', 'verses': 14, 'type': 'مدنية', 'page': 551},
    {'id': 62, 'name': 'الجمعة', 'verses': 11, 'type': 'مدنية', 'page': 553},
    {'id': 63, 'name': 'المنافقون', 'verses': 11, 'type': 'مدنية', 'page': 554},
    {'id': 64, 'name': 'التغابن', 'verses': 18, 'type': 'مدنية', 'page': 556},
    {'id': 65, 'name': 'الطلاق', 'verses': 12, 'type': 'مدنية', 'page': 558},
    {'id': 66, 'name': 'التحريم', 'verses': 12, 'type': 'مدنية', 'page': 560},
    {'id': 67, 'name': 'الملك', 'verses': 30, 'type': 'مكية', 'page': 562},
    {'id': 68, 'name': 'القلم', 'verses': 52, 'type': 'مكية', 'page': 564},
    {'id': 69, 'name': 'الحاقة', 'verses': 52, 'type': 'مكية', 'page': 566},
    {'id': 70, 'name': 'المعارج', 'verses': 44, 'type': 'مكية', 'page': 568},
    {'id': 71, 'name': 'نوح', 'verses': 28, 'type': 'مكية', 'page': 570},
    {'id': 72, 'name': 'الجن', 'verses': 28, 'type': 'مكية', 'page': 572},
    {'id': 73, 'name': 'المزمل', 'verses': 20, 'type': 'مكية', 'page': 574},
    {'id': 74, 'name': 'المدثر', 'verses': 56, 'type': 'مكية', 'page': 575},
    {'id': 75, 'name': 'القيامة', 'verses': 40, 'type': 'مكية', 'page': 577},
    {'id': 76, 'name': 'الإنسان', 'verses': 31, 'type': 'مدنية', 'page': 578},
    {'id': 77, 'name': 'المرسلات', 'verses': 50, 'type': 'مكية', 'page': 580},
    {'id': 78, 'name': 'النبأ', 'verses': 40, 'type': 'مكية', 'page': 582},
    {'id': 79, 'name': 'النازعات', 'verses': 46, 'type': 'مكية', 'page': 583},
    {'id': 80, 'name': 'عبس', 'verses': 42, 'type': 'مكية', 'page': 585},
    {'id': 81, 'name': 'التكوير', 'verses': 29, 'type': 'مكية', 'page': 586},
    {'id': 82, 'name': 'الانفطار', 'verses': 19, 'type': 'مكية', 'page': 587},
    {'id': 83, 'name': 'المطففين', 'verses': 36, 'type': 'مكية', 'page': 587},
    {'id': 84, 'name': 'الانشقاق', 'verses': 25, 'type': 'مكية', 'page': 589},
    {'id': 85, 'name': 'البروج', 'verses': 22, 'type': 'مكية', 'page': 590},
    {'id': 86, 'name': 'الطارق', 'verses': 17, 'type': 'مكية', 'page': 591},
    {'id': 87, 'name': 'الأعلى', 'verses': 19, 'type': 'مكية', 'page': 591},
    {'id': 88, 'name': 'الغاشية', 'verses': 26, 'type': 'مكية', 'page': 592},
    {'id': 89, 'name': 'الفجر', 'verses': 30, 'type': 'مكية', 'page': 593},
    {'id': 90, 'name': 'البلد', 'verses': 20, 'type': 'مكية', 'page': 594},
    {'id': 91, 'name': 'الشمس', 'verses': 15, 'type': 'مكية', 'page': 595},
    {'id': 92, 'name': 'الليل', 'verses': 21, 'type': 'مكية', 'page': 595},
    {'id': 93, 'name': 'الضحى', 'verses': 11, 'type': 'مكية', 'page': 596},
    {'id': 94, 'name': 'الشرح', 'verses': 8, 'type': 'مكية', 'page': 596},
    {'id': 95, 'name': 'التين', 'verses': 8, 'type': 'مكية', 'page': 597},
    {'id': 96, 'name': 'العلق', 'verses': 19, 'type': 'مكية', 'page': 597},
    {'id': 97, 'name': 'القدر', 'verses': 5, 'type': 'مكية', 'page': 598},
    {'id': 98, 'name': 'البينة', 'verses': 8, 'type': 'مدنية', 'page': 598},
    {'id': 99, 'name': 'الزلزلة', 'verses': 8, 'type': 'مدنية', 'page': 599},
    {'id': 100, 'name': 'العاديات', 'verses': 11, 'type': 'مكية', 'page': 599},
    {'id': 101, 'name': 'القارعة', 'verses': 11, 'type': 'مكية', 'page': 600},
    {'id': 102, 'name': 'التكاثر', 'verses': 8, 'type': 'مكية', 'page': 600},
    {'id': 103, 'name': 'العصر', 'verses': 3, 'type': 'مكية', 'page': 601},
    {'id': 104, 'name': 'الهمزة', 'verses': 9, 'type': 'مكية', 'page': 601},
    {'id': 105, 'name': 'الفيل', 'verses': 5, 'type': 'مكية', 'page': 601},
    {'id': 106, 'name': 'قريش', 'verses': 4, 'type': 'مكية', 'page': 602},
    {'id': 107, 'name': 'الماعون', 'verses': 7, 'type': 'مكية', 'page': 602},
    {'id': 108, 'name': 'الكوثر', 'verses': 3, 'type': 'مكية', 'page': 602},
    {'id': 109, 'name': 'الكافرون', 'verses': 6, 'type': 'مكية', 'page': 603},
    {'id': 110, 'name': 'النصر', 'verses': 3, 'type': 'مدنية', 'page': 603},
    {'id': 111, 'name': 'المسد', 'verses': 5, 'type': 'مكية', 'page': 603},
    {'id': 112, 'name': 'الإخلاص', 'verses': 4, 'type': 'مكية', 'page': 604},
    {'id': 113, 'name': 'الفلق', 'verses': 5, 'type': 'مكية', 'page': 604},
    {'id': 114, 'name': 'الناس', 'verses': 6, 'type': 'مكية', 'page': 604},
  ];

  List<Map<String, dynamic>> get _filteredSurahs {
    if (_searchQuery.isEmpty) return _surahs;
    return _surahs
        .where((surah) =>
            surah['name'].toString().contains(_searchQuery) ||
            surah['id'].toString() == _searchQuery)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: Column(
          children: [
            // ── شريط البحث المحسن ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.skyPrimary.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: _searchFocusNode.hasFocus ? AppColors.skyPrimary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: AppTextStyles.body.copyWith(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن سورة...',
                    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.skyDark, size: 24),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                              _searchFocusNode.unfocus();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            // ── قائمة السور ────────────────────────────
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: _filteredSurahs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final surah = _filteredSurahs[index];
                  return _SurahCard(surah: surah);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  بطاقة السورة
// ══════════════════════════════════════════════════════

class _SurahCard extends StatefulWidget {
  final Map<String, dynamic> surah;

  const _SurahCard({required this.surah});

  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuranPageScreen(
              initialPage: widget.surah['page'] ?? 1,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.skyLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? AppColors.skyPrimary : AppColors.divider,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.skyPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            // ── رقم السورة ─────────────────────────
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '${widget.surah['id']}',
                  style: AppTextStyles.titleOnDark.copyWith(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── اسم السورة والتفاصيل ────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.surah['name'],
                    // ── إزالة الخط الأصفر (التسطير) نهائياً ──
                    style: const TextStyle(
                      fontFamily: 'Thuluth',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.1,
                      decoration: TextDecoration.none, // إزالة التسطير
                      decorationColor: Colors.transparent, // إزالة لون التسطير
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _InfoChip(text: widget.surah['type']),
                      const SizedBox(width: 6),
                      _InfoChip(text: '${widget.surah['verses']} آية'),
                    ],
                  ),
                ],
              ),
            ),

            // ── أيقونة الانتقال ─────────────────────
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  const _InfoChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.skyLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.tiny.copyWith(
          color: AppColors.skyDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
