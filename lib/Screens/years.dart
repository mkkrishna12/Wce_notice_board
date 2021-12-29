import 'package:flutter/material.dart';
// import 'package:wce_notice_board/Custom_widget/year_Class.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/Add_notice.dart';

class year {
  String s;
  bool check;
  year({this.s, this.check});
}

class yearPage extends StatefulWidget {
  // const yearPage({Key? key}) : super(key: key);
  final String noticeId;
  yearPage({this.noticeId});

  @override
  State<yearPage> createState() => _yearPageState();
}

class _yearPageState extends State<yearPage> {
  final List<year> _items = <year>[
    year(s: 'First Year', check: false),
    year(s: 'second Year', check: false),
    year(s: 'Third year', check: false),
    year(s: 'Fourth Year', check: false),
  ];
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
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return addNotice(years : [_items[0].check,_items[1].check,_items[2].check,_items[3].check]);
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

class SelectYear extends StatefulWidget {
  const SelectYear({Key key}) : super(key: key);

  @override
  _SelectYearState createState() => _SelectYearState();
}

class _SelectYearState extends State<SelectYear> {
  final List<year> _items = <year>[
    year(s: 'First Year', check: false),
    year(s: 'second Year', check: false),
    year(s: 'Third year', check: false),
    year(s: 'Fourth Year', check: false),
  ];
  @override
  Widget build(BuildContext context) => ListView(
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
      );
}
