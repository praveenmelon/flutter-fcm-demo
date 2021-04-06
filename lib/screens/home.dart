import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_demo/models/message.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Message> _messages;
  _getToken() {
    _firebaseMessaging.getToken().then(
      (value) {
        print("Device token : $value");
      },
    );
  }

  _configureFirebaseListner() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print(message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messages = [];
    _getToken();
    _configureFirebaseListner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter FCM"),
      ),
    );
  }
}
