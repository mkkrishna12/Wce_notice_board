
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class noticeInput extends StatefulWidget {
  // const notice_input({Key? key}) : super(key: key);
  noticeInput({this.hintText, this.onChanged, this.flex,this.initialValue});
  String hintText;
  Function onChanged;
  int flex;
  String initialValue=null;
  @override
  _noticeInputState createState() => _noticeInputState();
}

class _noticeInputState extends State<noticeInput> {
  TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller= (widget.initialValue!=null)? TextEditingController(text: widget.initialValue):null;
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Colors.grey,
        child: Container(
          margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          width: double.infinity,

          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              showCursor: true,
              textDirection: TextDirection.ltr,
              controller:_controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 17.5,
                ),
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
    );
  }
}
