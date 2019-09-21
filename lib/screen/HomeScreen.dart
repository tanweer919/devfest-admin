import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _totalCount, _totalCheckedOut;
  String _message = '';
  bool _success = false;
  void getCount() async {
    String url = 'https://devfest-admin.herokuapp.com/attendee/total';
    var response = await http.get(url);
    if(response.statusCode == 200) {
      var parsedJson =json.decode(response.body);
      setState(() {
        _totalCheckedOut =parsedJson['totalCheckedOut'];
        _totalCount =parsedJson['totalCount'];
        _success = true;
      });
    }
    else {
      setState(() {
        _message = 'Unable to fetch data';
        _success = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _success? Card(
        child: _message == ''?
          Text('Total Count: $_totalCount\nTotal Checkout: $_totalCheckedOut',
          style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        ): Text(_message,
        style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
      ):CircularProgressIndicator()
    );
  }
}