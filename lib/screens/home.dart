import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_demo/models/message.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Message> _messages;
  _getToken() {
    _firebaseMessaging.getToken().then(
      (value) {
        print("Device token : $value");
      },
    );
  }

  void showInSnackBar(BuildContext context,String value,) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value),duration: Duration(milliseconds: 9000),));
  }

  _configureFirebaseListner(BuildContext contextt) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print(message.data);
      _setMessage(message);
      showInSnackBar(contextt,'received');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data);

      _setMessage(message);
      showInSnackBar(contextt,'received');
    });
  }

  _setMessage(RemoteMessage message) {
    final data = message.data;
    final String title = message.notification.title;
    final String body = message.notification.body;
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title: title, body: body, message: mMessage);
      _messages.add(m);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messages = [];
    _getToken();
    _configureFirebaseListner(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Flutter FCM"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  _messages[index].title,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            );
          }),
    );
  }
}
