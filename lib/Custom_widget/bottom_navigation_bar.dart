import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/autharisation/login_page.dart';
import 'package:wce_notice_board/main.dart';

import '../Screens/notices/notice_collection.dart';
import '../Screens/notices/years_page_students.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key key}) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
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
                        builder: (BuildContext context) =>
                            (element['Role'] == 'admin')
                                ? const NoticeList(
                                    isAdded: false,
                                  )
                                : const YearPageStudents(),
                      ),
                      (route) => false,
                    );
                  });
                }
              }),
          IconButton(
            icon: const Icon(
              IconData(0xe3b3, fontFamily: 'MaterialIcons'),
            ),
            onPressed: () async {
              final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              if (_firebaseAuth.currentUser != null) {
                print("done");
                await _firebaseAuth.signOut();
              } else {
                await storage.delete(key: 'username');
                await storage.delete(key: 'token');
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
