import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rydgo/Screens/Login.dart';
import 'package:rydgo/Screens/MapScreen.dart';
import 'package:rydgo/Services/app_state.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPage createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return Scaffold(
                    body: Center(
                      child: _login(context),
                    ),
                  );
                } else {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: AppState(),
                      )
                    ],
                    child: MyHomePage(),
                  );
                }
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }

  _login(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }
}
