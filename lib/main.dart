import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';

import 'Screens/notices/add_notice.dart';

//TODO implement snack bar to all notification except delete
//TODO Add Stream Builder in place of get all function
//TODO Add Personalised Ui and to show wha has seen the message
//TODO we will see more
const storage = FlutterSecureStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const Material(child: AddNotice(),),
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
    var _duration = const Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  void navigate() {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (_, __, ___) => const LoginPage()));
  }

  @override
  void initState() {
    // TODO: implement initState and also add for moodle user.
    super.initState();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    // if (_firebaseAuth.currentUser != null) {
    //   _fireStore
    //       .collection('users')
    //       .doc(_firebaseAuth.currentUser.uid)
    //       .get()
    //       .then((element) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => (element['Role'] == 'admin')
    //             ? const NoticeList(
    //                 isAdded: false,
    //               )
    //             : const YearPageStudents(),
    //       ),
    //       (route) => false,
    //     );
    //   });
    // } else {
    //   startTimer();
    // }
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
              const Text('Welcome',style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
