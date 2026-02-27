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
import 'package:firebase_core/firebase_core.dart';
import 'package:k_quiz/presentations/pages/auth2/auth_bloc.dart';
import 'package:k_quiz/presentations/pages/auth2/login_screen.dart';
import 'package:k_quiz/presentations/pages/auth2/registr_screen.dart';
import 'package:k_quiz/presentations/pages/main/books/books_page.dart';
import 'package:k_quiz/presentations/pages/splash/splash_page.dart';
import 'di/service_locator.dart';
// lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(getIt.get()),
      child: MaterialApp(
        title: 'Korean Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: SplashPage(),
      ),
    );
  }
}