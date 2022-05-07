import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/main.dart';

import '../user/user_data.dart';
import 'edit_department.dart';
import 'edit_designation.dart';
import 'edit_email.dart';
import 'edit_name.dart';
import 'edit_otherrole.dart';
import 'edit_phone.dart';

// This class handles the Page to display the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String facultyName;
  String facultyRole;
  String age;
  final user = UserData.myUser;
  var data;
  var spinner = true;
  bool edit = false;
  String title = "Edit";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void getData() async {
    data = await storage.read(key: 'data');
    print(data);
    if (data != null) {
      var tmp = json.decode(data);
      user.name = tmp['name'] == null ? user.name : tmp['name'];
      user.image = tmp['image'] == null ? user.image : tmp['image'];
      user.email = tmp['email'] == null ? user.email : tmp['email'];
      user.otherrole =
          tmp['otherrole'] == null ? user.otherrole : tmp['otherrole'];
      user.designation =
          tmp['designation'] == null ? user.designation : tmp['designation'];
      user.department =
          tmp['department'] == null ? user.department : tmp['department'];
      user.phone = tmp['phoneNumber'] == null ? user.phone : tmp['phoneNumber'];
    }
    setState(() {
      spinner = false;
    });
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF980F58),
          // elevation: 0,
          // toolbarHeight: 0,

          title: const Center(
              child: Text(
            'My Profile',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              // color: Colors.black54,
              // fromRGBO(64, 105, 225, 1)
            ),
          )),
        ),
        body: ModalProgressHUD(
          inAsyncCall: spinner,
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            color: const Color(0xFFFEF1E6),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment(-.2, 0),
                          image: NetworkImage(
                              'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'),
                          fit: BoxFit.cover),
                    ),
                    // child: DisplayImage(
                    //   imagePath: user.image,
                    //   onPressed: () {},
                    // )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  buildUserInfoDisplay(
                      user.name, 'Name', const EditNameFormPage(), edit),
                  buildUserInfoDisplay(
                      user.phone, 'Phone', const EditPhoneFormPage(), edit),
                  buildUserInfoDisplay(
                      user.email, 'Email ID', const EditEmailFormPage(), edit),
                  buildUserInfoDisplay(user.department, 'Department',
                      const EditDepartmentFormPage(), edit),
                  buildUserInfoDisplay(user.designation, 'Designation',
                      const EditDesignationFormPage(), edit),
                  buildUserInfoDisplay(
                      user.otherrole, 'Other role', const OtherRol(), edit),
                  ElevatedButton(
                    child: Text(title),
                    onPressed: () {
                      print(_firebaseAuth.currentUser.uid);
                      setState(() {
                        edit = !edit;
                        if (edit != true) {
                          setState(() {
                            spinner = true;
                          });
                          var tmp = {
                            'image':
                                "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
                            'name': user.name,
                            'phoneNumber': user.phone,
                            'department': user.department,
                            'designation': user.designation,
                            'otherrole': user.otherrole,
                            'email': user.email,
                          };
                          storage.write(
                            key: 'data',
                            value: json.encode(tmp),
                          );
                          _fireStore
                              .collection('users')
                              .doc(_firebaseAuth.currentUser.uid)
                              .set(tmp, SetOptions(merge: true))
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'User Data Updated',
                              ),
                            ));
                            setState(() {
                              spinner = false;
                            });
                          }).catchError((onError) {
                            // print(onError);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Something went wrong.....',
                              ),
                            ));
                            setState(() {
                              spinner = false;
                            });
                          });
                        }
                        title = (edit == true) ? "Submit" : "Edit";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(
          String getValue, String title, Widget editPage, bool edit) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              if (edit) {
                                navigateSecondPage(editPage);
                              }
                            },
                            child: Text(
                              getValue,
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.black),
                            ))),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the About Me Section
  // Widget buildAbout(User user) => Padding(
  //     padding: EdgeInsets.only(bottom: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Tell Us About Yourself',
  //           style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey,
  //           ),
  //         ),
  //         const SizedBox(height: 1),
  //         Container(
  //             width: 350,
  //             height: 200,
  //             decoration: BoxDecoration(
  //                 border: Border(
  //                     bottom: BorderSide(
  //               color: Colors.grey,
  //               width: 1,
  //             ))),
  //             child: Row(children: [
  //               Expanded(
  //                   child: TextButton(
  //                       onPressed: () {
  //                         navigateSecondPage(EditDescriptionFormPage());
  //                       },
  //                       child: Padding(
  //                           padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
  //                           child: Align(
  //                               alignment: Alignment.topLeft,
  //                               child: Text(
  //                                 user.aboutMeDescription,
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   height: 1.4,
  //                                 ),
  //                               ))))),
  //               Icon(
  //                 Icons.keyboard_arrow_right,
  //                 color: Colors.grey,
  //                 size: 40.0,
  //               )
  //             ]))
  //       ],
  //     ));

  // Refreshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
