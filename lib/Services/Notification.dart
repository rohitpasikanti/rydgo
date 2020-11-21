import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class _Notification extends StatefulWidget {
  @override
  __NotificationState createState() => __NotificationState();
}

class __NotificationState extends State<_Notification> {
  final _firbaseMessaging = FirebaseMessaging();
  String _message = 'Generate message';
  String _token = 'Generating token';

  void initState() {
    super.initState();
    _firbaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      setState(() {
        print("message : $message");
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      setState(() {
        print("message : $message");
      });
    }, onResume: (Map<String, dynamic> message) async {
      setState(() {
        print("message : $message");
      });
    });

    _firbaseMessaging.getToken().then((String token){
        print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
