import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../quran/ui/quran_screen.dart';
import '../../audio/ui/audio_screen.dart';
import '../../adhkar/ui/adhkar_screen.dart'; // تم إضافة هذا الاستيراد
import '../../prayer/ui/prayer_screen.dart';
import '../../hadiths/ui/hadiths_screen.dart';
import '../../duas/ui/duas_screen.dart';
import '../../qibla/ui/qibla_screen.dart';
import '../../tasbih/ui/tasbih_screen.dart';

class GridMenu extends StatelessWidget {
  const GridMenu({super.key});

  static final List<Map<String, dynamic>> _items = [
    {'icon': Icons.menu_book_rounded, 'label': 'القرآن الكريم', 'screen': const QuranScreen()},
    {'icon': Icons.headphones_rounded, 'label': 'الصوتيات', 'screen': const AudioScreen()},
    {'icon': Icons.nights_stay_rounded, 'label': 'الأذكار', 'screen': const AdhkarScreen()},
    {'icon': Icons.mosque_rounded, 'label': 'الصلاة', 'screen': const PrayerScreen()},
    {'icon': Icons.article_rounded, 'label': 'الأحاديث', 'screen': const HadithsScreen()},
    {'icon': Icons.pan_tool_rounded, 'label': 'الدعاء', 'screen': const DuasScreen()},
    {'icon': Icons.explore_rounded, 'label': 'البوصلة', 'screen': const QiblaScreen()},
    {'icon': Icons.circle_outlined, 'label': 'المسبحة', 'screen': const TasbihScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _AnimatedMenuButton(
          icon: _items[index]['icon'] as IconData,
          label: _items[index]['label'] as String,
          screen: _items[index]['screen'] as Widget,
        );
      },
    );
  }
}

class _AnimatedMenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Widget screen;

  const _AnimatedMenuButton({required this.icon, required this.label, required this.screen});

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.screen));
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: _pressed ? AppColors.primaryGradient : const LinearGradient(colors: [Colors.white, Colors.white]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _pressed ? Colors.transparent : AppColors.divider),
            boxShadow: _pressed ? [] : [BoxShadow(color: AppColors.skyPrimary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _pressed ? Colors.white.withOpacity(0.25) : AppColors.skyLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, size: 24, color: _pressed ? Colors.white : AppColors.skyDark),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _pressed ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
