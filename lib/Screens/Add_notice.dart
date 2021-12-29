import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wce_notice_board/Custom_widget/pop_up_widget.dart';
import 'package:wce_notice_board/Screens/notice_collection.dart';


FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class addNotice extends StatefulWidget {
  addNotice({this.years});
  final List<bool> years ;
  @override
  _addNoticeState createState() => _addNoticeState();
}

class _addNoticeState extends State<addNotice> {
  var firebaseUser;
  String title;
  String Notice;
  String from;
  DateTime DateNow=null;
  DateTime EndDate=null;

  @override
  void initState() {

    super.initState();
     firebaseUser= _firebaseAuth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Notice..'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          noticeInput(
            hintText: 'Enter title for notice',
            flex: 1,
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          noticeInput(
            hintText: 'Enter notice',
            flex: 5,
            onChanged: (value) {
              setState(() {
                Notice = value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          noticeInput(
            hintText: 'Enter faculty or branch',
            flex: 1,
            onChanged: (value) {
              setState(() {
                from = value;
              });
            },
          ),
          const SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              height: 30.0,
              width: double.infinity,
              child: FlatButton(
                child: Text('Add Notice'),
                onPressed: (){
                  _fireStore.collection("Notices").add({
                    "FacultyId" : firebaseUser.uid,
                    "NoticeTitle":title,
                    "Noticecontent":Notice,
                    "NoticeRegards":from,
                    "NoticeCreated" : (DateNow==null) ? FieldValue.serverTimestamp() : DateNow,
                    "NoticeUpdated" : FieldValue.serverTimestamp(),
                    "NoticeEndDate":EndDate,
                    "FirstYear"  : widget.years[0],
                    "SecondYear"  : widget.years[1],
                    "ThirdYear"  : widget.years[2],
                    "LastYear"  : widget.years[3],

                  }).then((value) =>
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => PopUp(
                          toNavigate: noticeList(),
                          message:
                          'Notice Added',
                          icon: Icons.check,
                          state: true,
                          color: Colors.green,

                        ),
                  )).catchError((onError){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => PopUp(
                      toNavigate: null,
                      message:
                      'Something went Wrong. Please try again...',
                      icon: Icons.cancel,
                      state: false,
                      color: Colors.red,

                    ),);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class noticeInput extends StatefulWidget {
  // const notice_input({Key? key}) : super(key: key);
  noticeInput({this.hintText, this.onChanged, this.flex});
  String hintText;
  Function onChanged;
  int flex;
  @override
  _noticeInputState createState() => _noticeInputState();
}

class _noticeInputState extends State<noticeInput> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Colors.grey,
        child: Container(
          margin: EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          width: double.infinity,

          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 17.5,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
