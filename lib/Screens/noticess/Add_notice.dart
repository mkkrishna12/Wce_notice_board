import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/notice_input_button.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class addNotice extends StatefulWidget {
  addNotice({this.years, this.notice, this.EndDate});
  final List<bool> years;
  noticeForListing notice;
  DateTime EndDate;
  @override
  _addNoticeState createState() => _addNoticeState();
}

class _addNoticeState extends State<addNotice> {
  var firebaseUser;
  String title;
  String Notice;
  String from;
  DateTime DateNow;

  @override
  void initState() {
    super.initState();
    title = (widget.notice == null) ? null : widget.notice.NoticeTitle;
    Notice = (widget.notice == null) ? null : widget.notice.Noticecontent;
    from = (widget.notice == null) ? null : widget.notice.NoticeRegard;
    DateNow = (widget.notice == null) ? null : widget.notice.NoticeCreated;
    firebaseUser = _firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.notice == null) ? 'Create Notice..' : 'Update Notice..',
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          noticeInput(
            initialValue: title,
            hintText: 'Enter title for notice',
            flex: 1,
            onChanged: (value) {
              setState(() {
                title = value;
                TextEditingController().value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          noticeInput(
            initialValue: Notice,
            hintText: 'Enter notice',
            flex: 5,
            onChanged: (value) {
              setState(() {
                Notice = value;
                TextEditingController().value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          noticeInput(
            initialValue: from,
            hintText: 'Enter faculty or branch',
            flex: 1,
            onChanged: (value) {
              setState(() {
                from =value;
                TextEditingController().value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              height: 30.0,
              width: double.infinity,
              child: FlatButton(
                child: Text('Add Notice'),
                onPressed: () {
                  if (widget.notice == null) {
                    _fireStore.collection("Notices").add({
                      "FacultyId": firebaseUser.uid,
                      "NoticeTitle": title,
                      "Noticecontent": Notice,
                      "NoticeRegards": from,
                      "NoticeCreated": (DateNow == null)
                          ? FieldValue.serverTimestamp()
                          : DateNow,
                      "NoticeUpdated": FieldValue.serverTimestamp(),
                      "NoticeEndDate": widget.EndDate,
                      "FirstYear": widget.years[0],
                      "SecondYear": widget.years[1],
                      "ThirdYear": widget.years[2],
                      "LastYear": widget.years[3],
                    }).then((value) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => noticeList(),
                        ),
                            (route) => false,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PopUp(
                          toNavigate: noticeList(
                            UserType: 'admin',
                          ),
                          message: 'Notice Added',
                          icon: Icons.check,
                          state: true,
                          color: Colors.green,
                        ),
                      );
                    }).catchError((onError) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PopUp(
                          toNavigate: null,
                          message: 'Something went Wrong. Please try again...',
                          icon: Icons.cancel,
                          state: false,
                          color: Colors.red,
                        ),
                      );
                    });
                  } else {
                    _fireStore
                        .collection("Notices")
                        .doc(widget.notice.NoticeId)
                        .update({
                          "FacultyId": firebaseUser.uid,
                          "NoticeTitle": title,
                          "Noticecontent": Notice,
                          "NoticeRegards": from,
                          "NoticeCreated": (DateNow == null)
                              ? FieldValue.serverTimestamp()
                              : DateNow,
                          "NoticeUpdated": FieldValue.serverTimestamp(),
                          "NoticeEndDate": widget.EndDate,
                          "FirstYear": widget.years[0],
                          "SecondYear": widget.years[1],
                          "ThirdYear": widget.years[2],
                          "LastYear": widget.years[3],
                        })
                        .then((value) => showDialog(
                              context: context,
                              builder: (BuildContext context) => PopUp(
                                toNavigate: noticeList(UserType: 'Admin'),
                                message: 'Notice Updated',
                                icon: Icons.check,
                                state: true,
                                color: Colors.green,
                              ),
                            ))
                        .catchError((onError) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PopUp(
                              toNavigate: null,
                              message:
                                  'Something went Wrong. Please try again...',
                              icon: Icons.cancel,
                              state: false,
                              color: Colors.red,
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
