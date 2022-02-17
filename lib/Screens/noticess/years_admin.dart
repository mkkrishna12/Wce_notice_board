import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Screens/noticess/add_notice.dart';
import 'package:wce_notice_board/constants.dart';
import 'package:wce_notice_board/utils/constants.dart';
//On this page we can add and edit the year and the date for deleting the notice

class YearPage extends StatefulWidget {
  final NoticeForListing notice;

  const YearPage({Key key, this.notice}) : super(key: key);

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  DateTime selectedDate = DateTime.now();

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
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021), // Required
      lastDate: DateTime(2025), // Required
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Select Date',
      cancelText: 'Not now',
      confirmText: 'Book',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.notice != null) {
      yearsList = <Year>[
        Year(s: 'First Year', check: widget.notice.fy),
        Year(s: 'second Year', check: widget.notice.sy),
        Year(s: 'Third year', check: widget.notice.ty),
        Year(s: 'Fourth Year', check: widget.notice.btech),
      ];
      selectedDate = widget.notice.noticeEndDate;
    }else{
      yearsList = <Year>[
        Year(s: 'First Year', check: false),
        Year(s: 'second Year', check: false),
        Year(s: 'Third year', check: false),
        Year(s: 'Fourth Year', check: false),
      ];
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: yearsList
                .map(
                  (Year item) => CheckboxListTile(
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
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, 1), // Refer step 3
                  child: Text(
                    '$selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddNotice(
                      years: [
                        yearsList[0].check,
                        yearsList[1].check,
                        yearsList[2].check,
                        yearsList[3].check
                      ],
                      notice: widget.notice,
                      endDate: selectedDate,
                    );
                  }),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
