import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة المسبحة الإلكترونية المطوّرة
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _count = 0;
  int _completedCycles = 0;
  int _totalCount = 0;
  int _target = 33;
  bool _hapticEnabled = true;
  String _currentDhikr = 'سُبْحَانَ اللَّهِ';

  final List<String> _adhkarList = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
  ];

  final List<int> _targets = [33, 99, 100, 500];

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDhikr = prefs.getString('tasbih_dhikr') ?? _adhkarList[0];
    final customAdhkar = prefs.getStringList('tasbih_custom_adhkar') ?? [];
    setState(() {
      for (final item in customAdhkar) {
        if (!_adhkarList.contains(item)) {
          _adhkarList.add(item);
        }
      }
      _currentDhikr = _adhkarList.contains(savedDhikr) ? savedDhikr : _adhkarList[0];
      _count = prefs.getInt('tasbih_count') ?? 0;
      _completedCycles = prefs.getInt('tasbih_cycles') ?? 0;
      _totalCount = prefs.getInt('tasbih_total') ?? 0;
      _target = prefs.getInt('tasbih_target') ?? 33;
      _hapticEnabled = prefs.getBool('tasbih_haptic') ?? true;
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_count', _count);
    await prefs.setInt('tasbih_cycles', _completedCycles);
    await prefs.setInt('tasbih_total', _totalCount);
    await prefs.setInt('tasbih_target', _target);
    await prefs.setString('tasbih_dhikr', _currentDhikr);
    await prefs.setBool('tasbih_haptic', _hapticEnabled);
  }

  void _increment() {
    setState(() {
      _count++;
      _totalCount++;
      if (_count >= _target) {
        _completedCycles++;
        _count = 0;
        if (_hapticEnabled) {
          HapticFeedback.heavyImpact();
        }
      } else if (_hapticEnabled) {
        HapticFeedback.lightImpact();
      }
    });
    _saveState();
  }

  void _resetCurrent() {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    setState(() {
      _count = 0;
    });
    _saveState();
  }

  void _resetAllStats() {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    setState(() {
      _count = 0;
      _completedCycles = 0;
      _totalCount = 0;
    });
    _saveState();
  }

  Future<void> _showAddCustomDhikrDialog() async {
    final controller = TextEditingController();
    final added = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إضافة ذكر مخصص', style: AppTextStyles.title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'اكتب نص الذكر أو التسبيح...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );

    if (added != null && added.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final customList = prefs.getStringList('tasbih_custom_adhkar') ?? [];
      if (!customList.contains(added)) {
        customList.add(added);
        await prefs.setStringList('tasbih_custom_adhkar', customList);
      }
      setState(() {
        if (!_adhkarList.contains(added)) {
          _adhkarList.add(added);
        }
        _currentDhikr = added;
        _count = 0;
      });
      _saveState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المسبحة الإلكترونية'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'الاهتزاز اللمسي',
            onPressed: () {
              setState(() => _hapticEnabled = !_hapticEnabled);
              _saveState();
            },
            icon: Icon(
              _hapticEnabled ? Icons.vibration_rounded : Icons.notifications_off_rounded,
              color: _hapticEnabled ? AppColors.skyDark : AppColors.textSecondary,
            ),
          ),
          IconButton(
            tooltip: 'تصفير الكل',
            onPressed: _resetAllStats,
            icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.skyDark),
          ),
        ],
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ── بطاقة إحصائيات الجلسة ───────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatMiniCard(
                        label: 'الدورات المكتملة',
                        value: '$_completedCycles',
                        icon: Icons.autorenew_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatMiniCard(
                        label: 'إجمالي التسبيح',
                        value: '$_totalCount',
                        icon: Icons.format_list_numbered_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── اختيار الذكر + زر إضافة ذكر ─────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentDhikr,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down_rounded,
                                color: AppColors.skyDark),
                            items: _adhkarList.map((dhikr) {
                              return DropdownMenuItem(
                                value: dhikr,
                                child: Text(
                                  dhikr,
                                  style: AppTextStyles.quranAyahSmall
                                      .copyWith(fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _currentDhikr = val;
                                  _count = 0;
                                });
                                _saveState();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showAddCustomDhikrDialog,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── اختيار الهدف ────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _targets.map((t) {
                    final isActive = _target == t;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _target = t;
                          _count = 0;
                        });
                        _saveState();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.skyDark : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isActive ? AppColors.skyDark : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          '$t',
                          style: AppTextStyles.title.copyWith(
                            fontSize: 15,
                            color:
                                isActive ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ── عدسة التسبيح التفاعلية ──────────────
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _increment,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 265,
                          height: 265,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: AppColors.skyLight,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.skyDark),
                          ),
                        ),
                        Container(
                          width: 224,
                          height: 224,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.softGradient,
                            boxShadow: AppColors.mediumShadow,
                            border: Border.all(
                                color: AppColors.surface, width: 4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_count',
                                style: AppTextStyles.display.copyWith(
                                  fontSize: 62,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.skyDark,
                                ),
                              ),
                              Text(
                                'من $_target',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'اضغط للتسبيح',
                                style: AppTextStyles.tiny.copyWith(
                                  color: AppColors.skyMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── زر إعادة تعيين الدورة الحالية ────────
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton.icon(
                  onPressed: _resetCurrent,
                  icon: const Icon(Icons.restart_alt_rounded, size: 20),
                  label: const Text('إعادة تعيين الدورة الحالية'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatMiniCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.skyLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.skyDark, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    color: AppColors.skyDark,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.tiny,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
