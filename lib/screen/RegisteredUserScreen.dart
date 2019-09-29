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
class RegisteredUserScreen extends StatefulWidget {
  @override
  RegisteredUserScreenState createState() => RegisteredUserScreenState();
}
Future<List<Attendee>> _fetchRegistered() async {
  final response = await http.get('$base_url/registered');
  if(response.statusCode == 200) {
    var parsedJson = json.decode(response.body);
    Iterable registeredList = parsedJson['registeredList'];
    return registeredList.map((registered) => Attendee.fromJson(registered)).toList();
  } else {
    throw Exception('Failed to load attendees');
  }
}

class  RegisteredUserScreenState extends State<RegisteredUserScreen> {
  Future<List<Attendee>> registeredList;
  @override
  void initState() {
    super.initState();
    if(this.mounted) {
      setState(() {
        registeredList = _fetchRegistered();
      });
    }
  }
  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    setState(() {
      registeredList = _fetchRegistered();
    });
    _refreshController.loadComplete();
  }
  Widget build(BuildContext context) {
    return FutureBuilder<List<Attendee>>(
      future: registeredList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          var data = snapshot.data;
          return SmartRefresher(
            controller: _refreshController,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            header: WaterDropHeader(),
            enablePullDown: true,
            enablePullUp: true,
            child: ListView.builder(
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
            )
          );
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
}