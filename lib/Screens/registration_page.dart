import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import '../Custom_widget/custom_Input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = null;
  bool spinner = false;
  String password = null;
  String user = "User";
  String Mobile = null;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                widthFactor: 0.6,
                heightFactor: 0.4,
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  color: const Color.fromRGBO(255, 255, 255, 0.4),
                  child: Container(
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                          color: Colors.blue,
                          elevation: 10.0,
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/wce-logo.png',
                              // width: 80,
                              // height: 80,
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                        width: double.infinity,
                      ),
                      customInputField(
                        fieldIcon:
                            const Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter college email id ',
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            print(email);
                          });
                        },
                      ),
                      customInputField(
                        fieldIcon:
                            const Icon(Icons.phone, color: Colors.white),
                        hintText: 'Enter Mobile Number',
                        onChanged: (value) {
                          setState(() {
                            Mobile = value;
                          });
                        },
                      ),
                      customInputField(
                        fieldIcon:
                            const Icon(Icons.lock, color: Colors.white),
                        hintText: 'Enter Password',
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              spinner = true;
                            });
                            if (email == null ||
                                password == null ||
                                Mobile == null) {
                              setState(() {
                                spinner = false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => PopUp(
                                  message: 'All Fields are Requried',
                                  icon: Icons.cancel,
                                  state: false,
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              _firebaseAuth
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then((value) {
                                print("Hooo");
                                print(value.user.uid);
                                _fireStore
                                    .collection('users')
                                    .doc(value.user.uid)
                                    .set({
                                  "uid": value.user.uid,
                                  "email": email,
                                  "phoneNumber": Mobile,
                                  "Role": user,
                                  "date": FieldValue.serverTimestamp(),
                                }).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return loginPage();
                                      },
                                    ),
                                  );
                                  setState(() {
                                    spinner = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => PopUp(
                                      message: 'Successfully Registered',
                                      icon: FontAwesomeIcons.checkCircle,
                                      state: true,
                                      color: Colors.green,
                                    ),
                                  );
                                }).catchError((err) {
                                  setState(() {
                                    spinner = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => PopUp(
                                      message:
                                          'Registeration unsuccessful contact to admin',
                                      icon: Icons.cancel,
                                      state: false,
                                      color: Colors.red,
                                    ),
                                  );
                                });
                              }).catchError(
                                (err) {
                                  // weak password

                                  if (err.code == 'weak-password') {
                                    setState(() {
                                      spinner = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          PopUp(
                                        message:
                                            'The password provided is too weak.',
                                        icon: Icons.cancel,
                                        state: false,
                                        color: Colors.red,
                                      ),
                                    );
                                    print('');
                                  }

                                  // email already in use

                                  else if (err.code ==
                                      'email-already-in-use') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return loginPage();
                                        },
                                      ),
                                    );
                                    setState(() {
                                      spinner = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          PopUp(
                                        message:
                                            'The account already exists for that email.',
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
                                          PopUp(
                                        message: 'invalid-email Try Again',
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
                          color: Colors.brown,
                          textColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: const Text(
                            'Registration',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already Have a Account ',
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return loginPage();
                              }));
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
//
// import '../Custom_widget/RoundedButton.dart';
//
// const kTextFieldDecoration = InputDecoration(
//   hintText: 'Enter a value',
//   hintStyle: TextStyle(color: Colors.grey),
//   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
// );
//
// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _auth = FirebaseAuth.instance;
//   String email;
//   String password;
//   bool showSpinner = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextField(
//                   keyboardType: TextInputType.emailAddress,
//                   textAlign: TextAlign.center,
//                   onChanged: (value) {
//                     email = value;
//                     //Do something with the user input.
//                   },
//                   decoration: kTextFieldDecoration.copyWith(
//                       hintText: 'Enter your email')),
//               SizedBox(
//                 height: 8.0,
//               ),
//               TextField(
//                   obscureText: true,
//                   textAlign: TextAlign.center,
//                   onChanged: (value) {
//                     password = value;
//                     //Do something with the user input.
//                   },
//                   decoration: kTextFieldDecoration.copyWith(
//                       hintText: 'Enter your Password')),
//               SizedBox(
//                 height: 24.0,
//               ),
//               RoundedButton(
//                 colour: Colors.blueAccent,
//                 title: 'Register',
//                 onPressed: () async {
//                   setState(() {
//                     showSpinner = true;
//                   });
//                   try {
//                     final newUser = await _auth.createUserWithEmailAndPassword(
//                         email: email, password: password);
//                     if (newUser != null) {
//                       Navigator.pushNamed(context, 'home_screen');
//                     }
//                   } catch (e) {
//                     print(e);
//                   }
//                   setState(() {
//                     showSpinner = false;
//                   });
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
