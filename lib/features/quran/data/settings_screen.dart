import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../../prayer/ui/azan_settings_screen.dart';

/// صفحة الإعدادات الشاملة والمختصرة لتطبيق "أثر مسلم"
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _calcMethod = 'umm_al_qura';
  String _madhab = 'shafi';
  double _quranFontSize = 26.0;
  bool _keepScreenOn = true;
  bool _tasbihHaptic = true;
  bool _isLoading = true;

  static const Map<String, String> _calcMethods = {
    'umm_al_qura': 'أم القرى (مكة المكرمة)',
    'muslim_world_league': 'رابطة العالم الإسلامي',
    'egyptian': 'الهيئة المصرية العامة للمساحة',
    'karachi': 'جامعة العلوم الإسلامية بكراتشي',
    'north_america': 'الجمعية الإسلامية لأمريكا الشمالية',
  };

  static const Map<String, String> _madhabs = {
    'shafi': 'الجمهور (الشافعي، المالكي، الحنبلي)',
    'hanafi': 'الحنفي',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _calcMethod = prefs.getString('prayer_calc_method') ?? 'umm_al_qura';
      _madhab = prefs.getString('prayer_madhab') ?? 'shafi';
      _quranFontSize = prefs.getDouble('quran_font_size') ?? 26.0;
      _keepScreenOn = prefs.getBool('quran_keep_screen_on') ?? true;
      _tasbihHaptic = prefs.getBool('tasbih_haptic') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveBool(String key, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, val);
  }

  Future<void> _saveString(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
  }

  Future<void> _saveDouble(String key, double val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, val);
  }

  Future<void> _resetReadingData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إعادة ضبط القراءة والمفضلة', style: AppTextStyles.title),
        content: const Text(
          'سيتم إعادة آخر صفحة قراءة إلى الصفحة 1 ومسح المفضلة المحفوظة. هل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_read_page', 1);
      await prefs.remove('favorite_ayahs');
      await prefs.remove('favorite_hadiths');
      await prefs.remove('favorite_reciters');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إعادة ضبط بيانات القراءة والمفضلة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.transparent,
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  children: [
                    // ── 1. مواقيت الصلاة والأذان ────────────
                    _SectionHeader(
                      title: 'مواقيت الصلاة والأذان',
                      icon: Icons.mosque_rounded,
                    ),
                    _SettingsCard(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('طريقة الحساب',
                              style: AppTextStyles.title.copyWith(fontSize: 14)),
                          subtitle: Text(
                            _calcMethods[_calcMethod] ?? '',
                            style: AppTextStyles.tiny,
                          ),
                          trailing: DropdownButton<String>(
                            value: _calcMethod,
                            underline: const SizedBox.shrink(),
                            items: _calcMethods.entries
                                .map((e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(
                                        e.value.split(' ').first,
                                        style: AppTextStyles.caption,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _calcMethod = v);
                                _saveString('prayer_calc_method', v);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('المذهب الفقهي للعصر',
                              style: AppTextStyles.title.copyWith(fontSize: 14)),
                          subtitle: Text(
                            _madhab == 'shafi'
                                ? 'الجمهور (الشافعي، المالكي، الحنبلي)'
                                : 'الحنفي',
                            style: AppTextStyles.tiny,
                          ),
                          trailing: DropdownButton<String>(
                            value: _madhab,
                            underline: const SizedBox.shrink(),
                            items: _madhabs.entries
                                .map((e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(
                                        e.key == 'shafi' ? 'الجمهور' : 'الحنفي',
                                        style: AppTextStyles.caption,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _madhab = v);
                                _saveString('prayer_madhab', v);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.volume_up_rounded,
                              color: AppColors.skyDark),
                          title: Text('إعدادات الأذان (7 فتحات)',
                              style: AppTextStyles.title.copyWith(fontSize: 14)),
                          subtitle: const Text(
                            'تعيين وتجربة ملفات الأذان المخصصة',
                            style: AppTextStyles.tiny,
                          ),
                          trailing: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.textSecondary),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AzanSettingsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ── 2. القرآن والتلاوة ───────────────────
                    _SectionHeader(
                      title: 'القرآن والتلاوة',
                      icon: Icons.menu_book_rounded,
                    ),
                    _SettingsCard(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('حجم خط المصحف',
                                style:
                                    AppTextStyles.title.copyWith(fontSize: 14)),
                            Text(
                              '${_quranFontSize.toInt()}',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 15,
                                color: AppColors.skyDark,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          min: 20.0,
                          max: 36.0,
                          divisions: 16,
                          value: _quranFontSize.clamp(20.0, 36.0),
                          activeColor: AppColors.skyDark,
                          onChanged: (val) {
                            setState(() => _quranFontSize = val);
                            _saveDouble('quran_font_size', val);
                          },
                        ),
                        const Divider(),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeTrackColor: AppColors.skyDark,
                          title: Text('إبقاء الشاشة مضاءة أثناء القراءة',
                              style:
                                  AppTextStyles.title.copyWith(fontSize: 14)),
                          value: _keepScreenOn,
                          onChanged: (val) {
                            setState(() => _keepScreenOn = val);
                            _saveBool('quran_keep_screen_on', val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ── 3. المسبحة والتنبيهات اللمسية ───────
                    _SectionHeader(
                      title: 'المسبحة والتنبيهات',
                      icon: Icons.touch_app_rounded,
                    ),
                    _SettingsCard(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeTrackColor: AppColors.skyDark,
                          title: Text('الاهتزاز اللمسي عند التسبيح',
                              style:
                                  AppTextStyles.title.copyWith(fontSize: 14)),
                          subtitle: const Text(
                            'اهتزاز خفيف عند العد وقوي عند إكمال الدورة',
                            style: AppTextStyles.tiny,
                          ),
                          value: _tasbihHaptic,
                          onChanged: (val) {
                            setState(() => _tasbihHaptic = val);
                            _saveBool('tasbih_haptic', val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ── 4. البيانات والتطبيق ────────────────
                    _SectionHeader(
                      title: 'البيانات والتطبيق',
                      icon: Icons.settings_suggest_rounded,
                    ),
                    _SettingsCard(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.share_rounded,
                              color: AppColors.skyDark),
                          title: Text('مشاركة تطبيق أثر مسلم',
                              style:
                                  AppTextStyles.title.copyWith(fontSize: 14)),
                          onTap: () => Share.share(
                            'تطبيق أثر مسلم — تطبيق إسلامي شامل للقرآن الكريم، الأذكار، الأدعية، الأحاديث، الصوتيات، والمسبحة.',
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.restore_rounded,
                              color: AppColors.error),
                          title: Text('إعادة ضبط القراءة والمفضلة',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 14,
                                color: AppColors.error,
                              )),
                          onTap: _resetReadingData,
                        ),
                        const Divider(),
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('الإصدار'),
                          trailing: Text('1.0.0', style: AppTextStyles.caption),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.skyDark),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.title.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: children),
    );
  }
}
