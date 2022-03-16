import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notices_for_listing.dart';
import 'package:wce_notice_board/Screens/notices/years_page_admin.dart';
import 'package:wce_notice_board/utils/constants.dart';

import '../../Custom_widget/bottom_navigation_bar.dart';
import '../../Custom_widget/pdf_preview.dart';
import '../../main.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class NoticeViewer extends StatefulWidget {
  final NoticeForListing notice;
  static double pValue = -1.0;
  const NoticeViewer({Key key, this.notice}) : super(key: key);

  @override
  _NoticeViewerState createState() => _NoticeViewerState();
}

class _NoticeViewerState extends State<NoticeViewer> {
  dynamic firebaseUser;
  dynamic userRole;
  void getCall() async {
    var prn = await storage.read(key: "username");
    if (prn != null && widget.notice.isSeen != null) {
      final Map<String, dynamic> isSeen = widget.notice.isSeen;
      isSeen[prn] = true;
      await _fireStore
          .collection("Notices")
          .doc(widget.notice.noticeId)
          .update({"isSeen": isSeen});
    }
  }

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    // print();
    NoticeViewer.pValue = -1.0;
    if (_firebaseAuth.currentUser == null) {
      getCall();
      firebaseUser = null;
    } else {
      firebaseUser = _firebaseAuth.currentUser.uid;
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   getCall();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DEB3),
      appBar: AppBar(
        bottom: FileDownload.progressIndicator(NoticeViewer.pValue),
        backgroundColor: const Color(0xFF980F58),
        title: const Center(
          child: Text(
            'NOTICE        ',
            style: kTitleTextStyle,
          ),
        ),
        actions: firebaseUser == widget.notice.FacultyId
            ? <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return YearPage(
                              notice: widget.notice,
                            );
                          },
                        ),
                      );
                    },
                    child: const Icon(
                      IconData(
                        0xf67a,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 26.0,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: InteractiveViewer(
            panEnabled: false,
            boundaryMargin: const EdgeInsets.all(80),
            minScale: 1,
            maxScale: 4,
            child: Card(
              margin: const EdgeInsets.all(7.0),
              elevation: 6.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Center(
                        child: Text(
                          widget.notice.noticeTitle.toString().toCapitalized(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${widget.notice.noticeCreated.day}/${widget.notice.noticeCreated.month}/${widget.notice.noticeCreated.year}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.notice.noticeContent.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Regards',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.notice.noticeRegard.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    (widget.notice.file_url != null)
                        ? FileDownload(widget.notice.file_url)
                        : Container()
                    // FileDownload(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
