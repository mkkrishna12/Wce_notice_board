import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/notice_input_button.dart';
import 'package:wce_notice_board/Screens/notices/notice_collection.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// widget  to add notice and update notice for admin

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class AddNotice extends StatefulWidget {
  const AddNotice({Key key, this.years, this.notice, this.endDate})
      : super(key: key);
  final List<bool> years; //This is required to add data in the database
  final NoticeForListing notice; //If we want update existing notice
  final DateTime endDate; //This will be end date of notice

  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  dynamic firebaseUser; //instance of the user from the database
  String title; //Title of the notice
  String notice; //Notice Content
  String from; //Notice Regard
  DateTime dateNow = DateTime.now(); //end date of the notice
  SnackBar snackBar;

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
  String ans = "No file selected";
  FilePickerResult path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.notice == null) ? 'Create Notice..' : 'Update Notice..',
        ),
        backgroundColor: Colors.brown,
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
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(ans),
              ),
              ElevatedButton(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          IconData(
                            0xf05d,
                            fontFamily: 'MaterialIcons',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Upload Document',
                        )
                      ],
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                onPressed: () async {

                  setState(() async{
                    //
                    path =  await FilePicker.platform.pickFiles();
                    setState(() {
                      ans = path.files.first.name.toString();
                    });

                    // ans = file.path.toString();
                    //firebase_storage.UploadTask task = await uploadFile(file);
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(60.0),
                ),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  child: (widget.notice == null)
                      ? const Text(
                          'Add Notice',
                        )
                      : const Text(
                          'Update Notice',
                        ),
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      spinner = true;
                    });
                    final Map<String, dynamic> isSeen = {};
                    if (widget.notice == null) {
                      if (path == null) {
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
                          "isSeen": isSeen,
                          "isPersonalised": false,
                          "isPersonalisedArray": [""]
                        }).then((value) {
                          spinner = false;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const NoticeList(isAdded: true),
                            ),
                            (route) => false,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Notice Added',
                            ),
                          ));
                        }).catchError((onError) {
                          if (!mounted) return;
                          setState(() {
                            spinner = false;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Something went Wrong. Please try again...',
                            ),
                          ));
                        });
                      } else {
                        FirebaseStorage.instance
                            .ref('uploads/${path.files.first.name}')
                            .putData(path.files.first.bytes)
                            .then((fileid) {
                              setState(() {
                                ans = fileid.toString();
                              });
                          // _fireStore.collection("Notices").add({
                          //   "FacultyId": firebaseUser.uid,
                          //   "NoticeTitle": title,
                          //   "Noticecontent": notice,
                          //   "NoticeRegards": from,
                          //   "NoticeCreated": (dateNow == null)
                          //       ? FieldValue.serverTimestamp()
                          //       : dateNow,
                          //   "NoticeUpdated": FieldValue.serverTimestamp(),
                          //   "NoticeEndDate": widget.endDate,
                          //   "FirstYear": widget.years[0],
                          //   "SecondYear": widget.years[1],
                          //   "ThirdYear": widget.years[2],
                          //   "LastYear": widget.years[3],
                          //   "isSeen": isSeen,
                          //   "isPersonalised": false,
                          //   "isPersonalisedArray": [""]
                          // }).then((value) {
                          //   spinner = false;
                          //   Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (BuildContext context) =>
                          //           const NoticeList(isAdded: true),
                          //     ),
                          //     (route) => false,
                          //   );
                          //
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       'Notice Added',
                          //     ),
                          //   ));
                          // }).catchError((onError) {
                          //   if (!mounted) return;
                          //   setState(() {
                          //     spinner = false;
                          //   });
                          //
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       'Something went Wrong. Please try again...',
                          //     ),
                          //   ));
                          // });
                        }).catchError((onError) {
                          if (!mounted) return;
                          setState(() {
                            spinner = false;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Something went Wrong. Please try again...',
                            ),
                          ));
                        });
                      }
                    } else {
                      //We will call this when we want to update the notice

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
                        "isSeen": isSeen,
                        "isPersonalised": false,
                        "isPersonalisedArray": [""]
                      }).then((value) {
                        spinner = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const NoticeList(isAdded: true),
                          ),
                          (route) => false,
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Notice Updated',
                          ),
                        ));
                      }).catchError((onError) {
                        if (!mounted) return;
                        setState(() {
                          spinner = false;
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Something went Wrong. Please try again...'),
                        ));
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

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putData(fileBytes);
    }
  }
}
