import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../data/duas_data.dart';

class DuasDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> category;
  const DuasDetailsScreen({super.key, required this.category});

  @override
  State<DuasDetailsScreen> createState() => _DuasDetailsScreenState();
}

class _DuasDetailsScreenState extends State<DuasDetailsScreen> {
  late List<Map<String, dynamic>> _duasList;

  @override
  void initState() {
    super.initState();
    _duasList = DuasData.getByCategory(widget.category['title'])
        .map((e) => {...e, 'count': 0})
        .toList();
  }

  void _incrementCount(int index) {
    if (_duasList[index]['count'] < _duasList[index]['target']) {
      HapticFeedback.lightImpact();
      setState(() {
        _duasList[index]['count']++;
      });
      if (_duasList[index]['count'] == _duasList[index]['target']) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _resetAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (int i = 0; i < _duasList.length; i++) {
        _duasList[i]['count'] = 0;
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
              // ── الشريط العلوي ──────────────────────
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
                        widget.category['title'],
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

              // ── قائمة الأدعية العمودية ──────────────
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _duasList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _DuaCard(
                      dua: _duasList[index],
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

class _DuaCard extends StatelessWidget {
  final Map<String, dynamic> dua;
  final VoidCallback onTap;

  const _DuaCard({required this.dua, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCompleted = dua['count'] >= dua['target'];

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
              dua['text'],
              style: AppTextStyles.quranAyahSmall.copyWith(fontSize: 18, height: 1.6),
            ),
            const SizedBox(height: 12),
            if (dua['reference'] != null)
              Text(
                'المرجع: ${dua['reference']}',
                style: AppTextStyles.tiny.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.success : AppColors.skyPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dua['count']} / ${dua['target']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 28)
                else ...[
                  _buildIconButton(Icons.copy, () {
                    Clipboard.setData(ClipboardData(text: dua['text']));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم النسخ')),
                    );
                  }),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.share, () {
                    Share.share(dua['text']);
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
      padding: EdgeInsets.zero,
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
