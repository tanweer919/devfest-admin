import 'package:flutter/material.dart';
import 'screen/HomeScreen.dart';
import 'screen/AttendeeScreen.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'screen/RegisteredUserScreen.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  int _currentIndex = 0;
  final List<Widget> _currentWidget = [
    HomeScreen(),
    AttendeeScreen(),
    RegisteredUserScreen()
  ];
  final _bottomNavBarStyle = TextStyle(fontWeight: FontWeight.normal, color: Colors.black,);
  final List<BottomNavigationBarItem> bottomNavigationBarItems = [];
  String result = 'Hello There';

  AppState() {
    bottomNavigationBarItems.addAll([new BottomNavigationBarItem(
      activeIcon: Icon(Icons.home, color: Color(0xFFF3791A)),
      icon: Icon(Icons.home, color: Colors.black,),
      title: Text('Home', style:_bottomNavBarStyle)
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.supervised_user_circle, color: Color(0xFFF3791A)),
      icon: Icon(Icons.supervised_user_circle, color: Colors.black,),
      title: Text('Attendees', style:_bottomNavBarStyle)
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.account_circle, color: Color(0xFFF3791A)),
      icon: Icon(Icons.supervised_user_circle, color: Colors.black,),
      title: Text('Registered User', style:_bottomNavBarStyle)
    )
  ]);
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Future _scanQr(BuildContext context) async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        _showDialog(context, result);
      });
    } on PlatformException catch(ex) {
      if(ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera access denied";
          _showDialog(context, result);
        });
      } else {
        setState(() {
          result = 'Unknown error $ex';
          _showDialog(context, result);
        });
      }
    } on FormatException { 
      setState(() {
        result = "You pressed back button before scannig anything";
        _showDialog(context, result);
      });
    } catch(ex) {
      result = "Unknown error $ex";
      _showDialog(context, result);
    }
  }

  void _showDialog(BuildContext context, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('DevFest Admin'),
      ),
      body: _currentWidget[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        items: bottomNavigationBarItems,
        currentIndex: _currentIndex,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:() => _scanQr(context),
        icon: Icon(Icons.camera_alt),
        label: Text('Scan'),
      ),
    );
  }
}