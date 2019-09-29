import 'package:flutter/material.dart';
import '../models/attendeeModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../config/config.dart';

RefreshController _refreshController =RefreshController(
  initialRefresh: false
);
class AttendeeScreen extends StatefulWidget {
  @override
  AttendeeScreenState createState() => AttendeeScreenState();
}
Future<List<Attendee>> _fetchAttendee() async {
  final response = await http.get('$base_url/attendees');
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
    if(this.mounted) {
      setState(() {
        attendeeList = _fetchAttendee();
      });
    }
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    setState(() {
      attendeeList = _fetchAttendee();
    });
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<Attendee>>(
      future: attendeeList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            var data = snapshot.data;
            return SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text("${data[index].firstName} ${data[index].lastName}"),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF00C851),
                        child: Icon(Icons.done),
                      ),
                      trailing: Text(data[index].time.substring(11), style: TextStyle(fontSize: 14.0),
                      )
                    )
                  );
                },
              )
            );
          }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
}