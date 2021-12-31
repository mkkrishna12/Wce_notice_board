import 'package:flutter/material.dart';

class year {
  String s;
  bool check;
  year({this.s, this.check});
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
