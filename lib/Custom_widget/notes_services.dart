import 'package:wce_notice_board/Custom_widget/notes_for_listing.dart';
class NotesServices{
  List<noticeForListing> getnotesList()
  {
   return  [
      noticeForListing(
        noticeTitle: '1',
        noticeContent: 'Note 1',
        createDateTime: DateTime.now(),
        lastEditDateTime: DateTime.now(),
      ),
      noticeForListing(
        noticeTitle: '2',
        noticeContent: 'Note 2',
        createDateTime: DateTime.now(),
        lastEditDateTime: DateTime.now(),
      ),
      noticeForListing(
        noticeTitle: '3',
        noticeContent: 'Note 3',
        createDateTime: DateTime.now(),
        lastEditDateTime: DateTime.now(),
      ),
    ];
  }
}