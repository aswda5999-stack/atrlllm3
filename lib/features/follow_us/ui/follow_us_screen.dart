import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة "تابعنا"
class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  static const List<Map<String, dynamic>> _socialLinks = [
    {
      'name': 'يوتيوب',
      'subtitle': 'قناتنا على يوتيوب',
      'icon': Icons.play_circle_fill_rounded,
      'color': Color(0xFFFF0000),
    },
    {
      'name': 'تيليجرام',
      'subtitle': 'قناتنا على تيليجرام',
      'icon': Icons.send_rounded,
      'color': Color(0xFF0088CC),
    },
    {
      'name': 'واتساب',
      'subtitle': 'تواصل معنا عبر واتساب',
      'icon': Icons.chat_rounded,
      'color': Color(0xFF25D366),
    },
    {
      'name': 'فيسبوك',
      'subtitle': 'صفحتنا على فيسبوك',
      'icon': Icons.facebook_rounded,
      'color': Color(0xFF1877F2),
    },
    {
      'name': 'انستغرام',
      'subtitle': 'حسابنا على انستغرام',
      'icon': Icons.camera_alt_rounded,
      'color': Color(0xFFE1306C),
    },
    {
      'name': 'الموقع الإلكتروني',
      'subtitle': 'زيارة موقعنا',
      'icon': Icons.language_rounded,
      'color': Color(0xFF0C4A6E),
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
              // ── العنوان ─────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.favorite_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('تابعنا',
                          style: AppTextStyles.headline.copyWith(fontSize: 22)),
                      Text('ابقَ على تواصل معنا',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── بطاقة معلومات التطبيق ────────────────
              _AppInfoCard(),
              const SizedBox(height: 24),

              // ── روابط التواصل ───────────────────────
              Text('حساباتنا الرسمية',
                  style: AppTextStyles.title.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: _socialLinks.length,
                itemBuilder: (context, index) {
                  return _SocialCard(link: _socialLinks[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  بطاقة معلومات التطبيق
// ══════════════════════════════════════════════════════

class _AppInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyDark.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.mosque_rounded,
                color: Colors.white, size: 40),
          ),
          const SizedBox(height: 12),
          Text('أثر مسلم',
              style: AppTextStyles.titleOnDark.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text('الإصدار 1.0.0',
              style: AppTextStyles.captionOnDark.copyWith(fontSize: 12)),
          const SizedBox(height: 12),
          Text(
            'تطبيق إسلامي شامل يجمع القرآن الكريم، الأذكار، الصوتيات، ومواقيت الصلاة في تجربة واحدة أنيقة.',
            textAlign: TextAlign.center,
            style: AppTextStyles.captionOnDark.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  بطاقة رابط تواصل
// ══════════════════════════════════════════════════════

class _SocialCard extends StatefulWidget {
  final Map<String, dynamic> link;

  const _SocialCard({required this.link});

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.link['color'] as Color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: فتح الرابط عبر url_launcher
      },
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.link['icon'] as IconData,
                    color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                widget.link['name'],
                style: AppTextStyles.title.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                widget.link['subtitle'],
                style: AppTextStyles.tiny.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
