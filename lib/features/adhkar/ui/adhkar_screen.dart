import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'adhkar_details_screen.dart';

/// صفحة الأذكار الرئيسية — عرض التصنيفات اليومية
class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  static const List> _categories = [
    {
      'title': 'أذكار الصباح',
      'subtitle': 'أذكار وأوراد بداية اليوم',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'أذكار المساء',
      'subtitle': 'أذكار وأوراد نهاية اليوم',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'أذكار النوم',
      'subtitle': 'ما يُقال قبل النوم',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'title': 'أذكار الاستيقاظ',
      'subtitle': 'ما يُقال عند الاستيقاظ',
      'icon': Icons.alarm_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'أذكار بعد الصلاة',
      'subtitle': 'الأذكار المشروعة بعد السلام',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0EA5E9),
    },
    {
      'title': 'أذكار متفرقة',
      'subtitle': 'تسبيح واستغفار وأوراد عامة',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF8B5CF6),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.nights_stay_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأذكار',
                        style: AppTextStyles.headline.copyWith(fontSize: 22),
                      ),
                      const Text(
                        'حصن المسلم اليومي',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _AdhkarCategoryCard(category: _categories[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdhkarCategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;

  const _AdhkarCategoryCard({required this.category});

  @override
  State<_AdhkarCategoryCard> createState() => _AdhkarCategoryCardState();
}

class _AdhkarCategoryCardState extends State<_AdhkarCategoryCard> {
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
            builder: (context) => AdhkarDetailsScreen(
              category: widget.category,
            ),
          ),
        );
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
                widget.category['title'] as String,
                style: AppTextStyles.title.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.category['subtitle'] as String,
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

/// بيانات الأذكار حسب التصنيف مع عدد التكرار والمرجع
class AdhkarData {
  AdhkarData._();

  static const List> morningEvening = [
    {
      'text': 'أصبحنا وأصبح الملك لله والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
      'target': 1,
      'reference': 'صحيح مسلم',
    },
    {
      'text': 'اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور.',
      'target': 1,
      'reference': 'سنن أبي داود',
    },
    {
      'text': 'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت.',
      'target': 1,
      'reference': 'صحيح البخاري',
    },
    {
      'text': 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم.',
      'target': 3,
      'reference': 'سنن أبي داود والترمذي',
    },
    {
      'text': 'سبحان الله وبحمده.',
      'target': 100,
      'reference': 'صحيح مسلم',
    },
    {
      'text': 'أستغفر الله وأتوب إليه.',
      'target': 100,
      'reference': 'صحيح البخاري ومسلم',
    },
  ];

  static const List> sleep = [
    {
      'text': 'باسمك اللهم أموت وأحيا.',
      'target': 1,
      'reference': 'صحيح البخاري',
    },
    {
      'text': 'اللهم قني عذابك يوم تبعث عبادك.',
      'target': 3,
      'reference': 'سنن أبي داود والترمذي',
    },
    {
      'text': 'سبحان الله والحمد لله والله أكبر.',
      'target': 33,
      'reference': 'صحيح البخاري ومسلم',
    },
  ];

  static const List> wakeUp = [
    {
      'text': 'الحمد لله الذي أحيانا بعدما أماتنا وإليه النشور.',
      'target': 1,
      'reference': 'صحيح البخاري',
    },
    {
      'text': 'الحمد لله الذي عافاني في جسدي ورد علي روحي وأذن لي بذكره.',
      'target': 1,
      'reference': 'سنن الترمذي',
    },
  ];

  static const List> afterPrayer = [
    {
      'text': 'أستغفر الله (ثلاثاً)، اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',
      'target': 1,
      'reference': 'صحيح مسلم',
    },
    {
      'text': 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير، اللهم لا مانع لما أعطيت ولا معطي لما منعت.',
      'target': 1,
      'reference': 'صحيح البخاري ومسلم',
    },
  ];

  static const List> misc = [
    {
      'text': 'لا حول ولا قوة إلا بالله.',
      'target': 100,
      'reference': 'صحيح البخاري',
    },
    {
      'text': 'سبحان الله وبحمده، سبحان الله العظيم.',
      'target': 100,
      'reference': 'صحيح البخاري ومسلم',
    },
  ];

  static List> getByCategory(String categoryTitle) {
    if (categoryTitle.contains('الصباح') || categoryTitle.contains('المساء')) {
      return morningEvening;
    }
    if (categoryTitle.contains('النوم')) {
      return sleep;
    }
    if (categoryTitle.contains('الاستيقاظ')) {
      return wakeUp;
    }
    if (categoryTitle.contains('بعد الصلاة')) {
      return afterPrayer;
    }
    return misc;
  }
}
