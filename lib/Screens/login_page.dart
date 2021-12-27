import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';

import '../Custom_widget/custom_Input_field.dart';
import 'registration_page.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String email = null;
  bool spinner = false;
  String password = null;
  String user = "User";
  String Mobile = null;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            const Align(
              alignment: Alignment.bottomRight,
              widthFactor: 0.6,
              heightFactor: 0.4,
              child: Material(
                borderRadius: BorderRadius.all(
                  Radius.circular(200),
                ),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: SizedBox(
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
                            const BorderRadius.all(Radius.circular(50.0)),
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
                      fieldIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: 'Enter email',
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    customInputField(
                      fieldIcon: const Icon(Icons.lock, color: Colors.white),
                      hintText: 'Enter Password',
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    // Container(
                    //   height: 40,
                    //   width: 150,
                    //   child: RaisedButton(
                    //     onPressed: () {},
                    //     color: Colors.brown,
                    //     textColor: Colors.white,
                    //     shape: const RoundedRectangleBorder(
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(10.0))),
                    //     child: const Text(
                    //       'Login',
                    //       style: TextStyle(fontSize: 20.0),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            spinner = true;
                          });
                          if (email == null || password == null) {
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
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            )
                                .then((value) {
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
                                    builder: (BuildContext context) => PopUp(
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
                                    builder: (BuildContext context) => PopUp(
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
                                    builder: (BuildContext context) => PopUp(
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
                        color: Colors.brown,
                        textColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: const Text(
                          'Login ',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New To Wce notice board',
                        ),
                        const SizedBox(width: 15.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const RegistrationScreen();
                            }));
                          },
                          child: const Text(
                            'Register',
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
  }
}
