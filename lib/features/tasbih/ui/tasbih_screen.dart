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
      _currentDhikr =
          _adhkarList.contains(savedDhikr) ? savedDhikr : _adhkarList[0];
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
        if (_hapticEnabled) HapticFeedback.heavyImpact();
      } else if (_hapticEnabled) {
        HapticFeedback.lightImpact();
      }
    });
    _saveState();
  }

  void _reset() {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    setState(() => _count = 0);
    _saveState();
  }

  void _resetAll() {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    setState(() {
      _count = 0;
      _completedCycles = 0;
      _totalCount = 0;
    });
    _saveState();
  }

  Future<void> _addCustomDhikr() async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إضافة ذكر مخصص', style: AppTextStyles.title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اكتب نص الذكر...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final t = controller.text.trim();
              if (t.isNotEmpty) Navigator.pop(context, t);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
    if (text != null && text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final custom = prefs.getStringList('tasbih_custom_adhkar') ?? [];
      if (!custom.contains(text)) {
        custom.add(text);
        await prefs.setStringList('tasbih_custom_adhkar', custom);
      }
      setState(() {
        if (!_adhkarList.contains(text)) _adhkarList.add(text);
        _currentDhikr = text;
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
            onPressed: () {
              setState(() => _hapticEnabled = !_hapticEnabled);
              _saveState();
            },
            icon: Icon(
              _hapticEnabled
                  ? Icons.vibration_rounded
                  : Icons.notifications_off_rounded,
              color: _hapticEnabled ? AppColors.skyDark : AppColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: _resetAll,
            icon: const Icon(
              Icons.delete_sweep_rounded,
              color: AppColors.skyDark,
            ),
          ),
        ],
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          'الدورات: $_completedCycles',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 14,
                            color: AppColors.skyDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          'الإجمالي: $_totalCount',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 14,
                            color: AppColors.skyDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
                            icon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppColors.skyDark,
                            ),
                            items: _adhkarList.map((dhikr) {
                              return DropdownMenuItem(
                                value: dhikr,
                                child: Text(
                                  dhikr,
                                  style: AppTextStyles.quranAyahSmall.copyWith(
                                    fontSize: 17,
                                  ),
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
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addCustomDhikr,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.skyDark,
                      ),
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
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
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                          color: isActive ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _increment,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: AppColors.skyLight,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.skyDark,
                            ),
                          ),
                        ),
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.softGradient,
                            boxShadow: AppColors.mediumShadow,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 4,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_count',
                                style: AppTextStyles.display.copyWith(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.skyDark,
                                ),
                              ),
                              Text(
                                'من $_target',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt_rounded, size: 20),
                  label: const Text('إعادة التعيين'),
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
