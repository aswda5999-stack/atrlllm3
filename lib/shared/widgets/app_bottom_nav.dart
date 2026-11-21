import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// شريط التنقل السفلي المخصص لتطبيق "أثر مسلم"
/// 5 عناصر: الرئيسية، الصوتيات، القرآن، الأذكار، تابعنا
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'الرئيسية'),
    _NavItem(icon: Icons.headphones_rounded, label: 'الصوتيات'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'القرآن'),
    _NavItem(icon: Icons.nights_stay_rounded, label: 'الأذكار'),
    _NavItem(icon: Icons.favorite_rounded, label: 'تابعنا'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.skyDark.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final isActive = index == currentIndex;
              return Expanded(
                child: _NavButton(
                  item: _items[index],
                  isActive: isActive,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: widget.isActive
              ? AppColors.skyLight.withOpacity(_pressed ? 0.6 : 1.0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _pressed ? 0.85 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                widget.item.icon,
                size: 24,
                color: widget.isActive
                    ? AppColors.skyDark
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.item.label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w500,
                color: widget.isActive
                    ? AppColors.skyDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
