import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// شبكة الأزرار الرئيسية (8 أزرار)
class GridMenu extends StatelessWidget {
  const GridMenu({super.key});

  static const List<_MenuItem> _items = [
    _MenuItem(icon: Icons.menu_book_rounded, label: 'القرآن الكريم'),
    _MenuItem(icon: Icons.headphones_rounded, label: 'الصوتيات'),
    _MenuItem(icon: Icons.nights_stay_rounded, label: 'الأذكار'),
    _MenuItem(icon: Icons.mosque_rounded, label: 'الصلاة'),
    _MenuItem(icon: Icons.article_rounded, label: 'الأحاديث'),
    _MenuItem(icon: Icons.pan_tool_rounded, label: 'الدعاء'),
    _MenuItem(icon: Icons.explore_rounded, label: 'البوصلة'),
    _MenuItem(icon: Icons.circle_outlined, label: 'المسبحة'),
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
        return _AnimatedMenuButton(item: _items[index]);
      },
    );
  }
}

// ══════════════════════════════════════════════════════
//  نموذج بيانات عنصر القائمة
// ══════════════════════════════════════════════════════

class _MenuItem {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});
}

// ══════════════════════════════════════════════════════
//  زر تفاعلي متحرك
// ══════════════════════════════════════════════════════

class _AnimatedMenuButton extends StatefulWidget {
  final _MenuItem item;

  const _AnimatedMenuButton({required this.item});

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
        // TODO: التنقل إلى الشاشة المقابلة
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: _pressed
                ? AppColors.primaryGradient
                : const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed ? Colors.transparent : AppColors.divider,
            ),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: AppColors.skyPrimary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── الأيقونة ────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _pressed
                      ? Colors.white.withOpacity(0.25)
                      : AppColors.skyLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.item.icon,
                  size: 24,
                  color: _pressed ? Colors.white : AppColors.skyDark,
                ),
              ),
              const SizedBox(height: 8),

              // ── التسمية ─────────────────────────
              Text(
                widget.item.label,
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
