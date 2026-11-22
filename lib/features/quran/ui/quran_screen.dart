import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

class QuranScreen extends StatefulWidget {
  QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List> _surahs = >[
    <String, String>{'number': '1', 'name': 'الفاتحة', 'type': 'مكية'},
    <String, String>{'number': '2', 'name': 'البقرة', 'type': 'مدنية'},
    <String, String>{'number': '3', 'name': 'آل عمران', 'type': 'مدنية'},
    <String, String>{'number': '18', 'name': 'الكهف', 'type': 'مكية'},
    <String, String>{'number': '36', 'name': 'يس', 'type': 'مكية'},
    <String, String>{'number': '67', 'name': 'الملك', 'type': 'مكية'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List> get _filteredSurahs {
    final String trimmed = _query.trim();
    if (trimmed.isEmpty) {
      return _surahs;
    }
    return _surahs
        .where(
          (Map<String, String> surah) =>
              (surah['name'] ?? '').contains(trimmed) ||
              (surah['number'] ?? '').contains(trimmed) ||
              (surah['type'] ?? '').contains(trimmed),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List> list = _filteredSurahs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'القرآن الكريم',
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
                  hintText: 'ابحث عن سورة...',
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
                  final Map<String, String> surah = list[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.skyLight,
                        child: Text(
                          surah['number'] ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.skyDark,
                          ),
                        ),
                      ),
                      title: Text(
                        'سورة ${surah['name'] ?? ''}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        surah['type'] ?? '',
                        style: AppTextStyles.caption,
                      ),
                      trailing: const Icon(Icons.chevron_right),
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
