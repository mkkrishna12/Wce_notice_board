import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';
import 'package:wce_notice_board/Screens/noticess/years_page_students.dart';
import '../../Custom_widget/custom_input_field.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email ;
  bool spinner ;
  String password ;
  String mobile;
  String selectedUser;
  bool admin = false;
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Center(
          child: Stack(
            children: <Widget>[
              const Align(
                alignment: Alignment.bottomRight,
                widthFactor: 0.3,
                heightFactor: 0.2,
                child: Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(200),
                  ),
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  child: SizedBox(
                    width: 200,
                    height: 200,
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
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 140,
                            height: 140,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                        width: double.infinity,
                      ),
                      CustomInputField(
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
                      CustomInputField(
                        fieldIcon: const Icon(Icons.lock, color: Colors.white),
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
                        //TODO WE have to change the buttons to elevated
                        child: RaisedButton(
                          onPressed: () async {
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
                              _firebaseAuth
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then((value) {
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
                                      builder: (BuildContext context) => const PopUp(
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
                                      builder: (BuildContext context) => const PopUp(
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
                                      builder: (BuildContext context) => const PopUp(
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
                      //Option for the new user ot registration
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
      ),
    );
  }
}
