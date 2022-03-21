import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VeiwStudents extends StatefulWidget {
  const VeiwStudents({Key key, this.lst, this.noticeId}) : super(key: key);
  final String noticeId;
  final List lst;
  @override
  State<VeiwStudents> createState() => _VeiwStudentsState();
}

class _VeiwStudentsState extends State<VeiwStudents> {
  List<String> students = [
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
    'Check',
  ];
  @override
  void initState() {
    // TODO: Fetch the list of students here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: widget.lst.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    widget.lst[index],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    //   ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: students.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       title: Center(child: Text(students[index])),
    //       onTap: () {
    //         Navigator.pop(context, students[index]);
    //       },
    //     );
    //   },
    // );
  }
}
