import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rydgo/Screens/BottomNavBar.dart';
import 'package:rydgo/Screens/Login.dart';
import 'package:rydgo/Screens/SignUp.dart';
import 'package:rydgo/Services/DataBase.dart';

class AuthService extends StatefulWidget {
  @override
  _AuthService createState() => _AuthService();

  static signOut() {}

  void signIn(AuthCredential authresult) {}
}

class _AuthService extends State<AuthService> {
  bool _result;

  @override
  void initState() {
    super.initState();
    _result = false;
    String uid = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser.uid.toString()
        : null;
    getCollectionRef(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return LoginScreen();
                } else {
                  if (_result == true) {
                    return BottomNavBar();
                  } else {
                    return SignUpScreen();
                  }
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

  // handleAuth(BuildContext context) {
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         if (_result==false) {
  //           return BottomNavBar();
  //         } else {
  //           return SignUpScreen();
  //         }
  //       } else {
  //         return LoginScreen(); //_login(context);

  //       }
  //     },
  //   );
  // }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signInWithOtp(smscode, varID) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: varID, smsCode: smscode);
    signIn(authCredential);
  }

  void getCollectionRef(String uid) async {
    DocumentReference dbref =
        FirebaseFirestore.instance.collection('_CtnSignUp').doc(uid);

    DocumentSnapshot snapshot = await dbref.get();
    if (snapshot.exists) {
      setState(() {
        _result = true;
      });
    } else {
      setState(() {
        _result = false;
      });
    }
  }
}
