// ignore_for_file: non_constant_identifier_names

class NoticeForListing {
  String noticeTitle;
  String noticeContent;
  DateTime noticeCreated;
  DateTime noticeUpdate;
  DateTime noticeEndDate;
  String noticeRegard;
  String noticeId;
  String FacultyId;
  bool fy, sy, ty, btech;
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
