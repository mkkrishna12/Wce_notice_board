import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/notices/common_notice_veiwer.dart';

import '../../main.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/notes_for_listing.dart';
import '../../widgets/pop_up_widget.dart';

class NoticeForStudents extends StatefulWidget {
  final String selectedYear;
  const NoticeForStudents({Key key, this.selectedYear}) : super(key: key);

  @override
  _NoticeForStudentsState createState() => _NoticeForStudentsState();
}

class _NoticeForStudentsState extends State<NoticeForStudents> {
  List<NoticeForListing> notes = [], oNotes = [];
  bool spinner = true;
  String prn, sortby;

  Future<void> getVal() async {
    prn = await storage.read(key: "username");
    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
              file_url: element['file_url'],
              otherrole: element.data().toString().contains('otherrole')
                  ? element['otherrole']
                  : '',
            );
            // print("Hello");
            if (widget.selectedYear == 'First Year') {
              if (element['FirstYear'] == true) {
                notes.add(mk);
              }
            }
            if (widget.selectedYear == 'Second Year') {
              if (element['SecondYear'] == true) {
                notes.add(mk);
              }
            }
            if (widget.selectedYear == 'Third Year') {
              if (element['ThirdYear'] == true) {
                notes.add(mk);
              }
            }
            if (widget.selectedYear == 'Fourth Year') {
              if (element['LastYear'] == true) {
                notes.add(mk);
              }
            }
          });
          oNotes = notes;
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

  var myMenuItems = <String>[
    'None',
    "HOD",
    "FY ClassTeacher",
    "SY ClassTeacher",
    "TY ClassTeacher",
    "BTECH ClassTeacher",
    "Teacher",
    "DCOE",
  ];
  void onSelect(item) {
    List<NoticeForListing> tmp = [];
    if (item != null && item != 'None') {
      oNotes.forEach((element) {
        if (element.otherrole == item || element.otherrole == null) {
          tmp.add(element);
        }
      });
    } else {
      tmp = oNotes;
    }
    setState(() {
      notes = tmp;
      sortby = item;
    });
  }

  @override
  void initState() {
    super.initState();
    // onSelect('')
    getVal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF1E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF980F58),
        title: const Text(
          'Wce Notice Board',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: onSelect,
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              }),
        ],
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
      body: RefreshIndicator(
        onRefresh: () {
          return getVal();
        },
        child: (notes.isNotEmpty)
            ? ListView.builder(
                itemBuilder: (_, index) {
                  return Card(
                    // color: Color(0xFFFFF0F0),
                    elevation: 5.0,
                    child: ListTile(
                      title: Text(
                        notes[index].noticeTitle.toString().toCapitalized(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                          'Last edited : ${notes[index].noticeCreated.day}/${notes[index].noticeCreated.month}/${notes[index].noticeCreated.year}'),
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

                      ///  change color when user see notification done
                      trailing: CircleAvatar(
                        backgroundColor: (notes[index].isSeen[prn] != null &&
                                notes[index].isSeen[prn] == true)
                            ? Colors.white
                            : Colors.blue,
                        radius: 5.0,
                      ),
                    ),
                  );
                },
                itemCount: notes.length,
              )
            : const Center(child: Text('No Notice Available')),
      ),
    );
  }
}
