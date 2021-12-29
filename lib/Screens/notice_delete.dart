import 'package:flutter/material.dart';

class noteDelete extends StatelessWidget {
  // const noteDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Are you sure want to delete this note ? '),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
