import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/notices/notice_collection_students.dart';

///This page is for student so that they can select specific year for them to see notice

class YearPageStudents extends StatefulWidget {
  const YearPageStudents({Key key}) : super(key: key);

  @override
  State<YearPageStudents> createState() => _YearPageStudentsState();
}

class _YearPageStudentsState extends State<YearPageStudents> {
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _items = <String>[
      'First Year',
      'Second Year',
      'Third Year',
      'Fourth Year',
    ];
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              //add route
              return NoticeForStudents(selectedYear: _items[index]);
            }),
          );
        },
        title: Center(child: Text(_items[index])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFA0F0F8),
      appBar: AppBar(
        backgroundColor: Colors.brown,
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
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _items.length,
            itemBuilder: _getListItemTile,
          ),
        ],
      ),
    );
  }
}
