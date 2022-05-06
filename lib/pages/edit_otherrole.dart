import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../user/user_data.dart';
import '../widgets/appbar_widget.dart';

class OtherRol extends StatefulWidget {
  const OtherRol({Key key}) : super(key: key);

  @override
  _OtherRolState createState() => _OtherRolState();
}

class _OtherRolState extends State<OtherRol> {
  var user = UserData.myUser;
  List<String> Roles = [
    "HOD",
    "FY ClassTeacher",
    "SY ClassTeacher",
    "TY ClassTeacher",
    "BTECH ClassTeacher",
    "Teacher",
    "DCOE",
  ];

  String _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:buildAppBar(context),
      backgroundColor: const Color(0xFFFEF1E6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Container(
              margin: EdgeInsets.all(20),
              width: 320,
              child: Text(
                "What's Your Role in college?",
                style:
                TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 80),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  user.otherrole = value;
                  _selectedColor = value;
                });
              },
              value: _selectedColor,

              // Hide the default underline
              underline: Container(),
              hint: Center(
                  child: Text(
                    'Select the Role',
                    style: TextStyle(color: Colors.white),
                  )),
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.yellow,
              ),
              isExpanded: true,

              // The list of options
              items: Roles
                  .map((e) => DropdownMenuItem(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                value: e,
              ))
                  .toList(),

              // Customize the selected item
              selectedItemBuilder: (BuildContext context) => Roles
                  .map((e) => Center(
                child: Text(
                  e,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.amber,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ))
                  .toList(),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (user.otherrole.isNotEmpty) {
                          // updateUserValue(phoneController.text);
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
    );
  }
}

//TODO : If required use below code
// // This class handles the Page to edit the Name Section of the User Profile.
// class EditOtherRoleFormPage extends StatefulWidget {
//   const EditOtherRoleFormPage({Key key}) : super(key: key);
//
//   @override
//   EditOtherRoleFormPageState createState() {
//     return EditOtherRoleFormPageState();
//   }
// }
//
// class EditOtherRoleFormPageState extends State<EditOtherRoleFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final otherNameController = TextEditingController();
//
//   var user = UserData.myUser;
//
//   @override
//   void dispose() {
//     otherNameController.dispose();
//     super.dispose();
//   }
//
//   void updateUserValue(String name) {
//     user.otherrole = name;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: buildAppBar(context),
//         body: Form(
//           key: _formKey,
//           child: Container(
//             color: const Color(0xFFFEF1E6),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 const SizedBox(
//                     width: 330,
//                     child: Text(
//                       "What's Your Role?",
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
//                         child: SizedBox(
//                             height: 100,
//                             width: 150,
//                             child: TextFormField(
//                               // Handles Form Validation for First Name
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your role';
//                                 } else if (!isAlpha(value)) {
//                                   return 'Only Letters Please';
//                                 }
//                                 return null;
//                               },
//                               decoration:
//                                   const InputDecoration(labelText: 'Role'),
//                               controller: otherNameController,
//                             ))),
//                     // Padding(
//                     //     padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
//                     //     child: SizedBox(
//                     //         height: 100,
//                     //         width: 150,
//                     //         child: TextFormField(
//                     //           // Handles Form Validation for Last Name
//                     //           validator: (value) {
//                     //             if (value == null || value.isEmpty) {
//                     //               return 'Please enter your last name';
//                     //             } else if (!isAlpha(value)) {
//                     //               return 'Only Letters Please';
//                     //             }
//                     //             return null;
//                     //           },
//                     //           decoration:
//                     //               const InputDecoration(labelText: 'Last Name'),
//                     //           controller: secondNameController,
//                     //         )))
//                   ],
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.only(top: 150),
//                     child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: SizedBox(
//                           width: 330,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Validate returns true if the form is valid, or false otherwise.
//                               if (_formKey.currentState.validate() &&
//                                   isAlpha(otherNameController.text)) {
//                                 updateUserValue(otherNameController.text + " ");
//                                 Navigator.pop(context);
//                               }
//                             },
//                             child: const Text(
//                               'Update',
//                               style: TextStyle(fontSize: 15),
//                             ),
//                           ),
//                         )))
//               ],
//             ),
//           ),
//         ));
//   }
// }
