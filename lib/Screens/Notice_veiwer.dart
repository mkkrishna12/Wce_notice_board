import 'package:flutter/material.dart';
import 'package:wce_notice_board/Screens/years.dart';
import '../constants.dart';

class noticeViewer extends StatefulWidget {
  // const noticeViewer({Key? key}) : super(key: key);
  bool userType;
  noticeViewer({this.userType});

  @override
  _noticeViewerState createState() => _noticeViewerState();
}

class _noticeViewerState extends State<noticeViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return yearPage();
            }),);
          },
        ),
        backgroundColor: Colors.blueAccent,
        title: const Center(
          child: Text(
            'Notice..',
            style: kTitleTextStyle,
          ),
        ),
      ),
      body: InteractiveViewer(

        panEnabled: false ,

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
              child: const Center(
                child: Text(
                  'Regarding Annual functions of the college.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'The most awaited function for any student is the School Annual Day Function. Our School Annual Day celebrations are scheduled to happen next week and we are on fully fledged preparations of the same. I am so delighted about the celebration because our head mistress has given me a great responsibility.',
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Regards',
                  style: TextStyle(
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
