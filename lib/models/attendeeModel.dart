// class AttendeeList {
//   List<Attendee>attendeeList;
//   AttendeeList({this.attendeeList});
//   AttendeeList.fromJsom(Map<String, dynamic> json){
//     if (json['attendeeList'] != null) {
//       attendeeList = new List<Attendee>();
//       json['attendeeList'].forEach((v) {
//         attendeeList.add(new Attendee.fromJson(v));
//       });
//     }
//   }
// }
class Attendee {
  String orderId;
  String firstName;
  String lastName;
  String emailAddress;
  String time;
  Attendee(this.orderId, this.firstName, this.lastName, this.emailAddress, this.time);
  Attendee.fromJson(Map<String, dynamic> parsedJson):
    orderId =parsedJson['orderId'],
    firstName =parsedJson['firstName'],
    lastName =parsedJson['lastName'],
    emailAddress =parsedJson['emailAddress'],
    time = parsedJson['time'];
}