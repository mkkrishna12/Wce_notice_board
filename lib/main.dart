import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wce_notice_board/Custom_widget/notes_services.dart';

import 'Screens/Autharisation/login_page.dart';

void main() async {
  GetIt.instance.registerLazySingleton(() => NotesServices());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: loginPage(),
  ));
}
//
// /* Filters on List page for students side
//   1] by date
//   2]latest
//
//  */
