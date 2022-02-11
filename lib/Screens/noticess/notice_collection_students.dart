import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/noticess/notice_veiwer.dart';

class NoticeForStudents extends StatefulWidget {
  final String selectedYear;
  const NoticeForStudents({Key key, this.selectedYear}) : super(key: key);

  @override
  _NoticeForStudentsState createState() => _NoticeForStudentsState();
}

class _NoticeForStudentsState extends State<NoticeForStudents> {
  List<NoticeForListing> notes = [];
  bool spinner =true;

  void getVal() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    _fireStore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((element) {

    });
    try{
      _fireStore.collection('Notices').snapshots().listen((QuerySnapshot value) {
        setState(() {
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
            if(widget.selectedYear == 'First Year'){
              if(element['FirstYear'] == true){
                notes.add(mk);
              }
            }
            if(widget.selectedYear == 'Second Year'){
              if(element['SecondYear'] == true){
                notes.add(mk);
              }
            }
            if(widget.selectedYear == 'Third Year'){
              if(element['ThirdYear'] == true){
                notes.add(mk);
              }
            }
            if(widget.selectedYear == 'Fourth Year'){
              if(element['LastYear'] == true){
                notes.add(mk);
              }
            }
          });
          spinner = false;
        });
      });
    } catch(e){
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
    getVal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title:  Text(
          'Wce Notice Board ${notes.length}${widget.selectedYear}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(
                notes[index].noticeTitle,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              subtitle: Text('Last edited ${notes[index].NoticeCreated}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NoticeViewer(
                      notice: notes[index],
                    );
                  }),
                );
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: Colors.green,
          ),
          itemCount: notes.length),
    );
  }
}
