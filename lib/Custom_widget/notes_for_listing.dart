// ignore_for_file: non_constant_identifier_names
// Class is created for the information related to the notice will entered or viewed by user
class NoticeForListing {
  String noticeTitle;     //Title of notice
  String noticeContent;   //The content to be entered
  DateTime NoticeCreated; //Date of Creation
  DateTime NoticeUpdate;  //Date of last modification
  DateTime NoticeEndDate; //Notice will be displayed till this date
  String NoticeRegard;    //The Faculty name who has entered notice
  String NoticeId;        //Notice id generated in database
  String FacultyId;       //Faculty id generated in database
  bool fy,sy,ty,btech;    //the notes will be shown selex=cte
  NoticeForListing({
    this.NoticeEndDate,
    this.NoticeId,
    this.noticeTitle,
    this.noticeContent,
    this.NoticeCreated,
    this.NoticeUpdate,
    this.NoticeRegard,
    this.FacultyId,
    this.ty,
    this.fy,
    this.sy,
    this.btech,
  });
}
