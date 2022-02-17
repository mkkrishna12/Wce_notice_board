import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';
import 'package:wce_notice_board/Screens/noticess/years_page_students.dart';
import 'package:wce_notice_board/styles/text_styles.dart';
import './../../styles/app_colors.dart';
import './../../widgets/custom_button.dart';
import './../../widgets/custom_formfield.dart';
// this widget for Login of the user and admin

class LoginPage extends StatefulWidget {

  const LoginPage({Key key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();   //To get the email or the prn entered by the user
  final _passwordController = TextEditingController();  // to get the password by the user

  bool spinner = false;                               //Spinner will be handle by using this variable
  String selectedUser = 'select user';                //This variable is used for the selection of user
  bool admin = false;                                 //To check the admin or not
  List<String> userType = [
    'select user',
    'Admin',
    'Student',
  ];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool obSecureController = true;
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.whiteShade,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
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
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
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
                              // After selecting the desired option,it will
                              // change button value to selected value
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
                    // Center(
                    //   child:,
                    // ),
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
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => const PopUp(
                              toNavigate: LoginPage(),
                              message: 'Select valid user',
                              icon: Icons.cancel,
                              state: false,
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (selectedUser == 'Admin') {
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
                                });
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
                                        message:
                                            'The password provided is Wrong.',
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
                                        message:
                                            'User not found .Please Register',
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => PopUp(
                                    toNavigate: null,
                                    message: userToken['error'],
                                    icon: Icons.cancel,
                                    state: false,
                                    color: Colors.red,
                                  ),
                                );
                                setState(() {
                                  spinner = false;
                                });
                              } else {
                                http.post(
                                    Uri.parse(
                                        'http://115.247.20.236/moodle/webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json'),
                                    body: {
                                      'wstoken': userToken['token']
                                    }).then((var value) {
                                  // print(value.body);
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
                    // CustomRichText(
                    //   discription: "Don't already Have an account? ",
                    //   text: "Sign Up",
                    //   onTap: () {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const RegistrationScreen()));
                    //   },
                    // ),
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
