import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wce_notice_board/Custom_widget/notes_services.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';

void main() async {
  GetIt.instance.registerLazySingleton(() => NotesServices());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(const MaterialApp(
  //   home: LoginPage(),
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//
// /* Filters on List page for students side
//   1] by date
//   2]latest
//
//  */

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    var _duration = const Duration(milliseconds: 3000);
    return Timer(_duration, navigate);
  }

  void navigate() {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (_, __, ___) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'logo',
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
              const Text('Welcome'),
            ],
          ),
        ),
      ),
    );
  }
}
