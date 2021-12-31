import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/year_selection.dart';
import 'package:wce_notice_board/Screens/noticess/Add_notice.dart';



class yearPage extends StatefulWidget {
  noticeForListing notice;

  yearPage({Key key, this.notice}) : super(key: key);

  @override
  State<yearPage> createState() => _yearPageState();
}

class _yearPageState extends State<yearPage> {
  DateTime selectedDate = DateTime.now();

  List<year> _items = <year>[
    year(s: 'First Year', check: false),
    year(s: 'second Year', check: false),
    year(s: 'Third year', check: false),
    year(s: 'Fourth Year', check: false),
  ];

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  _selectDate(BuildContext context, int select) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
           selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    showDatePicker(
      context: context,
      initialDate: selectedDate ,
      firstDate: DateTime(2021), // Required
      lastDate: DateTime(2025), // Required
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Select Date',
      cancelText: 'Not now',
      confirmText: 'Book',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',

    );
    if (picked != null && picked != selectedDate ) {
      setState(() {
          selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.notice != null) {
      _items = <year>[
        year(s: 'First Year', check: widget.notice.fy),
        year(s: 'second Year', check: widget.notice.sy),
        year(s: 'Third year', check: widget.notice.ty),
        year(s: 'Fourth Year', check: widget.notice.btech),
      ];
      selectedDate = widget.notice.NoticeEndDate;
    }
    // _selectDate(context);
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
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: _items
                  .map(
                    (year item) => CheckboxListTile(
                      title: Text(item.s),
                      value: item.check,
                      onChanged: (bool val) {
                        setState(() => item.check = val);
                      },
                    ),
                  )
                  .toList(),
            ),
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Select End Dates : ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _selectDate(context, 1), // Refer step 3
                    child: Text(
                      '$selectedDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return addNotice(years: [
                        _items[0].check,
                        _items[1].check,
                        _items[2].check,
                        _items[3].check
                      ], notice: widget.notice,EndDate: selectedDate,);
                    }),
                  );
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
