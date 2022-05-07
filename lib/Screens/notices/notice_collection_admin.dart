import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Screens/notices/common_notice_veiwer.dart';
import 'package:wce_notice_board/Screens/notices/notice_delete.dart';
import 'package:wce_notice_board/Screens/notices/viewed_student_record.dart';
import 'package:wce_notice_board/Screens/notices/years_page_admin.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/notes_for_listing.dart';
import '../../widgets/pop_up_widget.dart';

//TODO make same notice collection file for both admin and students - done

class NoticeList extends StatefulWidget {
  final String userType;
  final bool isAdded;
  const NoticeList({Key key, this.userType, this.isAdded}) : super(key: key);
  @override
  _NoticeListState createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
  String selectedUser;
  bool spinner = false;
  bool admin = false;
  List<NoticeForListing> notice = [];
  StreamSubscription<QuerySnapshot> _eventsSubscription;

  Future<String> StudentsList(Map<String, dynamic> isSeen) async {
    var lst = [];
    isSeen.forEach((k, v) => lst.add(k));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFEF1E6),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Center(child: Text('Students list')),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: VeiwStudents(lst: lst),
            ),
          );
        });
  }

  Future<void> fectchNotice() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    if (_firebaseAuth.currentUser == null) {
      return;
    }
    _fireStore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((element) {
      if (!mounted) return;
      setState(() {
        admin = element['Role'] == 'admin';
      });
    });
    if (!mounted) return;
    try {
      _eventsSubscription = _fireStore
          .collection("Notices")
          .where("FacultyId", isEqualTo: _firebaseAuth.currentUser.uid)
          .snapshots()
          .listen((QuerySnapshot value) {
        if (!mounted) return;

        setState(() {
          notice = [];
          // print(value.docs.length);
          for (var element in value.docs) {
            if (element['NoticeCreated'] == null) break;
            DateTime val = element['NoticeCreated'].toDate();
            DateTime val1 = element['NoticeUpdated'].toDate();
            NoticeForListing mk = NoticeForListing(
              noticeTitle: element['NoticeTitle'],
              noticeContent: element['Noticecontent'],
              noticeCreated: val,
              noticeUpdate: val1,
              noticeEndDate: element['NoticeEndDate'].toDate(),
              noticeRegard: element['NoticeRegards'],
              noticeId: element.id,
              FacultyId: element['FacultyId'],
              ty: element['ThirdYear'],
              fy: element['FirstYear'],
              sy: element['SecondYear'],
              btech: element['LastYear'],
              isSeen: element['isSeen'],
              isPersonalised: element['isPersonalised'],
              isPersonalisedArray: element['isPersonalisedArray'],
              file_url: element.get('file_url'),
              otherrole: element.data().toString().contains('otherrole')
                  ? element['otherrole']
                  : '',
            );
            // print(mk);
            if (element['FacultyId'] == _firebaseAuth.currentUser.uid) {
              notice.add(mk);
            }
          }
          spinner = false;
        });
      });
    } catch (e) {
      spinner = false;

      showDialog(
        context: context,
        builder: (BuildContext context) => const PopUp(
          toNavigate: null,
          message: 'Something went wrong try after some time',
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
    notice = [];
    if (!widget.isAdded) {
      fectchNotice();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _eventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fectchNotice();
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF980F58),
          title: const Center(
            child: Text(
              'List of Notices',
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
        bottomNavigationBar: const BottomNavigationWidget(),
        body: RefreshIndicator(
          onRefresh: fectchNotice,
          child: ListView.builder(
              itemBuilder: (_, index) {
                //TODO add functionality to delete notice to admin - done
                return (notice.length != 0)
                    ? Dismissible(
                        key: ValueKey(notice[index].noticeTitle),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          if (!mounted) return;
                          setState(() {
                            notice.removeAt(index);
                          });
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (_) => NoteDelete(notice[index].noticeId),
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
                        child: Card(
                          elevation: 5.0,
                          child: ListTile(
                            trailing: IconButton(
                              iconSize: 20,
                              icon: const Icon(
                                IconData(
                                  0xe6bd,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                StudentsList(notice[index].isSeen);
                              },
                            ),
                            title: Text(
                              notice[index].noticeTitle.toCapitalized(),
                              // notice[index].noticeContent,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                                'Last edited : ${notice[index].noticeCreated.day}/${notice[index].noticeCreated.month}/${notice[index].noticeCreated.year}'),
                            onTap: () {
                              // fectchNotice();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return NoticeViewer(
                                    notice: notice[index],
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(child: Text('No Notice Available'));
              },
              itemCount: notice.length),
        ),
      ),
    );
  }
}
