import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wce_notice_board/Custom_widget/notes_services.dart';
import 'package:wce_notice_board/Screens/Notice_veiwer.dart';
import 'package:wce_notice_board/Screens/notice_collection.dart';
import 'Screens/login_page.dart';
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
      home: noticeList(),
    );
  }
}