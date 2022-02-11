// this page is for year selection for the user

import 'package:flutter/material.dart';
import 'package:wce_notice_board/constants.dart';

class SelectYear extends StatefulWidget {
  const SelectYear({Key key}) : super(key: key);

  @override
  _SelectYearState createState() => _SelectYearState();
}

class _SelectYearState extends State<SelectYear> {

  @override
  Widget build(BuildContext context) => ListView(
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
  );
}
