import 'package:flutter/material.dart';

class noteModify extends StatelessWidget {
  // const noteModify({Key? key}) : super(key: key);
  final String noteId;
  noteModify({ this.noteId='\0'});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(noteId=='\0' ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: 'Note title'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: 'Note content'),
            ),
            Container(
              height: 35.0,
              width: double.infinity,
              child: RaisedButton(

                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
