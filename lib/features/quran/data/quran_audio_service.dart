import 'package:flutter/foundation.dart'; // ← هذا هو السطر الناقص
import 'package:just_audio/just_audio.dart';

/// خدمة تشغيل تلاوة الآيات
class QuranAudioService {
  final AudioPlayer _player = AudioPlayer();
  String _reciter = 'Alafasy_128kbps';

  void setReciter(String reciterId) {
    _reciter = reciterId;
  }

  Future<void> playAyah({
    required int surahId,
    required int ayahNumber,
    VoidCallback? onComplete,
  }) async {
    final surahStr = surahId.toString().padLeft(3, '0');
    final ayahStr = ayahNumber.toString().padLeft(3, '0');
    final fileName = '$surahStr$ayahStr.mp3';
    final url = 'https://everyayah.com/data/$_reciter/$fileName';

    try {
      await _player.stop();
      await _player.setUrl(url);
      _player.play();

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          onComplete?.call();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stop() async => await _player.stop();
  Future<void> pause() async => await _player.pause();
  Future<void> resume() async => await _player.play();
  void dispose() => _player.dispose();
}
