import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
class Year {
  String s;     //years
  bool check;  //to check which year selected by the admin to show the notice
  Year({this.s, this.check});
}
List<Year> yearsList = <Year>[
  Year(s: 'First Year', check: false),
  Year(s: 'second Year', check: false),
  Year(s: 'Third year', check: false),
  Year(s: 'Fourth Year', check: false),
];

