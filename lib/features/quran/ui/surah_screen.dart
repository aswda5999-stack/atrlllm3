import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../data/quran_audio_service.dart';

/// صفحة عرض آيات السورة
class SurahScreen extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SurahScreen({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final QuranAudioService _audioService = QuranAudioService();
  int? _playingAyah;

  // ── بيانات تجريبية للآيات (سيتم استبدالها ببيانات حقيقية) ──
  final List<Map<String, dynamic>> _ayahs = [
    {
      'id': 1,
      'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'number': 1,
    },
    {
      'id': 2,
      'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'number': 2,
    },
    {
      'id': 3,
      'text': 'الرَّحْمَٰنِ الرَّحِيمِ',
      'number': 3,
    },
    {
      'id': 4,
      'text': 'مَالِكِ يَوْمِ الدِّينِ',
      'number': 4,
    },
    {
      'id': 5,
      'text': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'number': 5,
    },
    {
      'id': 6,
      'text': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
      'number': 6,
    },
    {
      'id': 7,
      'text': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
      'number': 7,
    },
  ];

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  /// تشغيل تلاوة الآية
  Future<void> _playAyah(int ayahNumber) async {
    if (_playingAyah == ayahNumber) {
      // إيقاف التشغيل إذا ضغط على نفس الآية
      await _audioService.stop();
      setState(() => _playingAyah = null);
      return;
    }

    setState(() => _playingAyah = ayahNumber);
    try {
      await _audioService.playAyah(
        surahId: widget.surahId,
        ayahNumber: ayahNumber,
        onComplete: () {
          if (mounted) setState(() => _playingAyah = null);
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _playingAyah = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تشغيل الصوت: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── شريط العنوان العلوي ─────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_forward_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.surahName,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.quranSurahName.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _CircleButton(
                      icon: Icons.bookmark_border_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ── اسم السورة الزخرفي ──────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'سورة ${widget.surahName}',
                    style: AppTextStyles.titleOnDark.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── قائمة الآيات ───────────────────────
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = _ayahs[index];
                    final isPlaying = _playingAyah == ayah['number'];

                    return _AyahCard(
                      text: ayah['text'],
                      number: ayah['number'],
                      isPlaying: isPlaying,
                      onTap: () => _playAyah(ayah['number']),
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

// ══════════════════════════════════════════════════════
//  بطاقة الآية
// ══════════════════════════════════════════════════════

class _AyahCard extends StatefulWidget {
  final String text;
  final int number;
  final bool isPlaying;
  final VoidCallback onTap;

  const _AyahCard({
    required this.text,
    required this.number,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  State<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<_AyahCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isPlaying
              ? AppColors.skyLight
              : (_pressed ? AppColors.skySoft : AppColors.surface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isPlaying
                ? AppColors.skyPrimary
                : AppColors.divider,
            width: widget.isPlaying ? 1.5 : 1,
          ),
          boxShadow: _pressed || widget.isPlaying
              ? []
              : [
                  BoxShadow(
                    color: AppColors.skyPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── النص القرآني + رقم الآية ──────────
            RichText(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.text,
                    style: AppTextStyles.quranAyah,
                  ),
                  TextSpan(
                    text: ' ﴿${widget.number}﴾',
                    style: AppTextStyles.quranAyah.copyWith(
                      color: AppColors.skyDark,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── شريط الأدوات السفلي (تشغيل/نسخ/حفظ) ──
            Row(
              children: [
                _ActionChip(
                  icon: widget.isPlaying
                      ? Icons.stop_circle_rounded
                      : Icons.play_circle_fill_rounded,
                  label: widget.isPlaying ? 'إيقاف' : 'تشغيل',
                  color: widget.isPlaying
                      ? AppColors.skyDark
                      : AppColors.skyPrimary,
                  onTap: widget.onTap,
                ),
                const SizedBox(width: 8),
                _ActionChip(
                  icon: Icons.copy_rounded,
                  label: 'نسخ',
                  color: AppColors.textSecondary,
                  onTap: () {
                    // TODO: نسخ النص
                  },
                ),
                const Spacer(),
                Text(
                  'الآية ${widget.number}',
                  style: AppTextStyles.tiny,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  عناصر مساعدة
// ══════════════════════════════════════════════════════

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.skyDark, size: 22),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
