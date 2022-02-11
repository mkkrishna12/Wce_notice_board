
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Screens/noticess/years_admin.dart';
import '../../constants.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class NoticeViewer extends StatefulWidget {
  final NoticeForListing notice;

  const NoticeViewer({Key key, this.notice}) : super(key: key);

  @override
  _NoticeViewerState createState() => _NoticeViewerState();
}

class _NoticeViewerState extends State<NoticeViewer> {
  dynamic firebaseUser;
  dynamic userRole;
  @override
  void initState() {
    super.initState();
    firebaseUser = _firebaseAuth.currentUser.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(
          child: Text(
            'Notice..',
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
                            return YearPage(notice: widget.notice,);
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
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Center(
                child: Text(
                  widget.notice.noticeTitle,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.notice.noticeContent,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  widget.notice.NoticeRegard,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
