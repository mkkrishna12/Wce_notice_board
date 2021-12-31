import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wce_notice_board/Custom_widget/notes_services.dart';
import 'package:wce_notice_board/Screens/noticess/Notice_veiwer.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';
import 'package:wce_notice_board/Screens/noticess/years.dart';
import 'Screens/Autharisation/login_page.dart';
import 'package:get_it/get_it.dart';

void main() async{
  GetIt.instance.registerLazySingleton(() => NotesServices());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginPage(),
    );
  }
}
//
//
// /* Filters on List page for students side
//   1] by date
//   2]latest
//
//  */