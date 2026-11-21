import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الصوتيات — قائمة القراء
class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // ── قائمة القراء (30 قارئاً) ──────────────────────
  // يمكنك إضافة المزيد بسهولة، فقط أضف (الاسم ومعرف everyayah)
  static const List<Map<String, String>> _reciters = [
    {'name': 'مشاري العفاسي', 'id': 'Alafasy_128kbps'},
    {'name': 'عبد الباسط عبد الصمد (مرتل)', 'id': 'Abdul_Basit_Murattal_64kbps'},
    {'name': 'عبد الباسط عبد الصمد (مجود)', 'id': 'Abdul_Basit_Mujawwad_128kbps'},
    {'name': 'محمود خليل الحصري', 'id': 'Husary_128kbps'},
    {'name': 'محمد صديق المنشاوي (مرتل)', 'id': 'Minshawy_Murattal_128kbps'},
    {'name': 'محمد صديق المنشاوي (مجود)', 'id': 'Minshawy_Mujawwad_64kbps'},
    {'name': 'أحمد بن علي العجمي', 'id': 'ahmed_ibn_ali_al_ajamy_128kbps'},
    {'name': 'سعد الغامدي', 'id': 'Saad_Al-Ghamdi_128kbps'},
    {'name': 'ياسر الدوسري', 'id': 'Yasser_Ad-Dussary_128kbps'},
    {'name': 'عبد الرحمن السديس', 'id': 'Abdurrahmaan_As-Sudais_192kbps'},
    {'name': 'ماهر المعيقلي', 'id': 'MaherAlMuaiqly128kbps'},
    {'name': 'سعود الشريم', 'id': 'Saud_Al-Shuraim_128kbps'},
    {'name': 'علي الحذيفي', 'id': 'Ali_Al-Hudhaify_128kbps'},
    {'name': 'محمد أيوب', 'id': 'Muhammad_Ayyoub_128kbps'},
    {'name': 'خالد الجليل', 'id': 'Khalid_Al-Jalil_128kbps'},
    {'name': 'ناصر القطامي', 'id': 'Nasser_Alqatami_128kbps'},
    {'name': 'فارس عباد', 'id': 'Fares_Abbad_64kbps'},
    {'name': 'أحمد الحواشي', 'id': 'ahmed_al_hawashi_128kbps'},
    {'name': 'عبد الله بصفر', 'id': 'Abdullah_Basfar_192kbps'},
    {'name': 'محمد الطبلاوي', 'id': 'Mohammad_al_Tablaway_128kbps'},
    {'name': 'عبد الولي محمد', 'id': 'AbdulWali_AlArkani_128kbps'},
    {'name': 'إبراهيم الأخضر', 'id': 'Ibrahim_Akhdar_128kbps'},
    {'name': 'محمود علي البنا', 'id': 'Mahmoud_AlBanna_128kbps'},
    {'name': 'صلاح بوخاطر', 'id': 'Salah_Bukhatir_128kbps'},
    {'name': 'أحمد صابر', 'id': 'Ahmed_Saber_128kbps'},
    {'name': 'عبد المحسن القاسم', 'id': 'Abdul_Mohsen_Al_Qasim_128kbps'},
    {'name': 'عبد الله عواد الجهني', 'id': 'Abdullah_Awad_Al_Juhani_128kbps'},
    {'name': 'ياسر الفيلكاوي', 'id': 'Yaser_Filakawi_128kbps'},
    {'name': 'محمد المحيسني', 'id': 'Mohammed_Al_Mohisny_128kbps'},
    {'name': 'عبد الله المطرود', 'id': 'Abdullah_Matroud_128kbps'},
  ];

  List<Map<String, String>> get _filteredReciters {
    if (_searchQuery.isEmpty) return _reciters;
    return _reciters
        .where((r) => r['name']!.contains(_searchQuery))
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
            // ── العنوان ─────────────────────────────
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الصوتيات',
                          style: AppTextStyles.headline.copyWith(fontSize: 22)),
                      Text('اختر القارئ المفضل لديك',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),

            // ── شريط البحث ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── قائمة القراء ─────────────────────────
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: _filteredReciters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _ReciterCard(
                    name: _filteredReciters[index]['name']!,
                    index: index + 1,
                  );
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
//  بطاقة القارئ
// ══════════════════════════════════════════════════════

class _ReciterCard extends StatefulWidget {
  final String name;
  final int index;

  const _ReciterCard({required this.name, required this.index});

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
      onTap: () {
        // TODO: الانتقال إلى قائمة السور بصوت هذا القارئ
      },
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
            // رقم القارئ أو الأيقونة
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.skyLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppColors.skyDark, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.name,
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
