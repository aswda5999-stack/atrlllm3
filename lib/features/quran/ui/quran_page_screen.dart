import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';

class QuranPageScreen extends StatefulWidget {
  final int initialPage;

  const QuranPageScreen({super.key, this.initialPage = 1});

  @override
  State<QuranPageScreen> createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  late final PageController _pageController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 1;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAyah(int surahId, int ayahId) async {
    final url = 'https://everyayah.com/data/Alafasy_128kbps/${surahId.toString().padLeft(3, '0')}${ayahId.toString().padLeft(3, '0')}.mp3';
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التشغيل: $e')));
    }
  }

  void _showAyahMenu(BuildContext context, int surahId, int ayahId, String ayahText) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(Icons.menu_book, 'تفسير', () => Navigator.pop(context)),
              const Divider(height: 1),
              _buildMenuItem(Icons.translate, 'ترجمة', () => Navigator.pop(context)),
              const Divider(height: 1),
              _buildMenuItem(Icons.bookmark_border, 'علامة مرجعية', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة العلامة المرجعية')));
              }),
              const Divider(height: 1),
              _buildMenuItem(Icons.play_circle_outline, 'الاستماع للآيات', () {
                Navigator.pop(context);
                _playAyah(surahId, ayahId);
              }),
              const Divider(height: 1),
              _buildMenuItem(Icons.share, 'مشاركة', () {
                Navigator.pop(context);
                Share.share(ayahText);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.skyDark),
      title: Text(title, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu, color: AppColors.skyDark), onPressed: () {}),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الجزء ${(_currentPage / 20).ceil()}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.skyDark), onPressed: () {}),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            QuranPageView(
              pageController: _pageController, // التصحيح: pageController وليس controller
              onPageChanged: (page) async {
                setState(() => _currentPage = page);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('last_read_page', page);
              },
              ayahBuilder: (context, surahNumber, verseNumber, pageNumber, ayahWidget, isHighlighted, highlightColor) {
                return GestureDetector(
                  onLongPress: () {
                    HapticFeedback.mediumImpact();
                    _showAyahMenu(context, surahNumber, verseNumber, 'نص الآية');
                  },
                  child: Container(
                    color: isHighlighted ? highlightColor.withOpacity(0.3) : Colors.transparent,
                    child: ayahWidget,
                  ),
                );
              },
            ),
            if (_showControls)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.visibility, color: Colors.grey), onPressed: () {}),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.skyLight, borderRadius: BorderRadius.circular(15)),
                        child: Text('$_currentPage', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.skyDark)),
                      ),
                      IconButton(icon: const Icon(Icons.bookmark, color: Colors.grey), onPressed: () {}),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
