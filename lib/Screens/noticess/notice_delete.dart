import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  const NoteDelete({Key  key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //Todo MAke notice card circular
      child: AlertDialog(
        title: const Text('Warning',),
        content: const Text('Are you sure want to delete this note ? ',),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes',),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No',),
          ),
        ],
      ),
    );
  }
}
