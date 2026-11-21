import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة القرآن الكريم — قائمة السور
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── بيانات السور الـ 114 (مبسطة) ──────────────────
  static const List<Map<String, dynamic>> _surahs = [
    {'id': 1, 'name': 'الفاتحة', 'verses': 7, 'type': 'مكية'},
    {'id': 2, 'name': 'البقرة', 'verses': 286, 'type': 'مدنية'},
    {'id': 3, 'name': 'آل عمران', 'verses': 200, 'type': 'مدنية'},
    {'id': 4, 'name': 'النساء', 'verses': 176, 'type': 'مدنية'},
    {'id': 5, 'name': 'المائدة', 'verses': 120, 'type': 'مدنية'},
    {'id': 6, 'name': 'الأنعام', 'verses': 165, 'type': 'مكية'},
    {'id': 7, 'name': 'الأعراف', 'verses': 206, 'type': 'مكية'},
    {'id': 8, 'name': 'الأنفال', 'verses': 75, 'type': 'مدنية'},
    {'id': 9, 'name': 'التوبة', 'verses': 129, 'type': 'مدنية'},
    {'id': 10, 'name': 'يونس', 'verses': 109, 'type': 'مكية'},
    {'id': 11, 'name': 'هود', 'verses': 123, 'type': 'مكية'},
    {'id': 12, 'name': 'يوسف', 'verses': 111, 'type': 'مكية'},
    {'id': 13, 'name': 'الرعد', 'verses': 43, 'type': 'مدنية'},
    {'id': 14, 'name': 'إبراهيم', 'verses': 52, 'type': 'مكية'},
    {'id': 15, 'name': 'الحجر', 'verses': 99, 'type': 'مكية'},
    {'id': 16, 'name': 'النحل', 'verses': 128, 'type': 'مكية'},
    {'id': 17, 'name': 'الإسراء', 'verses': 111, 'type': 'مكية'},
    {'id': 18, 'name': 'الكهف', 'verses': 110, 'type': 'مكية'},
    {'id': 19, 'name': 'مريم', 'verses': 98, 'type': 'مكية'},
    {'id': 20, 'name': 'طه', 'verses': 135, 'type': 'مكية'},
    // ... يمكن إكمال بقية السور بنفس الطريقة (حتى 114)
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: Column(
          children: [
            // ── شريط البحث ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded,
                        color: AppColors.skyDark, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) =>
                            setState(() => _searchQuery = val.trim()),
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن سورة...',
                          hintStyle: AppTextStyles.caption,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── قائمة السور ────────────────────────────
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
        // TODO: الانتقال إلى صفحة السورة
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
                    style: AppTextStyles.title.copyWith(fontSize: 16),
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
