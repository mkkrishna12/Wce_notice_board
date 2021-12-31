import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/year_selection.dart';
import 'package:wce_notice_board/Screens/noticess/Add_notice.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection_students.dart';

class YearPageStudents extends StatefulWidget {
  @override
  State<YearPageStudents> createState() => _YearPageStudentsState();
}

class _YearPageStudentsState extends State<YearPageStudents> {
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _items = <String>['First Year', 'Second Year', 'Third Year', 'Fourth Year'];
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context){
              //add route
            return noticeForStudents( selectedYear:_items[index]);
          }),);
        },
        title: Text(_items[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Years...',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: _getListItemTile,
            ),
            // ListView(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.all(8),
            //   children: _items
            //       .map(
            //         (year item) => CheckboxListTile(
            //           title: Text(item.s),
            //           value: item.check,
            //           onChanged: (bool val) {
            //             setState(() => item.check = val);
            //           },
            //         ),
            //       )
            //       .toList(),
            // ),
            // Row(
            //   children: <Widget>[
            //     const Padding(
            //       padding: EdgeInsets.all(10.0),
            //       child: Text(
            //         'Select End Dates : ',
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 10,),
            //     Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: RaisedButton(
            //         onPressed: () => _selectDate(context, 1), // Refer step 3
            //         child: Text(
            //           '$selectedDate.toLocal()}'.split(' ')[0],
            //           style: const TextStyle(
            //               color: Colors.black, fontWeight: FontWeight.bold),
            //         ),
            //         color: Colors.greenAccent,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 10.0,
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) {
            //           return addNotice(years: [
            //             _items[0].check,
            //             _items[1].check,
            //             _items[2].check,
            //             _items[3].check
            //           ], notice: widget.notice,EndDate: selectedDate,);
            //         }),
            //       );
            //     },
            //     child: const Text(
            //       'Update',
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //     color: Colors.blue,
            //     textColor: Colors.white,
            //     elevation: 5,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
