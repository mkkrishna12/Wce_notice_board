import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import '../../Custom_widget/custom_button.dart';
import '../../Custom_widget/custom_formfield.dart';
import '../../Custom_widget/custom_header.dart';
import '../../Custom_widget/custom_richtext.dart';
import './../../styles/app_colors.dart';
import 'login_page.dart';

///we can use this page when we want to register the user outside the institute in the application

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _mobile = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool spinner = false;

  String user = "User";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /// trim is used for trimming spaces in input
  String get mobile => _mobile.text.trim();

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
                text: 'Sign Up.',
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColors.whiteShade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
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
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Mobile Number",
                      hintText: "Mobile Number",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _mobile,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Email",
                      hintText: "Email",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _passwordController,
                      headingText: "Password",
                      hintText: "At least 8 Character",
                      obsecureText: true,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility), onPressed: () {}),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthButton(
                      onTap: () async {
                        setState(() {
                          spinner = true;
                        });
                        if (email == null ||
                            password == null ||
                            mobile == null) {
                          setState(() {
                            spinner = false;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'All fields are required',
                            ),
                          ));
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registration unsuccessful contact to admin',
                                  ),
                                ),
                              );
                            });
                          }).catchError(
                            (err) {
                              if (err.code == 'weak-password') {
                                setState(() {
                                  spinner = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'The password provided is too weak.')));
                              }

                              /// email already in use

                              else if (err.code == 'email-already-in-use') {
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    'The account already exists for that email.',
                                  ),
                                ));
                              }

                              /// **invalid-email**:

                              else if (err.code == 'invalid-email') {
                                setState(() {
                                  spinner = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    'invalid-email Try Again',
                                  ),
                                ));
                              }
                            },
                          );
                        }
                      },
                      text: 'Sign Up',
                    ),
                    CustomRichText(
                      discription: 'Already Have an account? ',
                      text: 'Log In here',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    )
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
