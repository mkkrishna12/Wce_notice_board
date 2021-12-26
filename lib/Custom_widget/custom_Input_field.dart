import 'dart:math';

import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  CustomInputField({this.fieldIcon,this.hintText,this.onChanged});
  Icon fieldIcon;
  String hintText;
  Function onChanged;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    if(widget.hintText == 'Enter Password'){
      secure =true;
    }
    return Container(
      width: 250,
      child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.deepOrange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.fieldIcon,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                width: 200,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: secure,
                    onChanged :widget.onChanged,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        fillColor: Colors.white,
                        filled: true),
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
