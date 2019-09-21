import 'package:flutter/material.dart';
import '../models/attendeeModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendeeScreen extends StatefulWidget {
  @override
  AttendeeScreenState createState() => AttendeeScreenState();
}
Future<List<Attendee>> _fetchAttendee() async {
  final response = await http.get('https://devfest-admin.herokuapp.com/attendees');
  if(response.statusCode == 200) {
    var parsedJson = json.decode(response.body);
    Iterable attendeeList =parsedJson['attendeeList'];
    return attendeeList.map((attendee) => Attendee.fromJson(attendee)).toList();
  } else {
    throw Exception('Failed to load attendees');
  }
}

class  AttendeeScreenState extends State<AttendeeScreen> {
  Future<List<Attendee>> attendeeList;
  @override
  void initState() {
    super.initState();
    attendeeList = _fetchAttendee();
  }
  Widget build(BuildContext context) {
    return FutureBuilder<List<Attendee>>(
      future: attendeeList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          var data = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 8,
                child: ListTile(
                  title: Text("${data[index].firstName} ${data[index].lastName}"),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text(data[index].firstName[0]),
                  ),
                ),
              );
            },
          );
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
}