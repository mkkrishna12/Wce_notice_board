// ignore_for_file: non_constant_identifier_names
// Class is created for the information related to the notice will entered or viewed by user
class NoticeForListing {
  String noticeTitle;     //Title of notice
  String noticeContent;    //The content to be entered
  DateTime noticeCreated; //Date of Creation
  DateTime noticeUpdate;  //Date of last modification
  DateTime noticeEndDate; //Notice will be displayed till this date
  String noticeRegard;    //The Faculty name who has entered notice
  String noticeId;        //Notice id generated in database
  String FacultyId;       //Faculty id generated in database
  bool fy, sy, ty, btech; //the notes will be shown selecte
  NoticeForListing({
    this.noticeEndDate,
    this.noticeId,
    this.noticeTitle,
    this.noticeContent,
    this.noticeCreated,
    this.noticeUpdate,
    this.noticeRegard,
    this.FacultyId,
    this.ty,
    this.fy,
    this.sy,
    this.btech,
  });
}
