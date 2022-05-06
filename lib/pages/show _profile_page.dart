//TODO : use it to how the profile seperately
import 'package:flutter/material.dart';

class ShowProfilePage extends StatefulWidget {
  const ShowProfilePage({Key key}) : super(key: key);

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  var _image;
  final String facultyName='Krishna Mali',department = "Acm Tech Lead",desiganation = "Student",mobile="98343718236";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("User Profile",),
      ),
      backgroundColor: Color(0xFFF5DEB3),
      body: Column(
        children: [

          Container(

            height: MediaQuery.of(context).size.height*0.65,
            width: MediaQuery.of(context).size.width*1,
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius. circular(10),
          ),
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment:
                    Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        bottom: 5, left: 10),
                    child: Text(
                      'FacultyName',
                      style:
                      TextStyle(
                        color: const Color(
                            0xFF100689),
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin:
                    EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      // color: const Color(
                      //     0xFFC2E3FE),
                      borderRadius:
                      BorderRadius
                          .circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12, width: 3),
                          ),
                        ),
                        child: Text(
                          "$facultyName",
                          style:
                          TextStyle(
                            color: const Color(
                                0xFF100689),
                            fontSize: 15,
                            // fontWeight:
                            // FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment:
                    Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        bottom: 5, left: 10),
                    child: Text(
                      'FacultyName',
                      style:
                      TextStyle(
                        color: const Color(
                            0xFF100689),
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin:
                    EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      // color: const Color(
                      //     0xFFC2E3FE),
                      borderRadius:
                      BorderRadius
                          .circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment:
                    Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        bottom: 5, left: 10),
                    child: Text(
                      'FacultyName',
                      style:
                      TextStyle(
                        color: const Color(
                            0xFF100689),
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin:
                    EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      // color: const Color(
                      //     0xFFC2E3FE),
                      borderRadius:
                      BorderRadius
                          .circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment:
                    Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        bottom: 5, left: 10),
                    child: Text(
                      'FacultyName',
                      style:
                      TextStyle(
                        color: const Color(
                            0xFF100689),
                        fontSize: 15,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin:
                    EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      // color: const Color(
                      //     0xFFC2E3FE),
                      borderRadius:
                      BorderRadius
                          .circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // decoration: BoxDecoration(
              //   color: Color(0xFFF5DEB3),
              //   borderRadius: BorderRadius.only(
              //     topLeft:  Radius.circular(50),
              //     topRight: Radius.circular(50),
              //     bottomLeft:  Radius.circular(50),
              //     bottomRight: Radius.circular(50),
              //
              //   )
              // ),
            ),
          )
        ],
      ),
    ));
  }
}
