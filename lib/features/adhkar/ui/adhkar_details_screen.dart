import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import 'adhkar_screen.dart';

class AdhkarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  const AdhkarDetailsScreen({super.key, required this.category});

  @override
  State<AdhkarDetailsScreen> createState() => _AdhkarDetailsScreenState();
}

class _AdhkarDetailsScreenState extends State<AdhkarDetailsScreen> {
  late List> _adhkarList;

  @override
  void initState() {
    super.initState();
    _adhkarList = AdhkarData.getByCategory(widget.category['title'] as String)
        .map((e) => {...e, 'count': 0})
        .toList();
  }

  void _incrementCount(int index) {
    final current = _adhkarList[index]['count'] as int;
    final target = _adhkarList[index]['target'] as int;
    if (current < target) {
      HapticFeedback.lightImpact();
      setState(() {
        _adhkarList[index]['count'] = current + 1;
      });
      if (current + 1 == target) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _resetAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (int i = 0; i < _adhkarList.length; i++) {
        _adhkarList[i]['count'] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_forward_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.category['title'] as String,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title.copyWith(fontSize: 20),
                      ),
                    ),
                    _CircleButton(
                      icon: Icons.refresh_rounded,
                      onTap: _resetAll,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _adhkarList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _DhikrCard(
                      dhikr: _adhkarList[index],
                      onTap: () => _incrementCount(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  final Map<String, dynamic> dhikr;
  final VoidCallback onTap;

  const _DhikrCard({required this.dhikr, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = dhikr['count'] as int;
    final target = dhikr['target'] as int;
    final isCompleted = count >= target;
    final text = dhikr['text'] as String;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.skyLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted ? AppColors.success : AppColors.divider,
            width: isCompleted ? 1.5 : 1,
          ),
          boxShadow: isCompleted
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              text,
              style: AppTextStyles.quranAyahSmall.copyWith(
                fontSize: 18,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            if (dhikr['reference'] != null)
              Text(
                'المرجع: ${dhikr['reference']}',
                style: AppTextStyles.tiny.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.success : AppColors.skyPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count / $target',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 28,
                  )
                else ...[
                  _buildIconButton(Icons.copy, () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم النسخ')),
                    );
                  }),
                  _buildIconButton(Icons.share, () {
                    Share.share(text);
                  }),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.textSecondary, size: 20),
      constraints: const BoxConstraints(),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.skyDark, size: 22),
      ),
    );
  }
}
