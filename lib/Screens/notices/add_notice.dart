import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/notice_input_button.dart';
import 'package:wce_notice_board/Screens/notices/notice_collection.dart';

import '../../Custom_widget/bottom_navigation_bar.dart';
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
  dynamic url;
  DateTime dateNow = DateTime.now(); //end date of the notice
  SnackBar snackBar;
  bool spinner = false;
  String ans = "No file selected";
  dynamic file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path;
    setState(() {
      file = File(path);
      ans = basename(path);
    });
  }

  @override
  void initState() {
    super.initState();
    title = (widget.notice == null) ? null : widget.notice.noticeTitle;
    notice = (widget.notice == null) ? null : widget.notice.noticeContent;
    from = _firebaseAuth.currentUser.email.split('@')[0];
    dateNow = (widget.notice == null) ? null : widget.notice.noticeCreated;
    url = (widget.notice == null) ? null : widget.notice.file_url;
    firebaseUser = _firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.notice == null) ? 'Create Notice..' : 'Update Notice..',
        ),
        backgroundColor: Colors.brown,
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
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
                onPressed: selectFile,
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
                  onPressed: () async {
                    if (!mounted) return;
                    setState(() {
                      spinner = true;
                    });
                    final Map<String, dynamic> isSeen = {};
                    if (widget.notice == null) {
                      if (file == null) {
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
                          "isPersonalisedArray": [""],
                          "file_url": null,
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
                        final destination = 'Notice_files/$ans';
                        final ref = FirebaseStorage.instance.ref(destination);
                        ref.putFile(file).then((fileid) async {
                          url = await fileid.ref.getDownloadURL();
                          // setState(() {
                          //   ans = url.toString();
                          // });
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
                            "isPersonalisedArray": [""],
                            "file_url": url,
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
                        }).catchError((onError) {
                          if (!mounted) return;
                          setState(() {
                            ans = onError.toString();
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
                      if (file != null) {
                        final destination = 'Notice_files/$ans';
                        final ref = FirebaseStorage.instance.ref(destination);
                        await ref.putFile(file);
                        url = await ref.getDownloadURL();
                      }
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
                        "isPersonalisedArray": [""],
                        "file_url": url,
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
  //
  // Future<firebase_storage.UploadTask> uploadFile(File file) async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null) {
  //     Uint8List fileBytes = result.files.first.bytes;
  //     String fileName = result.files.first.name;
  //
  //     // Upload file
  //     await FirebaseStorage.instance
  //         .ref('uploads/$fileName')
  //         .putData(fileBytes);
  //   }
  // }
}
