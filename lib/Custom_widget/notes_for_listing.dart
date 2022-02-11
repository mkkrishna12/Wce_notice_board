// ignore_for_file: non_constant_identifier_names

class NoticeForListing {
  String noticeTitle;
  String noticeContent;
  DateTime NoticeCreated;
  DateTime NoticeUpdate;
  DateTime NoticeEndDate;
  String NoticeRegard;
  String NoticeId;
  String FacultyId;
  bool fy,sy,ty,btech;
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
