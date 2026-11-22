import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// شاشة تلاوات السور لصوت القارئ المختار مع مشغل صوتي متكامل (تشغيل/إيقاف مؤقت، السورة التالية/السابقة، شريط تقدم)
class ReciterSurahsScreen extends StatefulWidget {
  final String reciterName;
  final String reciterId;

  const ReciterSurahsScreen({
    super.key,
    required this.reciterName,
    required this.reciterId,
  });

  @override
  State<ReciterSurahsScreen> createState() => _ReciterSurahsScreenState();
}

class _ReciterSurahsScreenState extends State<ReciterSurahsScreen> {
  final AudioPlayer _player = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int? _activeSurahId;
  String? _activeSurahName;
  bool _isLoadingAudio = false;
  String? _errorText;

  static const List<Map<String, dynamic>> _surahs = [
    {'id': 1, 'name': 'الفاتحة', 'verses': 7},
    {'id': 2, 'name': 'البقرة', 'verses': 286},
    {'id': 3, 'name': 'آل عمران', 'verses': 200},
    {'id': 4, 'name': 'النساء', 'verses': 176},
    {'id': 5, 'name': 'المائدة', 'verses': 120},
    {'id': 6, 'name': 'الأنعام', 'verses': 165},
    {'id': 7, 'name': 'الأعراف', 'verses': 206},
    {'id': 8, 'name': 'الأنفال', 'verses': 75},
    {'id': 9, 'name': 'التوبة', 'verses': 129},
    {'id': 10, 'name': 'يونس', 'verses': 109},
    {'id': 11, 'name': 'هود', 'verses': 123},
    {'id': 12, 'name': 'يوسف', 'verses': 111},
    {'id': 13, 'name': 'الرعد', 'verses': 43},
    {'id': 14, 'name': 'إبراهيم', 'verses': 52},
    {'id': 15, 'name': 'الحجر', 'verses': 99},
    {'id': 16, 'name': 'النحل', 'verses': 128},
    {'id': 17, 'name': 'الإسراء', 'verses': 111},
    {'id': 18, 'name': 'الكهف', 'verses': 110},
    {'id': 19, 'name': 'مريم', 'verses': 98},
    {'id': 20, 'name': 'طه', 'verses': 135},
    {'id': 21, 'name': 'الأنبياء', 'verses': 112},
    {'id': 22, 'name': 'الحج', 'verses': 78},
    {'id': 23, 'name': 'المؤمنون', 'verses': 118},
    {'id': 24, 'name': 'النور', 'verses': 64},
    {'id': 25, 'name': 'الفرقان', 'verses': 77},
    {'id': 26, 'name': 'الشعراء', 'verses': 227},
    {'id': 27, 'name': 'النمل', 'verses': 93},
    {'id': 28, 'name': 'القصص', 'verses': 88},
    {'id': 29, 'name': 'العنكبوت', 'verses': 69},
    {'id': 30, 'name': 'الروم', 'verses': 60},
    {'id': 31, 'name': 'لقمان', 'verses': 34},
    {'id': 32, 'name': 'السجدة', 'verses': 30},
    {'id': 33, 'name': 'الأحزاب', 'verses': 73},
    {'id': 34, 'name': 'سبأ', 'verses': 54},
    {'id': 35, 'name': 'فاطر', 'verses': 45},
    {'id': 36, 'name': 'يس', 'verses': 83},
    {'id': 37, 'name': 'الصافات', 'verses': 182},
    {'id': 38, 'name': 'ص', 'verses': 88},
    {'id': 39, 'name': 'الزمر', 'verses': 75},
    {'id': 40, 'name': 'غافر', 'verses': 85},
    {'id': 41, 'name': 'فصلت', 'verses': 54},
    {'id': 42, 'name': 'الشورى', 'verses': 53},
    {'id': 43, 'name': 'الزخرف', 'verses': 89},
    {'id': 44, 'name': 'الدخان', 'verses': 59},
    {'id': 45, 'name': 'الجاثية', 'verses': 37},
    {'id': 46, 'name': 'الأحقاف', 'verses': 35},
    {'id': 47, 'name': 'محمد', 'verses': 38},
    {'id': 48, 'name': 'الفتح', 'verses': 29},
    {'id': 49, 'name': 'الحجرات', 'verses': 18},
    {'id': 50, 'name': 'ق', 'verses': 45},
    {'id': 51, 'name': 'الذاريات', 'verses': 60},
    {'id': 52, 'name': 'الطور', 'verses': 49},
    {'id': 53, 'name': 'النجم', 'verses': 62},
    {'id': 54, 'name': 'القمر', 'verses': 55},
    {'id': 55, 'name': 'الرحمن', 'verses': 78},
    {'id': 56, 'name': 'الواقعة', 'verses': 96},
    {'id': 57, 'name': 'الحديد', 'verses': 29},
    {'id': 58, 'name': 'المجادلة', 'verses': 22},
    {'id': 59, 'name': 'الحشر', 'verses': 24},
    {'id': 60, 'name': 'الممتحنة', 'verses': 13},
    {'id': 61, 'name': 'الصف', 'verses': 14},
    {'id': 62, 'name': 'الجمعة', 'verses': 11},
    {'id': 63, 'name': 'المنافقون', 'verses': 11},
    {'id': 64, 'name': 'التغابن', 'verses': 18},
    {'id': 65, 'name': 'الطلاق', 'verses': 12},
    {'id': 66, 'name': 'التحريم', 'verses': 12},
    {'id': 67, 'name': 'الملك', 'verses': 30},
    {'id': 68, 'name': 'القلم', 'verses': 52},
    {'id': 69, 'name': 'الحاقة', 'verses': 52},
    {'id': 70, 'name': 'المعارج', 'verses': 44},
    {'id': 71, 'name': 'نوح', 'verses': 28},
    {'id': 72, 'name': 'الجن', 'verses': 28},
    {'id': 73, 'name': 'المزمل', 'verses': 20},
    {'id': 74, 'name': 'المدثر', 'verses': 56},
    {'id': 75, 'name': 'القيامة', 'verses': 40},
    {'id': 76, 'name': 'الإنسان', 'verses': 31},
    {'id': 77, 'name': 'المرسلات', 'verses': 50},
    {'id': 78, 'name': 'النبأ', 'verses': 40},
    {'id': 79, 'name': 'النازعات', 'verses': 46},
    {'id': 80, 'name': 'عبس', 'verses': 42},
    {'id': 81, 'name': 'التكوير', 'verses': 29},
    {'id': 82, 'name': 'الانفطار', 'verses': 19},
    {'id': 83, 'name': 'المطففين', 'verses': 36},
    {'id': 84, 'name': 'الانشقاق', 'verses': 25},
    {'id': 85, 'name': 'البروج', 'verses': 22},
    {'id': 86, 'name': 'الطارق', 'verses': 17},
    {'id': 87, 'name': 'الأعلى', 'verses': 19},
    {'id': 88, 'name': 'الغاشية', 'verses': 26},
    {'id': 89, 'name': 'الفجر', 'verses': 30},
    {'id': 90, 'name': 'البلد', 'verses': 20},
    {'id': 91, 'name': 'الشمس', 'verses': 15},
    {'id': 92, 'name': 'الليل', 'verses': 21},
    {'id': 93, 'name': 'الضحى', 'verses': 11},
    {'id': 94, 'name': 'الشرح', 'verses': 8},
    {'id': 95, 'name': 'التين', 'verses': 8},
    {'id': 96, 'name': 'العلق', 'verses': 19},
    {'id': 97, 'name': 'القدر', 'verses': 5},
    {'id': 98, 'name': 'البينة', 'verses': 8},
    {'id': 99, 'name': 'الزلزلة', 'verses': 8},
    {'id': 100, 'name': 'العاديات', 'verses': 11},
    {'id': 101, 'name': 'القارعة', 'verses': 11},
    {'id': 102, 'name': 'التكاثر', 'verses': 8},
    {'id': 103, 'name': 'العصر', 'verses': 3},
    {'id': 104, 'name': 'الهمزة', 'verses': 9},
    {'id': 105, 'name': 'الفيل', 'verses': 5},
    {'id': 106, 'name': 'قريش', 'verses': 4},
    {'id': 107, 'name': 'الماعون', 'verses': 7},
    {'id': 108, 'name': 'الكوثر', 'verses': 3},
    {'id': 109, 'name': 'الكافرون', 'verses': 6},
    {'id': 110, 'name': 'النصر', 'verses': 3},
    {'id': 111, 'name': 'المسد', 'verses': 5},
    {'id': 112, 'name': 'الإخلاص', 'verses': 4},
    {'id': 113, 'name': 'الفلق', 'verses': 5},
    {'id': 114, 'name': 'الناس', 'verses': 6},
  ];

