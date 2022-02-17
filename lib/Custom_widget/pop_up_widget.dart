import 'package:flutter/material.dart';

//This page is for showing any alert or any error appeared while fetching data
class PopUp extends StatefulWidget {
  final String message;      //The error or any warning
  final IconData icon;       //right click or incorrect icon according msg will be sent
  final bool state;          // we will according to this variable
  final Color color;         //red for incorrect and green for correct
  final Widget toNavigate;   //this is not require if we want navigate then we can use it for successful working

  @override
  const PopUp({
    Key key,
    @required this.message,
    @required this.icon,
    @required this.state,
    this.color,
    this.toNavigate,
  }) : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.white,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 60.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            if (widget.state == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return widget.toNavigate;
                  },
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Close',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
