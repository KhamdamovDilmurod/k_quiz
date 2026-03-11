import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../config/theme_controller.dart';
import '../data/network/database_helper.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/study_progress_repository.dart';
import '../data/repositories/word_repository.dart';
import '../services/firebase_auth_service.dart';
import '../services/google_sheets_service.dart';
import '../services/tts_service.dart';
import '../utils/pref_utils.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {

  // Database
  final db = await DatabaseHelper.instance.database;
  getIt.registerSingleton<Database>(db);

  // SharedPreferences (PrefUtils)
  final prefUtils = PrefUtils();
  await prefUtils.init(); // Initializatsiya qilish kerak
  getIt.registerSingleton<PrefUtils>(prefUtils);
  /// ishlatilinishi   ->    getIt<PrefUtils>().setToken("");

  final themeController = ThemeController(prefUtils);
  await themeController.load();
  getIt.registerSingleton<ThemeController>(themeController);

  // Repositories
  getIt.registerLazySingleton<WordRepository>(
          () => WordRepository(getIt<Database>())
  );
  getIt.registerLazySingleton<StudyProgressRepository>(
          () => StudyProgressRepository(getIt<Database>())
  );

  // Services
  getIt.registerLazySingleton<GoogleSheetsService>(
          () => GoogleSheetsService(getIt<Database>())
  );

// AUTH - Yangi qo'shildi
  getIt.registerLazySingleton<FirebaseAuthService>(
        () => FirebaseAuthService(),
  );
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepository(getIt<FirebaseAuthService>(), getIt<PrefUtils>())
  );
  // TTS Service - Singleton sifatida
  getIt.registerLazySingleton<TtsService>(() => TtsService());

  // TTS-ni initialize qilish (ixtiyoriy, birinchi ishlatishda ham avtomatik qiladi)
  await getIt<TtsService>().initialize();

}
