import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class Year {
  String year;

  ///years
  bool check;

  ///to check which year selected by the admin to show the notice
  Year({this.year, this.check});
}

List<Year> yearsList = <Year>[
  Year(year: 'First Year', check: false),
  Year(year: 'second Year', check: false),
  Year(year: 'Third year', check: false),
  Year(year: 'Fourth Year', check: false),
];
