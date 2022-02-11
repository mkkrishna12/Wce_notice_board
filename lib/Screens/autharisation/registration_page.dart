import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import '../../Custom_widget/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email ;
  bool spinner ;
  String password ;
  String user = "User";
  String mobile ;
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
              const Align(
                alignment: Alignment.bottomRight,
                widthFactor: 0.6,
                heightFactor: 0.4,
                child: Material(
                  borderRadius:  BorderRadius.all(Radius.circular(200)),
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  child: SizedBox(
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
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
                              'assets/images/logo.png',
                              width: 150,
                              height: 150,
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                        width: double.infinity,
                      ),
                      CustomInputField(
                        fieldIcon:
                            const Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter college email id ',
                        onChanged: (value) {
                          setState(() {
                            email = value;

                          });
                        },
                      ),
                      CustomInputField(
                        fieldIcon:
                            const Icon(Icons.phone, color: Colors.white),
                        hintText: 'Enter Mobile Number',
                        onChanged: (value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                      ),
                      CustomInputField(
                        fieldIcon:
                            const Icon(Icons.lock, color: Colors.white),
                        hintText: 'Enter Password',
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 40,
                        width: 150,
                        //TODO change to elevated button
                        child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              spinner = true;
                            });
                            if (email == null ||
                                password == null ||
                                mobile == null) {
                              setState(() {
                                spinner = false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => const PopUp(
                                  toNavigate: LoginPage(),
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
                                _fireStore
                                    .collection('users')
                                    .doc(value.user.uid)
                                    .set({
                                  "uid": value.user.uid,
                                  "email": email,
                                  "phoneNumber": mobile,
                                  "Role": 'student',
                                  "date": FieldValue.serverTimestamp(),
                                }).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginPage();
                                      },
                                    ),
                                  );
                                  setState(() {
                                    spinner = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => const PopUp(
                                      toNavigate: LoginPage(),
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
                                    builder: (BuildContext context) => const PopUp(
                                      toNavigate: RegistrationScreen(),
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

                                  if (err.code == 'weak-password') {
                                    setState(() {
                                      spinner = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const PopUp(
                                            toNavigate: RegistrationScreen(),
                                        message:
                                            'The password provided is too weak.',
                                        icon: Icons.cancel,
                                        state: false,
                                        color: Colors.red,
                                      ),
                                    );
                                  }

                                  // email already in use

                                  else if (err.code ==
                                      'email-already-in-use') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginPage();
                                        },
                                      ),
                                    );
                                    setState(() {
                                      spinner = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const PopUp(
                                            toNavigate: LoginPage(),
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
                                          const PopUp(
                                            toNavigate: RegistrationScreen(),
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
                                return const LoginPage();
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
