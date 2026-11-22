import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';
import '../data/adhkar_data.dart';
import '../models/dhikr_model.dart';

class AdhkarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  const AdhkarDetailsScreen({super.key, required this.category});

  @override
  State<AdhkarDetailsScreen> createState() => _AdhkarDetailsScreenState();
}

class _AdhkarDetailsScreenState extends State<AdhkarDetailsScreen> {
  late final List<DhikrModel> _adhkarList;
  final Map<int, int> _counters = {};

  @override
  void initState() {
    super.initState();
    final String categoryTitle = (widget.category['title'] ?? '').toString();
    _adhkarList = AdhkarData.adhkarList
        .where((item) => item.category == categoryTitle)
        .toList();
    if (_adhkarList.isEmpty) {
      _adhkarList.addAll(AdhkarData.adhkarList);
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
        title: Text(title, style: AppTextStyles.screenTitle),
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
            final int count = _counters[index] ?? 0;
            final int target = dhikr.count > 0 ? dhikr.count : 1;
            final bool isCompleted = count >= target;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.skyPrimary
                      : AppColors.skyLight,
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
                    dhikr.text,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 17,
                      height: 1.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (dhikr.reference.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      dhikr.reference,
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
