import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/islamic_pattern_background.dart';

/// صفحة إعدادات الأذان — 7 فتحات
class AzanSettingsScreen extends StatefulWidget {
  const AzanSettingsScreen({super.key});

  @override
  State<AzanSettingsScreen> createState() => _AzanSettingsScreenState();
}

class _AzanSettingsScreenState extends State<AzanSettingsScreen> {
  final List<String?> _azanPaths = List.filled(7, null);
  final AudioPlayer _previewPlayer = AudioPlayer();
  int? _playingSlot;

  @override
  void dispose() {
    _previewPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(int index) async {
    final path = _azanPaths[index];
    if (path == null) return;
    if (_playingSlot == index && _previewPlayer.playing) {
      await _previewPlayer.stop();
      setState(() => _playingSlot = null);
      return;
    }
    try {
      await _previewPlayer.stop();
      await _previewPlayer.setFilePath(path);
      setState(() => _playingSlot = index);
      await _previewPlayer.play();
      _previewPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && mounted) {
          setState(() => _playingSlot = null);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _playingSlot = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تشغيل الملف الصوتي: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedPaths();
  }

  /// تحميل المسارات المحفوظة مسبقاً
  Future<void> _loadSavedPaths() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 7; i++) {
        _azanPaths[i] = prefs.getString('azan_slot_$i');
      }
    });
  }

  /// اختيار ملف صوتي من الجهاز
  Future<void> _pickAudio(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('azan_slot_$index', path);
        
        setState(() {
          _azanPaths[index] = path;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ ملف الأذان بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء اختيار الملف: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// حذف الملف المخصص
  Future<void> _clearAudio(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('azan_slot_$index');
    setState(() {
      _azanPaths[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الأذان'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: IslamicPatternBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // ── وصف الصفحة ────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.skyLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.skySoft),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.skyDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'يمكنك تعيين ملف صوتي مخصص (MP3) لكل فتحة. إذا تركتها فارغة سيتم استخدام الصوت الافتراضي.',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.skyDeep),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── الفتحات السبع ─────────────────────────
              ...List.generate(7, (index) {
                final hasAudio = _azanPaths[index] != null;
                final fileName = hasAudio
                    ? _azanPaths[index]!.split('/').last
                    : 'لم يتم تحديد ملف (الافتراضي)';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasAudio
                          ? AppColors.skyPrimary
                          : AppColors.divider,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: AppTextStyles.titleOnDark
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'فتحة الأذان ${index + 1}',
                                  style: AppTextStyles.title
                                      .copyWith(fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  fileName,
                                  style: AppTextStyles.tiny.copyWith(
                                    color: hasAudio
                                        ? AppColors.skyDark
                                        : AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (hasAudio)
                            IconButton(
                              onPressed: () => _clearAudio(index),
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: AppColors.error, size: 22),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // ── أزرار الإجراءات ──────────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickAudio(index),
                              icon: const Icon(Icons.audiotrack_rounded,
                                  size: 18),
                              label: Text(hasAudio
                                  ? 'تغيير الملف'
                                  : 'اختيار ملف صوتي'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.skyDark,
                                side: const BorderSide(
                                    color: AppColors.skyPrimary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          if (hasAudio) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _togglePreview(index),
                                icon: Icon(
                                  _playingSlot == index && _previewPlayer.playing
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  _playingSlot == index && _previewPlayer.playing
                                      ? 'إيقاف'
                                      : 'تجربة',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.skyDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
