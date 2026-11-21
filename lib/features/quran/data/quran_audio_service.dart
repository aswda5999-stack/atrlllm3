import 'package:just_audio/just_audio.dart';

/// خدمة تشغيل تلاوة الآيات
/// تعتمد على مصدر everyayah.com (يدعم أشهر القراء)
class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();

  /// اسم القارئ (المجلد على everyayah)
  /// القيمة الافتراضية: مشاري العفاسي
  String _reciter = 'Alafasy_128kbps';

  /// تغيير القارئ
  void setReciter(String reciterId) {
    _reciter = reciterId;
  }

  /// تشغيل آية محددة
  /// [surahId]: رقم السورة (1-114)
  /// [ayahNumber]: رقم الآية داخل السورة
  /// [onComplete]: دالة تُستدعى عند انتهاء التلاوة
  Future<void> playAyah({
    required int surahId,
    required int ayahNumber,
    VoidCallback? onComplete,
  }) async {
    // تكوين اسم الملف: 001001.mp3 (سورة 1، آية 1)
    final surahStr = surahId.toString().padLeft(3, '0');
    final ayahStr = ayahNumber.toString().padLeft(3, '0');
    final fileName = '$surahStr$ayahStr.mp3';

    // رابط الملف على everyayah
    final url = 'https://everyayah.com/data/$_reciter/$fileName';

    try {
      await _player.stop();
      await _player.setUrl(url);
      _player.play();

      // عند انتهاء التشغيل
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          onComplete?.call();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// إيقاف التشغيل
  Future<void> stop() async {
    await _player.stop();
  }

  /// إيقاف مؤقت
  Future<void> pause() async {
    await _player.pause();
  }

  /// استئناف التشغيل
  Future<void> resume() async {
    await _player.play();
  }

  /// التخلص من الموارد
  void dispose() {
    _player.dispose();
  }
}

/// دالة مساعدة للتحقق من نوع ProcessingState
extension on ProcessingState {
  bool get isCompleted => this == ProcessingState.completed;
}
