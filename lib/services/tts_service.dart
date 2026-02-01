import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  // TTS-ni sozlash
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Android uchun
      await _flutterTts.setSharedInstance(true);

      // Asosiy sozlamalar
      await _flutterTts.setVolume(1.0); // Ovoz balandligi (0.0 - 1.0)
      await _flutterTts.setPitch(1.0); // Ovoz toni (0.5 - 2.0)
      await _flutterTts.setSpeechRate(0.5); // Gapirish tezligi (0.0 - 1.0)

      _isInitialized = true;
    } catch (e) {
      print("TTS sozlashda xatolik: $e");
    }
  }

  // Koreys tilida gapirish
  Future<void> speakKorean(String text) async {
    await initialize();
    try {
      await _flutterTts.setLanguage("ko-KR");
      await _flutterTts.speak(text);
      print("Koreys tilida tallafuz qilindi");
    } catch (e) {
      print("Koreys tilida gapirish xatosi: $e");
    }
  }

  // O'zbek tilida gapirish
  Future<void> speakUzbek(String text) async {
    await initialize();
    try {
      // O'zbek tili mavjud bo'lmasa, rus tilini ishlatamiz
      await _flutterTts.setLanguage("uz-UZ");
      await _flutterTts.speak(text);
    } catch (e) {
      print("O'zbek tilida gapirish xatosi: $e");
      // O'zbek tili ishlamasa, rus tilini sinab ko'ramiz
      try {
        await _flutterTts.setLanguage("ru-RU");
        await _flutterTts.speak(text);
      } catch (e2) {
        print("Rus tilida ham xatolik: $e2");
      }
    }
  }

  // Istalgan tilda gapirish (til kodini o'zingiz bering)
  Future<void> speak(String text, String languageCode) async {
    await initialize();
    try {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.speak(text);
    } catch (e) {
      print("Gapirish xatosi: $e");
    }
  }

  // Gaprishni to'xtatish
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print("To'xtatish xatosi: $e");
    }
  }

  // Pauza
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      print("Pauza xatosi: $e");
    }
  }

  // Ovoz balandligini o'zgartirish (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await initialize();
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      print("Volume o'zgartirish xatosi: $e");
    }
  }

  // Ovoz tonini o'zgartirish (0.5 - 2.0)
  Future<void> setPitch(double pitch) async {
    await initialize();
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print("Pitch o'zgartirish xatosi: $e");
    }
  }

  // Gapirish tezligini o'zgartirish (0.0 - 1.0)
  Future<void> setSpeechRate(double rate) async {
    await initialize();
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print("Speech rate o'zgartirish xatosi: $e");
    }
  }

  // Mavjud tillarni olish
  Future<List<dynamic>> getLanguages() async {
    await initialize();
    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      print("Tillarni olish xatosi: $e");
      return [];
    }
  }

  // Hozir gapirish jarayonida ekanligini tekshirish
  Future<bool> isSpeaking() async {
    try {
      final result = await _flutterTts.awaitSpeakCompletion(true);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  // Gapirish tugaganida callback
  void setCompletionHandler(Function onComplete) {
    _flutterTts.setCompletionHandler(() {
      onComplete();
    });
  }

  // Gapirish boshlanganida callback
  void setStartHandler(Function onStart) {
    _flutterTts.setStartHandler(() {
      onStart();
    });
  }

  // Xatolik yuz berganida callback
  void setErrorHandler(Function(String) onError) {
    _flutterTts.setErrorHandler((msg) {
      onError(msg);
    });
  }
}