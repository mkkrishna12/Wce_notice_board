import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';

import 'Screens/notices/notice_collection.dart';
import 'Screens/notices/years_page_students.dart';

void main() async {
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
    // TODO: implement initState
    super.initState();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    if (_firebaseAuth.currentUser != null) {
      _fireStore
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .get()
          .then((element) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => (element['Role'] == 'admin')
                ? const NoticeList(
                    isAdded: false,
                  )
                : const YearPageStudents(),
          ),
          (route) => false,
        );
      });
    } else {
      startTimer();
    }
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
