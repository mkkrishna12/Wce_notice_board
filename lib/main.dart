import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
//
// /* Filters on List page for students side
//   1] by date
//   2]latest
//
//  */
