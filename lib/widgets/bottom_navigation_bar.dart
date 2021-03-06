import 'package:blurry/blurry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/main.dart';

import '../Screens/autharisation/login_page.dart';
import '../Screens/notices/notice_collection_admin.dart';
import '../Screens/notices/years_page_students.dart';
import '../pages/profile_page.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key key}) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  void logOut() {
    Blurry.warning(
        title: 'LogOut',
        description: 'Are You Sure You Want to Logout.',
        confirmButtonText: 'Logout',
        onConfirmButtonPressed: () async {
          final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
          if (_firebaseAuth.currentUser != null) {
            await _firebaseAuth.signOut();
            await storage.delete(key: 'admin');
            await storage.delete(key: 'data');
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
        }).show(context);
  }

  bool flg = false;
  void getData() async {
    var tmp = await storage.read(key: 'data');
    if (tmp == null) {
      setState(() {
        flg = false;
      });
    } else {
      setState(() {
        flg = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () async {
                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                if (_firebaseAuth.currentUser != null) {
                  var admin = await storage.read(key: 'admin');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => (admin == 'true')
                          ? const NoticeList(
                              isAdded: false,
                            )
                          : const YearPageStudents(),
                    ),
                    (route) => false,
                  );
                  // await _fireStore
                  //     .collection('users')
                  //     .doc(_firebaseAuth.currentUser.uid)
                  //     .get()
                  //     .then((element) {
                  //   Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) =>
                  //           (element['Role'] == 'admin')
                  //               ? const NoticeList(
                  //                   isAdded: false,
                  //                 )
                  //               : const YearPageStudents(),
                  //     ),
                  //     (route) => false,
                  //   );
                  // });
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const YearPageStudents()),
                    (route) => false,
                  );
                }
              }),
          if (flg == true)
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () async {
                  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  if (_firebaseAuth.currentUser != null) {
                    var admin = await storage.read(key: 'admin');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            (admin == 'true') ? ProfilePage() : ProfilePage(),
                      ),
                    );
                    // await _fireStore
                    //     .collection('users')
                    //     .doc(_firebaseAuth.currentUser.uid)
                    //     .get()
                    //     .then((element) {
                    //   Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (BuildContext context) =>
                    //           (element['Role'] == 'admin')
                    //               ? const NoticeList(
                    //                   isAdded: false,
                    //                 )
                    //               : const YearPageStudents(),
                    //     ),
                    //     (route) => false,
                    //   );
                    // });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage(),
                      ),
                    );
                  }
                }),
          IconButton(
            icon: const Icon(
              IconData(0xe3b3, fontFamily: 'MaterialIcons'),
            ),
            onPressed: () async {
              logOut();
            },
          ),
        ],
      ),
    );
  }
}
