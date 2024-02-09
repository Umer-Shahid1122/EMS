class Attendance_Modal {
  String status;
  String id ;
  String date;

  Attendance_Modal(
  {
    required this.status,
    required this.id,
    required this.date

}
      );

  toJson(){
    return {
      'Status':status,
      'Date'  :date
    };
  }
}