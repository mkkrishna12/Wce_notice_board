class noticeForListing {
  String NoticeTitle;
  String Noticecontent;
  DateTime NoticeCreated;
  DateTime NoticeUpdate;
  DateTime NoticeEndDate;
  String NoticeRegard;
  String NoticeId;
  String FacultyId;
  bool fy,sy,ty,btech;
  noticeForListing({
    this.NoticeEndDate,
    this.NoticeId,
    this.NoticeTitle,
    this.Noticecontent,
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
