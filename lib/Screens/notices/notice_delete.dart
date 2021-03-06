import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  NoteDelete(this.noticeId, {Key key}) : super(key: key);
  final String noticeId;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Warning',
      ),
      content: const Text(
        'Are you sure want to delete this note ? ',
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _fireStore.collection('Notices').doc(noticeId).delete().then((val) {
              Navigator.pop(context);
            }).catchError(
              (error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              },
            );
          },
          child: const Text(
            'Yes',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            'No',
          ),
        ),
      ],
    );
  }
}
