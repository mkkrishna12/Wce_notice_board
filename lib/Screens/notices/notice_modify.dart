import 'package:flutter/material.dart';

class NoteModify extends StatelessWidget {
  // const noteModify({Key? key}) : super(key: key);
  final String noteId;
  const NoteModify({Key key,  this.noteId = "0"}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(noteId=='0' ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: 'Note title',),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              onChanged: (value) {},
              decoration: const InputDecoration(hintText: 'Note content',),
            ),
            SizedBox(
              height: 35.0,
              width: double.infinity,
              child: ElevatedButton(

                child: const Text('Submit',),
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
