import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';

import 'package:wce_notice_board/Custom_widget/notes_services.dart';
import 'package:wce_notice_board/Screens/Add_notice.dart';
import 'package:wce_notice_board/Screens/notice_delete.dart';
import 'package:wce_notice_board/Screens/notice_modify.dart';

class noticeList extends StatefulWidget {
  // const noticeList({Key? key}) : super(key: key);

  @override
  _noticeListState createState() => _noticeListState();
}

class _noticeListState extends State<noticeList> {


  NotesServices get service => GetIt .I<NotesServices>();

  List<noticeForListing> notes = [];

  @override
  void initState(){
    super.initState();
    notes = service.getnotesList();
  }
  Widget build (BuildContext context) {
    return Scaffold(
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
              builder: (context) => addNotice(),
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
              key: ValueKey(notes[index].noticeTitle),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction){

              },
              confirmDismiss: (direction) async
              {
                return await showDialog(context: context, builder:(_)=>noteDelete(),);
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  child: Icon(Icons.delete,color: Colors.white,),
                  alignment: Alignment.centerLeft,
                ),
              ),
              child: ListTile(
                title: Text(
                  notes[index].noticeContent,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text('Last edited ${notes[index].lastEditDateTime}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return addNotice();
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
    );
  }
}
