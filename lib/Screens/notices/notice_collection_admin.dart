import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/notices_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/notices/notice_delete.dart';
import 'package:wce_notice_board/Screens/notices/common_notice_veiwer.dart';
import 'package:wce_notice_board/Screens/notices/years_page_admin.dart';

import '../../Custom_widget/bottom_navigation_bar.dart';
import '../../main.dart';
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

  Future<void> fectchNotice() async {

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
      _fireStore
          .collection('Notices')
          .snapshots()
          .listen((QuerySnapshot value) {
        if (!mounted) return;
        setState(() {
          notice = [];
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
            );
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
    notice = [];
    if (!widget.isAdded) {
      fectchNotice();
    }
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
