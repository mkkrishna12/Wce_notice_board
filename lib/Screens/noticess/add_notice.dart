import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/notice_input_button.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_collection.dart';

// Page for to add notice
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class AddNotice extends StatefulWidget {
  const AddNotice({Key key, this.years, this.notice, this.endDate})
      : super(key: key);
  final List<bool> years;
  final NoticeForListing notice;
  final DateTime endDate;
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  dynamic firebaseUser;
  String title = "";
  String notice = "";
  String from = "";
  DateTime dateNow = DateTime.now();

  @override
  void initState() {
    super.initState();
    title = (widget.notice == null) ? null : widget.notice.noticeTitle;
    notice = (widget.notice == null) ? null : widget.notice.noticeContent;
    from = (widget.notice == null) ? null : widget.notice.noticeRegard;
    dateNow = (widget.notice == null) ? null : widget.notice.noticeCreated;
    firebaseUser = _firebaseAuth.currentUser;
  }

  bool spinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.notice == null) ? 'Create Notice..' : 'Update Notice..',
        ),
        backgroundColor: Colors.blue,
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              NoticeInput(
                initialValue: title,
                hintText: 'Enter title for notice',
                flex: 0.1,
                onChanged: (value) {
                  if (!mounted) return;
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
              NoticeInput(
                initialValue: notice,
                hintText: 'Enter notice',
                flex: 0.53,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    notice = value;
                    TextEditingController().value;
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              NoticeInput(
                initialValue: from,
                hintText: 'Enter faculty or branch',
                flex: 0.1,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    from = value;
                    TextEditingController().value;
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text(
                    'Add Notice',
                  ),
                  onPressed: () {
                    spinner = true;
                    if (widget.notice == null) {
                      _fireStore.collection("Notices").add({
                        "FacultyId": firebaseUser.uid,
                        "NoticeTitle": title,
                        "Noticecontent": notice,
                        "NoticeRegards": from,
                        "NoticeCreated": (dateNow == null)
                            ? FieldValue.serverTimestamp()
                            : dateNow,
                        "NoticeUpdated": FieldValue.serverTimestamp(),
                        "NoticeEndDate": widget.endDate,
                        "FirstYear": widget.years[0],
                        "SecondYear": widget.years[1],
                        "ThirdYear": widget.years[2],
                        "LastYear": widget.years[3],
                      }).then((value) {
                        spinner = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const NoticeList(),
                          ),
                          (route) => false,
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const PopUp(
                            toNavigate: NoticeList(
                              userType: 'admin',
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
                          builder: (BuildContext context) => const PopUp(
                            toNavigate: null,
                            message:
                                'Something went Wrong. Please try again...',
                            icon: Icons.cancel,
                            state: false,
                            color: Colors.red,
                          ),
                        );
                      });
                    } else {
                      _fireStore
                          .collection("Notices")
                          .doc(widget.notice.noticeId)
                          .update({
                            "FacultyId": firebaseUser.uid,
                            "NoticeTitle": title,
                            "Noticecontent": notice,
                            "NoticeRegards": from,
                            "NoticeCreated": (dateNow == null)
                                ? FieldValue.serverTimestamp()
                                : dateNow,
                            "NoticeUpdated": FieldValue.serverTimestamp(),
                            "NoticeEndDate": widget.endDate,
                            "FirstYear": widget.years[0],
                            "SecondYear": widget.years[1],
                            "ThirdYear": widget.years[2],
                            "LastYear": widget.years[3],
                          })
                          .then((value) => showDialog(
                                context: context,
                                builder: (BuildContext context) => const PopUp(
                                  toNavigate: NoticeList(userType: 'Admin'),
                                  message: 'Notice Updated',
                                  icon: Icons.check,
                                  state: true,
                                  color: Colors.green,
                                ),
                              ))
                          .catchError((onError) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => const PopUp(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
