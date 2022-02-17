import 'package:flutter/material.dart';

//This widget is customised button
class RoundedButton extends StatelessWidget {
  const RoundedButton({Key key, this.colour, this.title, this.onPressed})
      : super(key: key);
  final Color colour;     // Background color of the button
  final String title;     //Button title
  final Function onPressed; //The Function that will will be invoked after pressing the button
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
