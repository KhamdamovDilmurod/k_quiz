// import 'package:flutter/material.dart';
// import 'package:k_quiz/presentations/pages/splash/splash_page.dart';
// import 'di/service_locator.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await setupDependencies();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Korean Quiz',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
//       home: SplashPage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:k_quiz/config/theme/theme_config.dart';
import 'package:k_quiz/config/theme/theme_cubit.dart';
import 'package:k_quiz/presentations/pages/auth/auth_bloc.dart';
import 'package:k_quiz/presentations/pages/auth/login_screen.dart';
import 'package:k_quiz/presentations/pages/auth/registr_screen.dart';
import 'package:k_quiz/presentations/pages/main/books/books_page.dart';
import 'package:k_quiz/presentations/pages/splash/splash_page.dart';
import 'package:k_quiz/utils/pref_utils.dart';
import 'di/service_locator.dart';
// lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('ko')],
      path: 'assets/lang',
      fallbackLocale: const Locale('uz'),
      startLocale: Locale(_normalizeLocaleCode(getIt<PrefUtils>().getLang())),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

String _normalizeLocaleCode(String value) {
  switch (value) {
    case 'ko':
    case 'kor':
      return 'ko';
    case 'uz':
    case 'en':
    default:
      return 'uz';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(getIt.get())),
        BlocProvider(create: (context) => ThemeCubit(getIt.get())..loadTheme()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder:
            (context, state) => MaterialApp(
              title: 'app.title'.tr(),
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: ThemeConfig.lightTheme,
              darkTheme: ThemeConfig.darkTheme,
              themeMode: state.themeMode,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child ?? const SizedBox(),
                );
              },
              routes: {
                '/login': (_) => const LoginScreen(),
                '/register': (_) => const RegisterScreen(),
                '/books': (_) => const BooksScreen(),
              },
              home: const SplashPage(),
            ),
      ),
    );
  }
}
