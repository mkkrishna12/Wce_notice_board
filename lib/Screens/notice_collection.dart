import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/notes_services.dart';
import 'package:wce_notice_board/Screens/Add_notice.dart';
import 'package:wce_notice_board/Screens/notice_delete.dart';
import 'package:wce_notice_board/Screens/notice_modify.dart';
import 'package:wce_notice_board/Screens/years.dart';

class noticeList extends StatefulWidget {
  @override
  _noticeListState createState() => _noticeListState();
}

class _noticeListState extends State<noticeList> {
  NotesServices get service => GetIt.I<NotesServices>();
  var collection;
  bool spinner = true;
  String head;
  var cnt = 0;
  List<noticeForListing> notes = [];
  void getVal() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    // spinner=true;
    print("hi mk");
    _fireStore.collection('Notices').snapshots().listen((QuerySnapshot value) {
      setState(() {
        value.docs.forEach((element) {
          print(element.id);
          DateTime val = element['NoticeCreated'].toDate();
          DateTime val1 = element['NoticeUpdated'].toDate();
          noticeForListing mk = noticeForListing(
            NoticeTitle: element['NoticeTitle'],
            Noticecontent: element['Noticecontent'],
            NoticeCreated: val,
            NoticeUpdate: val1,
            NoticeRegard: element['NoticeRegards'],
            NoticeId: element.id          );
          notes.add(mk);
        });
        spinner = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getVal();
    // print(collection);
  }

  Widget build(BuildContext context) {
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => yearPage(noticeId: null,),
                ),
              );
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          body: ListView.separated(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(notes[index].NoticeTitle),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => noteDelete(),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
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
                      notes[index].NoticeTitle,
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
                          return ;
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
        ));
  }
}
