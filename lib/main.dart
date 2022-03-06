import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';

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
      home: const Material(
        child: SplashScreen(),
      ),
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

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}

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

  SnackBar snackBar; // Snack to show the error or any message
  void setContent(content, bool isTrue) {
    snackBar = SnackBar(
      elevation: 6.0,
      backgroundColor: isTrue
          ? Colors.green
          : const Color(
              0xFF97170E,
            ),
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    return;
  }

  void navigate() {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (_, __, ___) => const LoginPage()));
  }

  ConnectivityResult _connectivityResult;
  StreamSubscription _connectivitySubscription;
  bool _isConnectionSuccessful;
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

    _checkConnectivityState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // print('Current connectivity status: $result');
      await _checkConnectivityState();
      setState(() {
        // setContent('Current connectivity status: $result', true);
        _connectivityResult = result;
        _isConnectionSuccessful = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    startTimer();
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi && _isConnectionSuccessful) {
      setState(() {
        setContent('Connected to a Wi-Fi network', true);
      });
    } else if (result == ConnectivityResult.mobile && _isConnectionSuccessful) {
      setState(() {
        setContent('Connected to a mobile network', true);
      });
    } else {
      if (result == ConnectivityResult.none) {
        setState(() {
          setContent(
              'Not connected to any network , Please Connect and Try Again',
              false);
        });
      }
    }

    setState(() {
      _connectivityResult = result;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('https://www.google.com/');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      print(e);
      setState(() {
        _isConnectionSuccessful = false;
      });
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
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
