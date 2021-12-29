import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/login_page.dart';

class PopUp extends StatefulWidget {
  final String message;
  final IconData icon;
  final bool state;
  final Color color;
  var toNavigate;

  @override
  PopUp(
      {@required this.message,
      @required this.icon,
      @required this.state,
      this.color,
        this.toNavigate

      });

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Icon(
            widget.icon,
                color: widget.color,
                size: 60.0,
          )),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            widget.message,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
          child: Text(
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
