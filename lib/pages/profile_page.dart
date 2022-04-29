import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/display_image_widget.dart';
import '../user/user_data.dart';
import 'edit_department.dart';
import 'edit_designation.dart';
import 'edit_email.dart';
import 'edit_image.dart';
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
  @override
  Widget build(BuildContext context) {
    final user = UserData.myUser;

    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: const Color(0xFF980F58),
          // elevation: 0,
          // toolbarHeight: 0,

          title : const Center(
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
        body: Container(
          height: MediaQuery.of(context).size.height*1,
          color: const Color(0xFFFEF1E6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                    onTap: () {
                      navigateSecondPage(const EditImagePage());
                    },
                    child: DisplayImage(
                      imagePath: user.image,
                      onPressed: () {},
                    )),
                const SizedBox(
                  height: 25,
                ),
                buildUserInfoDisplay(user.name, 'Name', const EditNameFormPage(),),
                buildUserInfoDisplay(user.phone, 'Phone', const EditPhoneFormPage(),),
                buildUserInfoDisplay(user.email, 'Email ID', const EditEmailFormPage(),),
                buildUserInfoDisplay(
                    user.department, 'Department', const EditDepartmentFormPage(),),
                buildUserInfoDisplay(
                    user.designation, 'Designation', const EditDesignationFormPage(),),
                buildUserInfoDisplay(
                    user.otherrole, 'Other role', const EditOtherRoleFormPage(),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
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
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: const TextStyle(fontSize: 16, height: 1.4,color: Colors.black),
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
