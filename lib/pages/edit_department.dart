import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../user/user_data.dart';
import '../widgets/appbar_widget.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditDepartmentFormPage extends StatefulWidget {
  const EditDepartmentFormPage({Key key}) : super(key: key);

  @override
  EditDepartmentFormPageState createState() {
    return EditDepartmentFormPageState();
  }
}

class EditDepartmentFormPageState extends State<EditDepartmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final departmentNameController = TextEditingController();

  var user = UserData.myUser;

  @override
  void dispose() {
    departmentNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.department = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: buildAppBar(context),
        body: Form(

          key: _formKey,
          child: Container(
            color: const Color(0xFFFEF1E6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                    width: 330,
                    child: Text(
                      "What's Your Department?",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                        child: SizedBox(
                            height: 100,
                            width: 150,
                            child: TextFormField(
                              // Handles Form Validation for First Name
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your department name';
                                } else if (!isAlpha(value)) {
                                  return 'Only Letters Please';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Department Name'),
                              controller: departmentNameController,
                            ))),
                    // Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                    //     child: SizedBox(
                    //         height: 100,
                    //         width: 150,
                    //         child: TextFormField(
                    //           // Handles Form Validation for Last Name
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Please enter your last name';
                    //             } else if (!isAlpha(value)) {
                    //               return 'Only Letters Please';
                    //             }
                    //             return null;
                    //           },
                    //           decoration:
                    //               const InputDecoration(labelText: 'Last Name'),
                    //           controller: secondNameController,
                    //         )))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 330,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState.validate() &&
                                  isAlpha(departmentNameController.text)) {
                                updateUserValue(
                                    departmentNameController.text + " ");
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ],
            ),
          ),
        ));
  }
}
