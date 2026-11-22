import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة الصوتيات — قائمة القراء وتشغيل السور
class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  String _searchQuery = '';
  bool _onlyFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteIds = {};

  static const List> _reciters = [
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

  static const List<String> _surahNames = [
    'الفاتحة','البقرة','آل عمران','النساء','المائدة','الأنعام','الأعراف','الأنفال','التوبة','يونس',
    'هود','يوسف','الرعد','إبراهيم','الحجر','النحل','الإسراء','الكهف','مريم','طه',
    'الأنبياء','الحج','المؤمنون','النور','الفرقان','الشعراء','النمل','القصص','العنكبوت','الروم',
    'لقمان','السجدة','الأحزاب','سبأ','فاطر','يس','الصافات','ص','الزمر','غافر',
    'فصلت','الشورى','الزخرف','الدخان','الجاثية','الأحقاف','محمد','الفتح','الحجرات','ق',
    'الذاريات','الطور','النجم','القمر','الرحمن','الواقعة','الحديد','المجادلة','الحشر','الممتحنة',
    'الصف','الجمعة','المنافقون','التغابن','الطلاق','التحريم','الملك','القلم','الحاقة','المعارج',
    'نوح','الجن','المزمل','المدثر','القيامة','الإنسان','المرسلات','النبأ','النازعات','عبس',
    'التكوير','الانفطار','المطففين','الانشقاق','البروج','الطارق','الأعلى','الغاشية','الفجر','البلد',
    'الشمس','الليل','الضحى','الشرح','التين','العلق','القدر','البينة','الزلزلة','العاديات',
    'القارعة','التكاثر','العصر','الهمزة','الفيل','قريش','الماعون','الكوثر','الكافرون','النصر',
    'المسد','الإخلاص','الفلق','الناس',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds.addAll(prefs.getStringList('favorite_reciters') ?? []);
    });
  }

  Future<void> _toggleFav(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    await prefs.setStringList('favorite_reciters', _favoriteIds.toList());
  }

  void _openReciterPlayer(Map<String, String> reciter) {
    final player = AudioPlayer();
    int? playingSurah;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.82,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reciter['name']!,
                          style: AppTextStyles.title.copyWith(fontSize: 17),
                        ),
                      ),
                      if (playingSurah != null)
                        IconButton(
                          icon: const Icon(
                            Icons.stop_circle_rounded,
                            color: AppColors.error,
                          ),
                          onPressed: () async {
                            await player.stop();
                            setSheetState(() => playingSurah = null);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _surahNames.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final num = index + 1;
                        final isPlaying = playingSurah == num;
                        final code = num.toString().padLeft(3, '0');
                        final url =
                            'https://everyayah.com/data/${reciter['id']}/${code}001.mp3';
                        return ListTile(
                          tileColor:
                              isPlaying ? AppColors.skyLight : AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: AppColors.divider),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.skyLight,
                            child: Text(
                              '$num',
                              style: const TextStyle(color: AppColors.skyDark),
                            ),
                          ),
                          title: Text(
                            'سورة ${_surahNames[index]}',
                            style: AppTextStyles.title.copyWith(fontSize: 14),
                          ),
                          trailing: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            color: AppColors.skyDark,
                          ),
                          onTap: () async {
                            try {
                              if (isPlaying) {
                                await player.pause();
                                setSheetState(() => playingSurah = null);
                              } else {
                                await player.stop();
                                await player.setUrl(url);
                                setSheetState(() => playingSurah = num);
                                await player.play();
                              }
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تعذر تشغيل التلاوة حالياً'),
                                  ),
                                );
                              }
                            }
                          },
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
    ).whenComplete(() => player.dispose());
  }

  List> get _filteredReciters {
    return _reciters.where((r) {
      final qOk = _searchQuery.isEmpty || r['name']!.contains(_searchQuery);
      final fOk = !_onlyFavorites || _favoriteIds.contains(r['id']!);
      return qOk && fOk;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredReciters;
    return IslamicPatternBackground(
      child: SafeArea(
        child: Column(
          children: [
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
                    child: const Icon(
                      Icons.headphones_rounded,
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
                          'الصوتيات',
                          style: AppTextStyles.headline.copyWith(fontSize: 22),
                        ),
                        const Text(
                          'اختر القارئ المفضل لديك',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => _onlyFavorites = !_onlyFavorites),
                    icon: Icon(
                      _onlyFavorites
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _onlyFavorites
                          ? AppColors.warning
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.skyDark,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) =>
                            setState(() => _searchQuery = val.trim()),
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        decoration: const InputDecoration(
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
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final reciter = list[index];
                  final id = reciter['id']!;
                  return _ReciterCard(
                    name: reciter['name']!,
                    index: index + 1,
                    isFav: _favoriteIds.contains(id),
                    onToggleFav: () => _toggleFav(id),
                    onTap: () => _openReciterPlayer(reciter),
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

class _ReciterCard extends StatefulWidget {
  final String name;
  final int index;
  final bool isFav;
  final VoidCallback onToggleFav;
  final VoidCallback onTap;

  const _ReciterCard({
    required this.name,
    required this.index,
    required this.isFav,
    required this.onToggleFav,
    required this.onTap,
  });

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
      onTap: widget.onTap,
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.skyLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.skyDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.name,
                style: AppTextStyles.title.copyWith(fontSize: 15),
              ),
            ),
            IconButton(
              onPressed: widget.onToggleFav,
              icon: Icon(
                widget.isFav ? Icons.star_rounded : Icons.star_border_rounded,
                color: widget.isFav ? AppColors.warning : AppColors.textSecondary,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
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
  }
}
