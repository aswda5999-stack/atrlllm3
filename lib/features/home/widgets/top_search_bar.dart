import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../quran/ui/quran_page_screen.dart';

/// شريط البحث العلوي + زر الإعدادات
class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  static const Map<String, int> _quickSurahs = {
    'الفاتحة': 1,
    'البقرة': 2,
    'آل عمران': 3,
    'الكهف': 18,
    'يس': 36,
    'الرحمن': 55,
    'الواقعة': 56,
    'الملك': 67,
  };

  void _openSearchDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        String q = '';
        return StatefulBuilder(
          builder: (ctx, setDlg) {
            final filtered = _quickSurahs.entries
                .where((e) => q.isEmpty || e.key.contains(q))
                .toList();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('بحث سريع في السور', style: AppTextStyles.title),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: ctrl,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'اكتب اسم السورة...',
                      ),
                      onChanged: (v) => setDlg(() => q = v.trim()),
                    ),
                    const SizedBox(height: 12),
                    ...filtered.map(
                      (e) => ListTile(
                        dense: true,
                        title: Text('سورة ${e.key}'),
                        trailing: Text('صفحة ${e.value}'),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  QuranPageScreen(initialPage: e.value),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openQuickSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (ctx, snap) {
                final prefs = snap.data;
                final haptic = prefs?.getBool('tasbih_haptic') ?? true;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('الإعدادات السريعة', style: AppTextStyles.title),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeTrackColor: AppColors.skyDark,
                        title: const Text('الاهتزاز اللمسي في المسبحة'),
                        value: haptic,
                        onChanged: (v) async {
                          await prefs?.setBool('tasbih_haptic', v);
                          setSheet(() {});
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.share_rounded,
                          color: AppColors.skyDark,
                        ),
                        title: const Text('مشاركة التطبيق'),
                        onTap: () {
                          Navigator.pop(ctx);
                          Share.share(
                            'تطبيق أثر مسلم — تطبيق إسلامي شامل للقرآن الكريم والأذكار.',
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _openSearchDialog(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.skyDark,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: IgnorePointer(
                      child: TextField(
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'ابحث في القرآن، الأذكار، الأدعية...',
                          hintStyle: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _SettingsButton(
          onTap: () => _openQuickSettings(context),
        ),
      ],
    );
  }
}

class _SettingsButton extends StatefulWidget {
  final VoidCallback onTap;

  const _SettingsButton({required this.onTap});

  @override
  State<_SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<_SettingsButton> {
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
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _pressed ? AppColors.skyPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? AppColors.skyPrimary : AppColors.divider,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.skyPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Icon(
          Icons.settings_rounded,
          color: _pressed ? Colors.white : AppColors.skyDark,
          size: 24,
        ),
      ),
    );
  }
}
