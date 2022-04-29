import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/notices/notice_collection_students.dart';

import '../../widgets/bottom_navigation_bar.dart';

///This page is for student so that they can select specific year for them to see notice

class YearPageStudents extends StatefulWidget {
  const YearPageStudents({Key key}) : super(key: key);

  @override
  State<YearPageStudents> createState() => _YearPageStudentsState();
}

class _YearPageStudentsState extends State<YearPageStudents> {
  List<String> selectedYears = [];

  @override
  void initState() {
    super.initState();
    selectedYears = <String>[
      'First Year',
      'Second Year',
      'Third Year',
      'Fourth Year',
    ];
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 8, 30, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          onPrimary: Colors.white,
          shadowColor: Colors.red,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            // side: BorderSide(color: Colors.red),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              //add route
              return NoticeForStudents(selectedYear: selectedYears[index]);
            }),
          );
        },
        child: Center(
          child: Text(
            selectedYears[index],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  BottomNavigationWidget(),

      // backgroundColor: Color(0xFFA0F0F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF980F58),
        title: const Text(
          'Select Years...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F5C8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: selectedYears.length,
            itemBuilder: _getListItemTile,
          ),
        ],
      ),
    );
  }
}
