import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الأحاديث الشريفة — واجهة دخول متطورة وقائمة تصنيفات عمودية
class HadithsScreen extends StatefulWidget {
  const HadithsScreen({super.key});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _featuredIndex = 0;

  static const List> _categories = [
    {
      'title': 'أحاديث الأخلاق',
      'subtitle': 'ما يحث على حسن الخلق',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFEC4899),
      'hadiths': [
        {
          'text': '«إنما بعثت لأتمم صالح الأخلاق»',
          'narrator': 'أبو هريرة رضي الله عنه',
          'source': 'الأدب المفرد',
        },
        {
          'text': '«أكمل المؤمنين إيماناً أحسنهم خلقاً»',
          'narrator': 'أبو هريرة رضي الله عنه',
          'source': 'سنن الترمذي',
        },
      ],
    },
    {
      'title': 'أحاديث الصلاة',
      'subtitle': 'فضل الصلاة وأحكامها',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0284C7),
      'hadiths': [
        {
          'text': '«صلّوا كما رأيتموني أصلّي»',
          'narrator': 'مالك بن الحويرث رضي الله عنه',
          'source': 'صحيح البخاري',
        },
        {
          'text': '«أقرب ما يكون العبد من ربه وهو ساجد، فأكثروا الدعاء»',
          'narrator': 'أبو هريرة رضي الله عنه',
          'source': 'صحيح مسلم',
        },
      ],
    },
    {
      'title': 'أحاديث الذكر',
      'subtitle': 'فضل الأذكار والأدعية',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
      'hadiths': [
        {
          'text':
              '«كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم»',
          'narrator': 'أبو هريرة رضي الله عنه',
          'source': 'صحيح البخاري ومسلم',
        },
      ],
    },
    {
      'title': 'أحاديث الصدق',
      'subtitle': 'فضل الصدق والنهي عن الكذب',
      'icon': Icons.verified_rounded,
      'color': Color(0xFF10B981),
      'hadiths': [
        {
          'text':
              '«عليكم بالصدق، فإن الصدق يهدي إلى البر، وإن البر يهدي إلى الجنة»',
          'narrator': 'عبد الله بن مسعود رضي الله عنه',
          'source': 'صحيح البخاري ومسلم',
        },
      ],
    },
    {
      'title': 'أحاديث البر',
      'subtitle': 'بر الوالدين وصلة الأرحام',
      'icon': Icons.people_rounded,
      'color': Color(0xFFF59E0B),
      'hadiths': [
        {
          'text':
              '«من أحب أن يبسط له في رزقه، وينسأ له في أثره، فليصل رحمه»',
          'narrator': 'أنس بن مالك رضي الله عنه',
          'source': 'صحيح البخاري ومسلم',
        },
      ],
    },
    {
      'title': 'أحاديث العلم',
      'subtitle': 'فضل طلب العلم وتعليمه',
      'icon': Icons.school_rounded,
      'color': Color(0xFF8B5CF6),
      'hadiths': [
        {
          'text':
              '«من سلك طريقاً يلتمس فيه علماً، سهّل الله له به طريقاً إلى الجنة»',
          'narrator': 'أبو هريرة رضي الله عنه',
          'source': 'صحيح مسلم',
        },
      ],
    },
    {
      'title': 'أحاديث الجهاد',
      'subtitle': 'فضل الجهاد والصبر',
      'icon': Icons.shield_rounded,
      'color': Color(0xFF0C4A6E),
      'hadiths': [
        {
          'text':
              '«ومن يتصبّر يصبّره الله، وما أُعطي أحد عطاءً خيراً وأوسع من الصبر»',
          'narrator': 'أبو سعيد الخدري رضي الله عنه',
          'source': 'صحيح البخاري ومسلم',
        },
      ],
    },
    {
      'title': 'أحاديث متفرقة',
      'subtitle': 'أحاديث منوعة في أبواب شتى',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0EA5E9),
      'hadiths': [
        {
          'text': '«خيركم من تعلّم القرآن وعلّمه»',
          'narrator': 'عثمان بن عفان رضي الله عنه',
          'source': 'صحيح البخاري',
        },
      ],
    },
  ];

  List> get _flatHadiths {
    final List> all = [];
    for (final c in _categories) {
      for (final h in (c['hadiths'] as List>)) {
        all.add({...h, 'cat': c['title']});
      }
    }
    return all;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategorySheet(Map<String, dynamic> cat) {
    final list = cat['hadiths'] as List>;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.82,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Text(
              cat['title'] as String,
              style: AppTextStyles.title.copyWith(fontSize: 19),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final h = list[idx];
                  final shareTxt =
                      '${h['text']}\nالراوي: ${h['narrator']} · ${h['source']}';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          h['text'] as String,
                          style: AppTextStyles.quranAyahSmall.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الراوي: ${h['narrator']} · ${h['source']}',
                          style: AppTextStyles.tiny,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 20),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: shareTxt),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم النسخ')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_rounded, size: 20),
                              onPressed: () => Share.share(shareTxt),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _flatHadiths;
    final featured = all[_featuredIndex % all.length];
    final matches = _searchQuery.isEmpty
        ? const >[]
        : all
            .where((h) =>
                h['text'].toString().contains(_searchQuery) ||
                h['narrator'].toString().contains(_searchQuery) ||
                h['cat'].toString().contains(_searchQuery))
            .toList();

    return IslamicPatternBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.article_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الأحاديث الشريفة',
                          style: AppTextStyles.headline.copyWith(fontSize: 22),
                        ),
                        const Text(
                          'من هدي النبي ﷺ',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _featuredIndex = Random().nextInt(all.length);
                      });
                    },
                    icon: const Icon(
                      Icons.shuffle_rounded,
                      color: AppColors.skyDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: const InputDecoration(
                    hintText: 'ابحث في الأحاديث أو الرواة...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.skyDark,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_searchQuery.isNotEmpty) ...[
                Text(
                  'النتائج (${matches.length})',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ...matches.map(
                  (h) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
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
                          h['cat'] as String,
                          style: AppTextStyles.tiny
                              .copyWith(color: AppColors.skyDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          h['text'] as String,
                          style: AppTextStyles.quranAyahSmall.copyWith(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${h['narrator']} · ${h['source']}',
                          style: AppTextStyles.tiny,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'حديث مختار · ${featured['cat']}',
                        style: AppTextStyles.captionOnDark,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        featured['text'] as String,
                        style: AppTextStyles.quranAyahSmall.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${featured['narrator']} · ${featured['source']}',
                        style: AppTextStyles.captionOnDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'التصنيفات',
                  style: AppTextStyles.title.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final color = cat['color'] as Color;
                    return GestureDetector(
                      onTap: () => _openCategorySheet(cat),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                cat['icon'] as IconData,
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
                                    cat['title'] as String,
                                    style: AppTextStyles.title
                                        .copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    cat['subtitle'] as String,
                                    style: AppTextStyles.tiny,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
