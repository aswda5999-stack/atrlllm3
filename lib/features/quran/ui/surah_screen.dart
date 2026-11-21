import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// صفحة عرض السورة باستخدام حزمة qcf_quran_plus
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyah;
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  /// تحميل الآيات المفضلة من الذاكرة
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_ayahs') ?? [];
    setState(() => _favorites.addAll(saved));
  }

  /// إضافة/إزالة الآية من المفضلة
  Future<void> _toggleFavorite(int surah, int ayah) async {
    final key = '$surah:$ayah';
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(key)) {
        _favorites.remove(key);
      } else {
        _favorites.add(key);
      }
    });
    await prefs.setStringList('favorite_ayahs', _favorites.toList());
  }

  /// تشغيل تلاوة الآية
  Future<void> _playAudio(int surah, int ayah) async {
    if (_playingAyah == ayah) {
      await _audioPlayer.stop();
      setState(() => _playingAyah = null);
      return;
    }
    setState(() => _playingAyah = ayah);
    final url = 'https://everyayah.com/data/Alafasy_128kbps/${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
    
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && mounted) {
          setState(() => _playingAyah = null);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _playingAyah = null);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التشغيل: $e')));
      }
    }
  }

  /// عرض التفسير في نافذة سفلية
  void _showTafsir(int surah, int ayah, String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تفسير الآية $ayah', style: AppTextStyles.title),
            const SizedBox(height: 12),
            Text('سيتم جلب التفسير الموثوق هنا (مثال: التفسير الميسر).', style: AppTextStyles.body),
            const SizedBox(height: 20),
            Text(text, style: AppTextStyles.quranAyah.copyWith(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName, style: AppTextStyles.quranSurahName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: QuranSurahListView(
        surahNumber: widget.surahId,
        ayahBuilder: (context, surahNumber, verseNumber, pageNumber, ayahWidget, isHighlighted, highlightColor) {
          final isFav = _favorites.contains('$surahNumber:$verseNumber');
          final isPlaying = _playingAyah == verseNumber;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // تلوين الآية بشكل احترافي عند التلاوة أو التحديد
              color: isPlaying 
                  ? highlightColor.withOpacity(0.2) 
                  : (isHighlighted ? highlightColor.withOpacity(0.1) : AppColors.surface),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPlaying ? AppColors.skyPrimary : AppColors.divider,
                width: isPlaying ? 2 : 1,
              ),
              boxShadow: isPlaying ? [] : [BoxShadow(color: AppColors.skyPrimary.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // نص الآية
                ayahWidget,
                const SizedBox(height: 12),
                // شريط الأدوات السفلي
                Row(
                  children: [
                    _buildIconButton(
                      icon: isPlaying ? Icons.stop_circle : Icons.play_circle,
                      color: isPlaying ? AppColors.error : AppColors.skyDark,
                      onTap: () => _playAudio(surahNumber, verseNumber),
                    ),
                    _buildIconButton(
                      icon: Icons.menu_book,
                      color: AppColors.skyDark,
                      onTap: () => _showTafsir(surahNumber, verseNumber, 'نص الآية: $verseNumber'),
                    ),
                    _buildIconButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : AppColors.textSecondary,
                      onTap: () => _toggleFavorite(surahNumber, verseNumber),
                    ),
                    const Spacer(),
                    _buildIconButton(
                      icon: Icons.share,
                      color: AppColors.textSecondary,
                      onTap: () => Share.share('سورة ${widget.surahName} - الآية $verseNumber'),
                    ),
                    _buildIconButton(
                      icon: Icons.copy,
                      color: AppColors.textSecondary,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: 'سورة ${widget.surahName} - الآية $verseNumber'));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النسخ')));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// بناء أيقونة تفاعلية صغيرة
  Widget _buildIconButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 22),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(),
    );
  }
}
