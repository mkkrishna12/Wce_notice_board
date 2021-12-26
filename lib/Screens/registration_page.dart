import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Custom_widget/custom_Input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;

  String password;

  String user = "User";

  String Mobile;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> CheckEmail() async {
    final result = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((data) {
      print(data);
      return data.docs.isEmpty;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: Container(
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 400,
                // height: 440,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Material(
                        color: Colors.blue,
                        elevation: 10.0,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/wce-logo.png',
                            // width: 80,
                            // height: 80,
                          ),
                        )),
                    SizedBox(
                      height: 15,
                      width: double.infinity,
                    ),
                    CustomInputField(
                      fieldIcon: Icon(Icons.person, color: Colors.white),
                      hintText: 'Enter college email id ',
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          print(email);
                        });
                      },
                    ),
                    CustomInputField(
                      fieldIcon: Icon(Icons.phone, color: Colors.white),
                      hintText: 'Enter Mobile Number',
                      onChanged: (value) {
                        setState(() {
                          Mobile = value;
                        });
                      },
                    ),
                    CustomInputField(
                      fieldIcon: Icon(Icons.lock, color: Colors.white),
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
                          print("Hello");
                          CheckEmail().then((value) {
                            print(value);
                            if (value != true) {
                              final _user = _firestore
                                  .collection("users")
                                  .add({
                                    "email": email,
                                    "Mobile": Mobile,
                                    "Password": password,
                                    "Role": user,
                                    "date": FieldValue.serverTimestamp(),
                                  })
                                  .then((value) => print("User added"))
                                  .catchError((erroe) => print(erroe));
                            } else {
                              print("already registered");
                            }
                          }).catchError((error) {});
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
                        Text(
                          'Already Have a Account ',
                        ),
                        SizedBox(width: 15.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return loginPage();
                            }));
                          },
                          child: Text(
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
    );
    ;
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
