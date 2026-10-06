import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// النطق: الحروف والكلمات بصوت الجهاز (TTS)، والقرآن من تسجيلات EveryAyah
class Speech {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _player = AudioPlayer();
  static bool _ready = false;

  /// يُستدعى عند انتهاء قراءة النص (مثلاً نهاية القصة)
  static VoidCallback? onDone;

  // القارئ - غيّره حسب الرغبة (راجع قائمة القراء في موقع everyayah.com)
  static const reciter = 'Alafasy_128kbps';

  static Stream<void> get onComplete => _player.onPlayerComplete;

  static Future<void> _setup() async {
    if (_ready) return;
    _ready = true;
    await _tts.setLanguage('ar');
    await _tts.setSpeechRate(0.4);
    _tts.setCompletionHandler(() => onDone?.call());
  }

  static Set<String> _assets = {};

  /// يقرأ قائمة الملفات المضمّنة (لاستخدام الصوتيات المسجّلة إن وُجدت)
  static Future<void> init() async {
    try {
      final m = await AssetManifest.loadFromAssetBundle(rootBundle);
      _assets = m.listAssets().toSet();
    } catch (_) {}
  }

  static bool hasAsset(String path) => _assets.contains(path);

  static Future<void> playAsset(String path) async {
    await _tts.stop();
    await _player.stop();
    await _player.play(AssetSource(path.replaceFirst('assets/', '')));
  }

  /// يشغّل الملف المسجّل إن وُجد، وإلا يقرأ النص بصوت الجهاز
  static Future<void> sayOr(String assetPath, String text) async {
    if (hasAsset(assetPath)) {
      await playAsset(assetPath);
    } else {
      await say(text);
    }
  }

  static Future<void> say(String text) async {
    await _setup();
    await _player.stop();
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> playAyah(int surah, int ayah) async {
    await _tts.stop();
    await _player.stop();
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    await _player.play(UrlSource('https://everyayah.com/data/$reciter/$s$a.mp3'));
  }

  static Future<void> stop() async {
    await _tts.stop();
    await _player.stop();
  }
}
