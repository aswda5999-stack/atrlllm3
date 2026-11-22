import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة "تابعنا" المطوّرة مع فتح الروابط ومشاركتها ونسخها
class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  static const List<Map<String, dynamic>> _socialLinks = [
    {
      'name': 'يوتيوب',
      'subtitle': 'قناتنا على يوتيوب',
      'url': 'https://youtube.com',
      'icon': Icons.play_circle_fill_rounded,
      'color': Color(0xFFFF0000),
    },
    {
      'name': 'تيليجرام',
      'subtitle': 'قناتنا على تيليجرام',
      'url': 'https://t.me',
      'icon': Icons.send_rounded,
      'color': Color(0xFF0088CC),
    },
    {
      'name': 'واتساب',
      'subtitle': 'تواصل معنا عبر واتساب',
      'url': 'https://whatsapp.com',
      'icon': Icons.chat_rounded,
      'color': Color(0xFF25D366),
    },
    {
      'name': 'فيسبوك',
      'subtitle': 'صفحتنا على فيسبوك',
      'url': 'https://facebook.com',
      'icon': Icons.facebook_rounded,
      'color': Color(0xFF1877F2),
    },
    {
      'name': 'انستغرام',
      'subtitle': 'حسابنا على انستغرام',
      'url': 'https://instagram.com',
      'icon': Icons.camera_alt_rounded,
      'color': Color(0xFFE1306C),
    },
    {
      'name': 'الموقع الإلكتروني',
      'subtitle': 'زيارة موقعنا الرسمي',
      'url': 'https://example.com',
      'icon': Icons.language_rounded,
      'color': Color(0xFF0C4A6E),
    },
  ];

  Future<void> _openUrl(BuildContext context, String urlStr, String name) async {
    final uri = Uri.parse(urlStr);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        await Clipboard.setData(ClipboardData(text: urlStr));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر فتح $name مباشرة، تم نسخ الرابط')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        await Clipboard.setData(ClipboardData(text: urlStr));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم نسخ رابط $name')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
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
                      child: const Icon(Icons.favorite_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تابعنا',
                            style: AppTextStyles.headline.copyWith(fontSize: 22)),
                        Text('ابقَ على تواصل معنا وشارك الخير',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _AppInfoCard(
                  onShareApp: () {
                    Share.share(
                      'تطبيق أثر مسلم — تطبيق إسلامي شامل يجمع القرآن الكريم، الأذكار، الأدعية، الأحاديث، الصوتيات، والمسبحة الإلكترونية.',
                    );
                  },
                ),
                const SizedBox(height: 24),

                Text('حساباتنا الرسمية',
                    style: AppTextStyles.title.copyWith(fontSize: 18)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _socialLinks.length,
                  itemBuilder: (context, index) {
                    final link = _socialLinks[index];
                    return _SocialCard(
                      link: link,
                      onTap: () => _openUrl(
                        context,
                        link['url'] as String,
                        link['name'] as String,
                      ),
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(text: link['url'] as String),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم نسخ رابط ${link['name']}')),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  final VoidCallback onShareApp;
  const _AppInfoCard({required this.onShareApp});

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
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.mosque_rounded,
                color: Colors.white, size: 38),
          ),
          const SizedBox(height: 12),
          Text('أثر مسلم',
              style: AppTextStyles.titleOnDark.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text('الإصدار 1.0.0',
              style: AppTextStyles.captionOnDark.copyWith(fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            'تطبيق إسلامي شامل يجمع القرآن الكريم، الأذكار، الأدعية، الأحاديث، الصوتيات، ومواقيت الصلاة في تجربة واحدة أنيقة.',
            textAlign: TextAlign.center,
            style: AppTextStyles.captionOnDark.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onShareApp,
            icon: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
            label: const Text(
              'مشاركة التطبيق',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialCard extends StatefulWidget {
  final Map<String, dynamic> link;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SocialCard({
    required this.link,
    required this.onTap,
    required this.onLongPress,
  });

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
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
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
