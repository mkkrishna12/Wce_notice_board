import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_veiwer.dart';
import 'package:wce_notice_board/Screens/noticess/notice_delete.dart';
import 'package:wce_notice_board/Screens/noticess/years_admin.dart';
//TODO make same notice collection file for both admin and students

class NoticeList extends StatefulWidget {
  final String userType;
  const NoticeList({Key key ,this.userType}) : super(key: key);
  @override

  _NoticeListState createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
  dynamic collection;
  String selectedUser;
  bool spinner = false;
  String head;
  var cnt = 0;
  bool admin = false;
  List<NoticeForListing> notes = [];
  void getVal() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    _fireStore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((element) {
      setState(() {
        admin = element['Role'] == 'admin';
      });
    });
    try {
      _fireStore
          .collection('Notices')
          .snapshots()
          .listen((QuerySnapshot value) {
        setState(() {
          notes = [];
          value.docs.forEach((element) {
            DateTime val = element['NoticeCreated'].toDate();
            DateTime val1 = element['NoticeUpdated'].toDate();
            NoticeForListing mk = NoticeForListing(
              noticeTitle: element['NoticeTitle'],
              noticeContent: element['Noticecontent'],
              NoticeCreated: val,
              NoticeUpdate: val1,
              NoticeEndDate: element['NoticeEndDate'].toDate(),
              NoticeRegard: element['NoticeRegards'],
              NoticeId: element.id,
              FacultyId: element['FacultyId'],
              ty: element['ThirdYear'],
              fy: element['FirstYear'],
              sy: element['SecondYear'],
              btech: element['LastYear'],
            );
            notes.add(mk);
          });
          spinner = false;
        });
      });
    } catch (e) {
      spinner = false;

      showDialog(
        context: context,
        builder: (BuildContext context) => const PopUp(
          toNavigate: null,
          message: 'Somthing went wrong try after some time',
          icon: Icons.cancel,
          state: false,
          color: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    notes = [];
    getVal();
  }

  @override
  Widget build(BuildContext context) {
    getVal();
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'List of Notes',
            ),
          ),
        ),
        floatingActionButton: (admin == true)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const YearPage(
                        notice: null,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add,
                ),
              )
            : null,
        body: ListView.separated(
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(notes[index].noticeTitle),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (_) => NoteDelete(),
                  );
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Align(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    notes[index].noticeTitle,
                    // notes[index].noticeContent,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text('Last edited ${notes[index].NoticeCreated}'),
                  onTap: () {
                    // getVal();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return NoticeViewer(
                          notice: notes[index],
                        );
                      }),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Colors.green,
                ),
            itemCount: notes.length),
      ),
    );
  }
}
