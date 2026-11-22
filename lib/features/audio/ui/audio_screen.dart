import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

class AudioScreen extends StatefulWidget {
  AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedReciter;

  final List> _reciters = >[
    <String, String>{
      'name': 'مشاري راشد العفاسي',
      'riwaya': 'حفص عن عاصم',
    },
    <String, String>{
      'name': 'ماهر المعيقلي',
      'riwaya': 'حفص عن عاصم',
    },
    <String, String>{
      'name': 'عبد الباسط عبد الصمد',
      'riwaya': 'المجود والمرتل',
    },
    <String, String>{
      'name': 'سعد الغامدي',
      'riwaya': 'حفص عن عاصم',
    },
    <String, String>{
      'name': 'ياسر الدوسري',
      'riwaya': 'حفص عن عاصم',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List> get _filteredReciters {
    final String trimmed = _query.trim();
    if (trimmed.isEmpty) {
      return _reciters;
    }
    return _reciters
        .where(
          (Map<String, String> item) =>
              (item['name'] ?? '').contains(trimmed) ||
              (item['riwaya'] ?? '').contains(trimmed),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List> list = _filteredReciters;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التلاوات الصوتية',
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (String value) {
                  setState(() {
                    _query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن قارئ أو رواية...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, String> reciter = list[index];
                  final String name = reciter['name'] ?? '';
                  final String riwaya = reciter['riwaya'] ?? '';
                  final bool isPlaying = _selectedReciter == name;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.skyLight,
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.skyDark,
                        ),
                      ),
                      title: Text(
                        name,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        riwaya,
                        style: AppTextStyles.caption,
                      ),
                      trailing: Text(
                        isPlaying ? 'محدد' : 'اختيار',
                        style: AppTextStyles.caption.copyWith(
                          color: isPlaying
                              ? AppColors.skyDark
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedReciter = isPlaying ? null : name;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
