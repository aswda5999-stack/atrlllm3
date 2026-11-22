import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../settings/ui/settings_screen.dart';
import 'global_search_sheet.dart';

/// شريط البحث العلوي + زر الإعدادات
/// يظهر في أعلى الواجهة الرئيسية ويدعم البحث الشامل الفوري
class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  void _openGlobalSearch(BuildContext context, {String query = ''}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GlobalSearchSheet(initialQuery: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── حقل البحث الشامل ────────────────────────
        Expanded(
          child: GestureDetector(
            onTap: () => _openGlobalSearch(context),
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
                  const Icon(Icons.search_rounded,
                      color: AppColors.skyDark, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: IgnorePointer(
                      child: TextField(
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'ابحث في القرآن، الأذكار، الأدعية...',
                          hintStyle: AppTextStyles.caption
                              .copyWith(color: AppColors.textSecondary),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
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

        // ── زر الإعدادات ─────────────────────────────
        _SettingsButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
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
