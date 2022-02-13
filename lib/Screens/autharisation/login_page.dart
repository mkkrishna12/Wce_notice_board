import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';
import 'package:wce_notice_board/Screens/noticess/years_page_students.dart';

import './../../styles/app_colors.dart';
import './../../widgets/custom_button.dart';
import './../../widgets/custom_formfield.dart';
import './../../widgets/custom_header.dart';
import './../../widgets/custom_richtext.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool spinner = false;
  String mobile;
  String selectedUser;
  bool admin = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.blue,
            ),
            CustomHeader(
              text: 'Log In.',
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationScreen()));
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColors.whiteshade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomFormField(
                      headingText: "Email",
                      hintText: "Email",
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
                      hintText: "At least 8 Character",
                      obsecureText: true,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility), onPressed: () {}),
                      controller: _passwordController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: AppColors.blue.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AuthButton(
                      onTap: () async {
                        //spinner for the verification
                        setState(() {
                          spinner = true;
                        });
                        //check email and password
                        if (email == null || password == null) {
                          setState(() {
                            spinner = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => const PopUp(
                              toNavigate: LoginPage(),
                              message: 'All Fields are Required',
                              icon: Icons.cancel,
                              state: false,
                              color: Colors.red,
                            ),
                          );
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
                                //to check the user admin or not
                                admin = element['Role'] == 'admin';
                              });
                            });
                            setState(() {
                              spinner = false;
                              //if user student then redirect to year otherwise notice list to see or edit or add
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
                            });
                            //show successful login
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => PopUp(
                                toNavigate: (admin == true)
                                    ? const NoticeList()
                                    : const YearPageStudents(),
                                message: 'Successfully Logged in',
                                icon: FontAwesomeIcons.checkCircle,
                                state: true,
                                color: Colors.green,
                              ),
                            );
                          }).catchError(
                            (err) {
                              if (err.code == 'wrong-password') {
                                setState(() {
                                  spinner = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const PopUp(
                                    toNavigate: LoginPage(),
                                    message: 'The password provided is Wrong.',
                                    icon: Icons.cancel,
                                    state: false,
                                    color: Colors.red,
                                  ),
                                );
                              }

                              // email already in use

                              else if (err.code == 'user-not-found') {
                                setState(() {
                                  spinner = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const PopUp(
                                    toNavigate: LoginPage(),
                                    message: 'User not found .Please Register',
                                    icon: Icons.cancel,
                                    state: true,
                                    color: Colors.red,
                                  ),
                                );
                              }

                              // **invalid-email**:

                              else if (err.code == 'invalid-email') {
                                setState(() {
                                  spinner = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const PopUp(
                                    toNavigate: LoginPage(),
                                    message: 'invalid email Try Again',
                                    icon: Icons.cancel,
                                    state: false,
                                    color: Colors.red,
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                      text: 'Sign In',
                    ),
                    CustomRichText(
                      discription: "Don't already Have an account? ",
                      text: "Sign Up",
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

// CustomInputField(
//   fieldIcon: const Icon(
//     Icons.person,
//     color: Colors.white,
//   ),
//   hintText: 'Enter email',
//   onChanged: (value) {
//     setState(() {
//       email = value;
//     });
//   },
// ),
// CustomInputField(
//   fieldIcon:
//       const Icon(Icons.lock, color: Colors.white),
//   hintText: 'Enter Password',
//   onChanged: (value) {
//     setState(() {
//       password = value;
//     });
//   },
// ),

//TODO WE have to change the buttonds to elevated

// onPressed: () async {
//   //spinner for the verification
//   setState(() {
//     spinner = true;
//   });
//   //check email and password
//   if (email == null || password == null) {
//     setState(() {
//       spinner = false;
//     });
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => const PopUp(
//         toNavigate: LoginPage(),
//         message: 'All Fields are Required',
//         icon: Icons.cancel,
//         state: false,
//         color: Colors.red,
//       ),
//     );
//   } else {
//     _fireStore
//         .collection('users')
//         .doc(_firebaseAuth.currentUser.uid)
//         .get()
//         .then((element) {
//       setState(() {
//         //to check the user admin or not
//         admin = element['Role'] == 'admin';
//       });
//     });
//     _firebaseAuth
//         .signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     )
//         .then((value) {
//       setState(() {
//         spinner = false;
//         //if user student then redirect to year otherwise notice list to see or edit or add
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) =>
//                 (admin == true)
//                     ? const NoticeList()
//                     : const YearPageStudents(),
//           ),
//           (route) => false,
//         );
//       });
//       //show successful login
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => PopUp(
//           toNavigate: (admin == true)
//               ? const NoticeList()
//               : const YearPageStudents(),
//           message: 'Successfully Logged in',
//           icon: FontAwesomeIcons.checkCircle,
//           state: true,
//           color: Colors.green,
//         ),
//       );
//     }).catchError(
//       (err) {
//         if (err.code == 'wrong-password') {
//           setState(() {
//             spinner = false;
//           });
//           showDialog(
//             context: context,
//             builder: (BuildContext context) =>
//                 const PopUp(
//               toNavigate: LoginPage(),
//               message:
//                   'The password provided is Wrong.',
//               icon: Icons.cancel,
//               state: false,
//               color: Colors.red,
//             ),
//           );
//         }
//
//         // email already in use
//
//         else if (err.code == 'user-not-found') {
//           setState(() {
//             spinner = false;
//           });
//           showDialog(
//             context: context,
//             builder: (BuildContext context) =>
//                 const PopUp(
//               toNavigate: LoginPage(),
//               message:
//                   'User not found .Please Register',
//               icon: Icons.cancel,
//               state: true,
//               color: Colors.red,
//             ),
//           );
//         }
//
//         // **invalid-email**:
//
//         else if (err.code == 'invalid-email') {
//           setState(() {
//             spinner = false;
//           });
//           showDialog(
//             context: context,
//             builder: (BuildContext context) =>
//                 const PopUp(
//               toNavigate: LoginPage(),
//               message: 'invalid email Try Again',
//               icon: Icons.cancel,
//               state: false,
//               color: Colors.red,
//             ),
//           );
//         }
//       },
//     );
//   }
// },
//Option for the new user ot registration
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     const Text(
//       'New To Wce notice board',
//     ),
//     const SizedBox(width: 15.0),
//     InkWell(
//       onTap: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) {
//           return const RegistrationScreen();
//         }));
//       },
//       child: const Text(
//         'Register',
//         style: TextStyle(
//           decoration: TextDecoration.underline,
//           color: Colors.greenAccent,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ],
