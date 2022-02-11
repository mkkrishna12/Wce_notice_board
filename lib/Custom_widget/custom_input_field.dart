import 'package:flutter/material.dart';
// this is customised widget for taking input from user
class CustomInputField extends StatefulWidget {
  const CustomInputField({Key key, this.fieldIcon, this.hintText, this.onChanged})
      : super(key: key);
  final Icon fieldIcon;
  final String hintText;
  final Function onChanged;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    if (widget.hintText == 'Enter Password') {
      secure = true;
    }
    return SizedBox(
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
