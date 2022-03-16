import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Screens/notices/notice_collection_admin.dart';
import 'package:wce_notice_board/Screens/notices/years_page_students.dart';
import 'package:wce_notice_board/styles/text_styles.dart';
import '../../Custom_widget/custom_button.dart';
import '../../Custom_widget/custom_formfield.dart';
import '../../main.dart';

/// To store prn and token in local we have used storage is flutter secure storage
/// this widget for Login of the user and admin

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  ///To get the email or the prn entered by the user
  final _passwordController = TextEditingController();

  /// to get the password by the user
  SnackBar snackBar;

  /// Snack to show the error or any message
  bool spinner = false;

  ///Spinner will be handle by using this variable
  String selectedUser = 'Student';

  ///This variable is used for the selection of user
  bool admin = false;

  ///To check the admin or not
  List<String> userType = [
    /// 'select user',
    'Student',
    'Admin',
  ];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool obSecureController = true;
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  ///To update the content in snackbar we used this function
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          color: Colors.blue,
        ),
        // color: Colors.blue,
        inAsyncCall: spinner,
        child: Scaffold(
          backgroundColor: const Color(0xFF65C0E8),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      child: const Text(
                        'Select User',
                        style: KTextStyle.textFieldHeading,
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: Center(
                        child: DropdownButton(
                          // Initial Value
                          value: selectedUser,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: userType.map((String items) {
                            return DropdownMenuItem(
                              alignment: AlignmentDirectional.centerStart,
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),

                          /// After selecting the desired option,it will
                          /// change button value to selected value
                          onChanged: (String newValue) {
                            setState(() {
                              selectedUser = newValue;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomFormField(
                  headingText: selectedUser == 'Admin' ? 'Email' : "PRN",
                  hintText: selectedUser == 'Admin'
                      ? "Enter Email"
                      : "Enter Your College PRN",
                  obsecureText: false,
                  suffixIcon: const SizedBox(),
                  controller: _emailController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomFormField(
                  headingText: "Password",
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  hintText: selectedUser == 'Admin'
                      ? "At least 8 Character"
                      : "Enter Moodle Password",
                  obsecureText: obSecureController,
                  suffixIcon: IconButton(
                      color: obSecureController == true
                          ? Colors.grey
                          : Colors.blue,
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obSecureController = !obSecureController;
                        });
                      }),
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 30,
                ),
                AuthButton(
                  onTap: () async {
                    //spinner for the verification
                    setState(() {
                      spinner = true;
                    });
                    if (selectedUser == 'select user') {
                      setState(() {
                        spinner = false;
                        setContent('Select Valid User', false);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (selectedUser == 'Admin') {
                        if (email.isEmpty || password.isEmpty) {
                          setState(() {
                            spinner = false;
                            setContent('All Fields are required', false);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          _firebaseAuth
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          )
                              .then((value) {
                            _fireStore
                                .collection('users')
                                .doc(_firebaseAuth.currentUser.uid)
                                .get()
                                .then((element) {
                              setState(() {
                                ///to check the user admin or not
                                admin = element['Role'] == 'admin';
                              });

                              setState(() {
                                setContent("Successfully Logged in", true);
                                spinner = false;

                                ///if user student then redirect to year otherwise notice list to see or edit or add
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        (admin == true)
                                            ? const NoticeList(isAdded: false)
                                            : const YearPageStudents(),
                                  ),
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            });
                          }).catchError(
                            (err) {
                              if (err.code == 'wrong-password') {
                                setState(() {
                                  spinner = false;
                                  setContent(
                                      'The Password provided is Wrong', false);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              /// email already in use

                              else if (err.code == 'user-not-found') {
                                setState(() {
                                  spinner = false;
                                  setContent('User Not Found', false);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              /// **invalid-email**:

                              else if (err.code == 'invalid-email') {
                                setState(() {
                                  spinner = false;
                                  setContent('Invalid Email', false);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          );
                        }
                      } else {
                        //Todo 1 api calls
                        await FirebaseAuth.instance.signOut();
                        http.post(
                            Uri.parse(
                                'http://115.247.20.236/moodle/login/token.php?service=moodle_mobile_app&moodlewsrestformat=json'),
                            body: {
                              'username': email,
                              'password': password
                            }).then((var response) {
                          dynamic userToken = jsonDecode(response.body);
                          if (userToken['error'] != null) {
                            setState(() {
                              spinner = false;
                              setContent(userToken['error'], false);
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            http.post(
                                Uri.parse(
                                    'http://115.247.20.236/moodle/webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json'),
                                body: {
                                  'wstoken': userToken['token']
                                }).then((var value) {
                              storage.write(
                                  key: "username",
                                  value: json.decode(value.body)["username"]);
                              storage.write(
                                  key: "token", value: userToken['token']);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      (admin == true)
                                          ? const NoticeList()
                                          : const YearPageStudents(),
                                ),
                                (route) => false,
                              );
                              setState(() {
                                spinner = false;
                              });
                            });
                          }
                        });
                      }
                    }
                  },
                  text: 'Sign In',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
