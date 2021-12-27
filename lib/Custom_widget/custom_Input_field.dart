import 'package:flutter/material.dart';

class customInputField extends StatefulWidget {
  customInputField({Key key, this.fieldIcon, this.hintText, this.onChanged})
      : super(key: key);
  Icon fieldIcon;
  String hintText;
  Function onChanged;

  @override
  State<customInputField> createState() => _customInputFieldState();
}

class _customInputFieldState extends State<customInputField> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    if (widget.hintText == 'Enter Password') {
      secure = true;
    }
    return Container(
      width: 250,
      child: Material(
          elevation: 5.0,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Colors.deepOrange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.fieldIcon,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
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
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(fontSize: 17.5,),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