  List<Map<String, dynamic>> get _filteredSurahs {
    if (_searchQuery.isEmpty) return _surahs;
    return _surahs.where((s) {
      final name = s['name'].toString();
      final idStr = s['id'].toString();
      return name.contains(_searchQuery) || idStr == _searchQuery;
    }).toList();
  }

  String _surahAudioUrl(int surahId) {
    final code = surahId.toString().padLeft(3, '0');
    return 'https://server8.mp3quran.net/${widget.reciterId}/$code.mp3';
  }

  Future<void> _playSurah(int surahId, String surahName) async {
    setState(() {
      _activeSurahId = surahId;
      _activeSurahName = surahName;
      _isLoadingAudio = true;
      _errorText = null;
    });

    try {
      await _player.stop();
      await _player.setUrl(_surahAudioUrl(surahId));
      setState(() => _isLoadingAudio = false);
      await _player.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
          _errorText = 'تعذر تشغيل السورة لهذا القارئ حالياً';
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_activeSurahId == null) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {});
  }

  void _playAdjacentSurah(int delta) {
    if (_activeSurahId == null) return;
    final nextId = _activeSurahId! + delta;
    if (nextId < 1 || nextId > _surahs.length) return;
    final nextSurah = _surahs[nextId - 1];
    _playSurah(nextSurah['id'] as int, nextSurah['name'] as String);
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '00:00';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.reciterName,
              style: AppTextStyles.title.copyWith(fontSize: 17),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'تلاوات السور الكاملة',
              style: AppTextStyles.tiny,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── شريط البحث عن سورة ──────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                          onChanged: (v) =>
                              setState(() => _searchQuery = v.trim()),
                          style: AppTextStyles.body.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن سورة بالاسم أو الرقم...',
                            hintStyle: AppTextStyles.caption,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    _errorText!,
                    style: AppTextStyles.tiny.copyWith(color: AppColors.error),
                  ),
                ),

              // ── قائمة السور العمودية ────────────────
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: _filteredSurahs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final surah = _filteredSurahs[index];
                    final id = surah['id'] as int;
                    final name = surah['name'] as String;
                    final verses = surah['verses'] as int;
                    final isCurrent = _activeSurahId == id;

                    return GestureDetector(
                      onTap: () => _playSurah(id, name),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.skyLight : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.skyPrimary
                                : AppColors.divider,
                            width: isCurrent ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: isCurrent
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isCurrent ? null : AppColors.skyLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '$id',
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 15,
                                    color: isCurrent
                                        ? Colors.white
                                        : AppColors.skyDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'سورة $name',
                                    style: AppTextStyles.title.copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    '$verses آية',
                                    style: AppTextStyles.tiny,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isCurrent && _player.playing
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: AppColors.skyDark,
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── المشغل السفلي المتكامل ──────────────
              if (_activeSurahId != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.mediumShadow,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سورة $_activeSurahName',
                                  style: AppTextStyles.titleOnDark
                                      .copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.reciterName,
                                  style: AppTextStyles.captionOnDark,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _playAdjacentSurah(-1),
                            icon: const Icon(Icons.skip_previous_rounded,
                                color: Colors.white),
                          ),
                          _isLoadingAudio
                              ? const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : StreamBuilder<PlayerState>(
                                  stream: _player.playerStateStream,
                                  builder: (context, snap) {
                                    final playing = snap.data?.playing ?? false;
                                    return IconButton(
                                      onPressed: _togglePlayPause,
                                      icon: Icon(
                                        playing
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_filled_rounded,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                    );
                                  },
                                ),
                          IconButton(
                            onPressed: () => _playAdjacentSurah(1),
                            icon: const Icon(Icons.skip_next_rounded,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, posSnap) {
                          final pos = posSnap.data ?? Duration.zero;
                          final total = _player.duration ?? Duration.zero;
                          final maxMs = total.inMilliseconds > 0
                              ? total.inMilliseconds.toDouble()
                              : 1.0;
                          final curMs = pos.inMilliseconds
                              .clamp(0, total.inMilliseconds > 0 ? total.inMilliseconds : 0)
                              .toDouble();

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(0.3),
                                  thumbColor: Colors.white,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: maxMs,
                                  value: curMs.clamp(0, maxMs),
                                  onChanged: (val) {
                                    _player.seek(
                                        Duration(milliseconds: val.toInt()));
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(pos),
                                    style: AppTextStyles.captionOnDark
                                        .copyWith(fontSize: 11),
                                  ),
                                  Text(
                                    _formatDuration(total),
                                    style: AppTextStyles.captionOnDark
                                        .copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
