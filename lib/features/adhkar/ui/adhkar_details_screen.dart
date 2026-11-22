import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

class AdhkarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  const AdhkarDetailsScreen({super.key, required this.category});

  @override
  State<AdhkarDetailsScreen> createState() => _AdhkarDetailsScreenState();
}

class _AdhkarDetailsScreenState extends State<AdhkarDetailsScreen> {
  late final List> _adhkarList;
  final Map<int, int> _counters = {};

  @override
  void initState() {
    super.initState();
    final rawItems = widget.category['items'];
    if (rawItems is List) {
      _adhkarList = rawItems
          .whereType()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      _adhkarList = [
        {
          'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ.',
          'reference': 'متفق عليه',
          'count': 1,
        },
      ];
    }

    for (int i = 0; i < _adhkarList.length; i++) {
      _counters[i] = 0;
    }
  }

  void _incrementCounter(int index, int targetCount) {
    final int current = _counters[index] ?? 0;
    if (current < targetCount) {
      setState(() {
        _counters[index] = current + 1;
      });
    }
  }

  void _resetCounter(int index) {
    setState(() {
      _counters[index] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = (widget.category['title'] ?? 'الأذكار').toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _adhkarList.length,
          itemBuilder: (context, index) {
            final dhikr = _adhkarList[index];
            final String text = (dhikr['text'] ?? '').toString();
            final String reference = (dhikr['reference'] ?? '').toString();
            final int target =
                (dhikr['count'] is int && (dhikr['count'] as int) > 0)
                    ? dhikr['count'] as int
                    : 1;
            final int count = _counters[index] ?? 0;
            final bool isCompleted = count >= target;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCompleted ? AppColors.skyPrimary : AppColors.skyLight,
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyDark.withOpacity(0.05),
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
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 17,
                      height: 1.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (reference.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      reference,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _incrementCounter(index, target),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCompleted
                              ? AppColors.skyDark
                              : AppColors.skyPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.fingerprint, size: 20),
                        label: Text('$count / $target'),
                      ),
                      TextButton.icon(
                        onPressed: () => _resetCounter(index),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('إعادة'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
