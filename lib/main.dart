import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';

import 'Screens/notices/notice_collection.dart';
import 'Screens/notices/years_page_students.dart';

bool isLogged = false;
bool isAdmin = false;
const storage = FlutterSecureStorage();
void main() async {
  /// initialize the firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  if (_firebaseAuth.currentUser != null) {
    await _fireStore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((element) {
      isLogged = true;
      isAdmin = true;
    });
  } else {
    var username = await storage.read(key: "username");
    var token = await storage.read(key: "token");
    // print(username);
    if (username != null && token != null) {
      isLogged = true;
    } else {
      isLogged = false;
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Material(
        child: (isLogged == true)
            ? (isAdmin == true
                ? const NoticeList(
                    isAdded: false,
                  )
                : const YearPageStudents())
            : const SplashScreen(),
      ),
      debugShowCheckedModeBanner: true,
    );
  }
}

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
  /// To set the splash screen timer
  startTimer() {
    var _duration = const Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  /// After splash screen we will redirected to this route
  void navigate() {
    Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
        pageBuilder: (_, __, ___) => const LoginPage()));
  }
  StreamSubscription _connectivitySubscription;
  bool _isConnectionSuccessful;
  @override
  void initState() {
    // TODO: implement initState and also add for moodle user.
    super.initState();
    startTimer();

    _checkConnectivityState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _checkConnectivityState();
      setState(() {
        _isConnectionSuccessful = true;
      });
    });
    startTimer();
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  /// this function is used for the internet connection of internet for th application
  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi && _isConnectionSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Connected to a Wi-fi network',
        ),
        backgroundColor: Colors.green,
      ));
    } else if (result == ConnectivityResult.mobile && _isConnectionSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Connected to a mobile network',
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Not connected to any network , Please Connect and Try Again',
          ),
          backgroundColor: Colors.red,
        ));
      }
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
