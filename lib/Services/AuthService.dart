import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rydgo/Screens/Login.dart';
import 'package:rydgo/Screens/MapScreen.dart';
import 'package:rydgo/Services/app_state.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: AppState(),
              )
            ],
            child: MyHomePage(),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signInWithOtp(smscode, varID) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: varID, smsCode: smscode);
    signIn(authCredential);
  }
}
