import 'package:flutter/material.dart';
//This is for taking input from admin to add notice

class NoticeInput extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const NoticeInput(
      {this.hintText, this.onChanged, this.flex, this.initialValue});
  final String hintText;
  final Function onChanged;
  final double flex; // We will require more space for notice content
  final String
      initialValue; // if we are editing exiting then we have to show previous data
  @override
  _NoticeInputState createState() => _NoticeInputState();
}

class _NoticeInputState extends State<NoticeInput> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = (widget.initialValue != null)
        ? TextEditingController(text: widget.initialValue)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * widget.flex,
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Colors.grey,
        child: Container(
          margin: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
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
              keyboardType: TextInputType.multiline,
              maxLines: 10000,
              showCursor: true,
              textDirection: TextDirection.ltr,
              controller: _controller,
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
