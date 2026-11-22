import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الأدعية — قائمة عمودية بتصنيفات الأدعية المأثورة
class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  static const List> _categories = [
    {
      'title': 'دعاء الشفاء',
      'subtitle': 'لطلب الشفاء من الأمراض ودفع البأس',
      'icon': Icons.healing_rounded,
      'color': Color(0xFF10B981),
      'items': [
        {
          'text':
              'اللهم رب الناس أذهب البأس، اشف أنت الشافي، لا شفاء إلا شفاؤك، شفاءً لا يغادر سقماً.',
          'target': 3,
          'ref': 'صحيح البخاري ومسلم',
        },
        {
          'text': 'أعوذ بعزة الله وقدرته من شر ما أجد وأحاذر.',
          'target': 7,
          'ref': 'صحيح مسلم',
        },
      ],
    },
    {
      'title': 'دعاء قبل النوم',
      'subtitle': 'أدعية مأثورة عند الإيواء إلى الفراش',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF0284C7),
      'items': [
        {
          'text': 'باسمك اللهم أموت وأحيا.',
          'target': 1,
          'ref': 'صحيح البخاري',
        },
        {
          'text': 'اللهم قني عذابك يوم تبعث عبادك.',
          'target': 3,
          'ref': 'سنن أبي داود والترمذي',
        },
      ],
    },
    {
      'title': 'دعاء الاستخارة',
      'subtitle': 'دعاء طلب الخيرة عند التردد في أمر',
      'icon': Icons.explore_rounded,
      'color': Color(0xFF8B5CF6),
      'items': [
        {
          'text':
              'اللهم إني أستخيرك بعلمك، وأستقدرك بقدرتك، وأسألك من فضلك العظيم، فإنك تقدر ولا أقدر، وتعلم ولا أعلم، وأنت علام الغيوب.',
          'target': 1,
          'ref': 'صحيح البخاري',
        },
      ],
    },
    {
      'title': 'دعاء السفر',
      'subtitle': 'أدعية الركوب والسفر والعودة',
      'icon': Icons.flight_takeoff_rounded,
      'color': Color(0xFF0EA5E9),
      'items': [
        {
          'text':
              'الله أكبر، الله أكبر، الله أكبر، سبحان الذي سخر لنا هذا وما كنا له مقرنين وإنا إلى ربنا لمنقلبون.',
          'target': 1,
          'ref': 'صحيح مسلم',
        },
      ],
    },
    {
      'title': 'دعاء الرزق',
      'subtitle': 'لطلب الرزق الحلال الطيب والبركة',
      'icon': Icons.savings_rounded,
      'color': Color(0xFFF59E0B),
      'items': [
        {
          'text': 'اللهم اكفني بحلالك عن حرامك، وأغنني بفضلك عمن سواك.',
          'target': 3,
          'ref': 'سنن الترمذي',
        },
      ],
    },
    {
      'title': 'دعاء الفرج',
      'subtitle': 'دعاء تفريج الكرب والهم والضيق',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFEC4899),
      'items': [
        {
          'text': 'لا إله إلا أنت سبحانك إني كنت من الظالمين.',
          'target': 3,
          'ref': 'سنن الترمذي',
        },
      ],
    },
    {
      'title': 'دعاء القنوت',
      'subtitle': 'أدعية القنوت في الوتر وقيام الليل',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF6366F1),
      'items': [
        {
          'text':
              'اللهم اهدني فيمن هديت، وعافني فيمن عافيت، وتولني فيمن توليت، وبارك لي فيما أعطيت.',
          'target': 1,
          'ref': 'سنن أبي داود والترمذي',
        },
      ],
    },
    {
      'title': 'دعاء متفرق',
      'subtitle': 'جوامع الدعاء وأدعية متنوعة',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF0C4A6E),
      'items': [
        {
          'text':
              'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار.',
          'target': 3,
          'ref': 'صحيح البخاري ومسلم',
        },
      ],
    },
  ];

  void _openCategoryDuas(BuildContext context, Map<String, dynamic> cat) {
    final rawItems = (cat['items'] as List>)
        .map((e) => {...e, 'count': 0})
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
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
                      itemCount: rawItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final item = rawItems[idx];
                        final count = item['count'] as int;
                        final target = item['target'] as int;
                        final done = count >= target;
                        final text = item['text'] as String;

                        return GestureDetector(
                          onTap: () {
                            if (count < target) {
                              HapticFeedback.lightImpact();
                              setModalState(() => item['count'] = count + 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.skyLight
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: done
                                    ? AppColors.success
                                    : AppColors.divider,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  text,
                                  style: AppTextStyles.quranAyahSmall.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'المرجع: ${item['ref']}',
                                  style: AppTextStyles.tiny,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: done
                                            ? AppColors.success
                                            : AppColors.skyDark,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '$count / $target',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy_rounded,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: text),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('تم النسخ'),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share_rounded,
                                        size: 20,
                                      ),
                                      onPressed: () => Share.share(text),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IslamicPatternBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.pan_tool_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأدعية',
                        style: AppTextStyles.headline.copyWith(fontSize: 22),
                      ),
                      const Text(
                        'دعوات مأثورة لكل الحالات',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final color = cat['color'] as Color;
                  return GestureDetector(
                    onTap: () => _openCategoryDuas(context, cat),
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
                            width: 50,
                            height: 50,
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
                                  style:
                                      AppTextStyles.title.copyWith(fontSize: 16),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  cat['subtitle'] as String,
                                  style:
                                      AppTextStyles.tiny.copyWith(fontSize: 12),
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
            ),
          ],
        ),
      ),
    );
  }
}
