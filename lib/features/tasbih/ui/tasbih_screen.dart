import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة المسبحة الإلكترونية
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _count = 0;
  int _target = 33;
  String _currentDhikr = 'سُبْحَانَ اللَّهِ';

  final List<String> _adhkarList = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
  ];

  final List<int> _targets = [33, 99, 100];

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  /// تحميل العدد المحفوظ
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('tasbih_count') ?? 0;
      _target = prefs.getInt('tasbih_target') ?? 33;
      _currentDhikr = prefs.getString('tasbih_dhikr') ?? _adhkarList[0];
    });
  }

  /// حفظ الحالة
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_count', _count);
    await prefs.setInt('tasbih_target', _target);
    await prefs.setString('tasbih_dhikr', _currentDhikr);
  }

  /// زيادة العداد
  void _increment() {
    HapticFeedback.lightImpact(); // اهتزاز خفيف
    setState(() {
      _count++;
      if (_count > _target) {
        _count = 0; // إعادة التعيين عند الوصول للهدف
        HapticFeedback.heavyImpact(); // اهتزاز أقوى عند الإكمال
      }
    });
    _saveState();
  }

  /// إعادة تعيين العداد
  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() => _count = 0);
    _saveState();
  }

  @override
  Widget build(BuildContext context) {
    // حساب نسبة الإنجاز
    final progress = _count / _target;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المسبحة الإلكترونية'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.skyDark),
          ),
        ],
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── اختيار الذكر ────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    style: AppTextStyles.title.copyWith(fontSize: 16),
                    items: _adhkarList.map((dhikr) {
                      return DropdownMenuItem(
                        value: dhikr,
                        child: Text(dhikr,
                            style: AppTextStyles.quranAyahSmall
                                .copyWith(fontSize: 18)),
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
              const SizedBox(height: 16),

              // ── اختيار الهدف ────────────────────────
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
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
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
              const SizedBox(height: 30),

              // ── العدسة الدائرية الكبيرة ─────────────
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _increment,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // الحلقة الخارجية (تقدم)
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor: AppColors.skyLight,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.skyDark),
                          ),
                        ),
                        // الحلقة الداخلية (العداد)
                        Container(
                          width: 220,
                          height: 220,
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

              // ── زر إعادة التعيين ───────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
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
