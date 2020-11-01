import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rydgo/Screens/BottomNavBar.dart';

import 'package:rydgo/Screens/SignUp.dart';
import 'package:rydgo/Services/DataBase.dart';

import 'package:sms_autofill/sms_autofill.dart';

class OtpForm extends StatefulWidget {
  final data, mobile;

  OtpForm({this.data, this.mobile});

  @override
  _OtpState createState() => _OtpState(data: data, mobile: mobile);
}

class _OtpState extends State<OtpForm> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final data, mobile;
  _OtpState({this.data, this.mobile});
  bool _timeEnd, _result;
  //bool _authFlag;

  final _otpController = TextEditingController();

  @override
  void initState() {
    //_authFlag = false;
    super.initState();
    _timeEnd = false;
    _result = false;

    // _auth.authStateChanges().firstWhere((user) => user != null).then((user) {
    //   if (_authFlag == false) {
    //     setState(() {
    //       _authFlag = true;
    //     });
    //     debugPrint('AUTH STATE HAS CHANGED OTP');
    //     debugPrint('user id: ' + user.uid);
    //     if (DataBaseService().getCollectionRef() != null) {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => MultiProvider(
    //                     providers: [
    //                       ChangeNotifierProvider.value(
    //                         value: AppState(),
    //                       )
    //                     ],
    //                     child: MyHomePage(),
    //                   )));
    //     } else {
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.00),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter OTP",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            Text("We sent your code to ${this.mobile}"),
            buildTimer(),
            SizedBox(height: 35),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: PinFieldAutoFill(
                decoration: BoxLooseDecoration(
                    strokeColorBuilder:
                        PinListenColorBuilder(Colors.cyan, Colors.green)),
                codeLength: 6,
                autofocus: false,
                onCodeChanged: (val) {
                  print(val);
                },
                controller: _otpController,
              ),
            ),
            _buildLoginBtn(),
            _buildLoginbackBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.2,
        onPressed: () {
          final otp = _otpController.text.trim();
          signInn(otp, data);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.green[300],
        child: Text(
          'VERIFY',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginbackBtn() {
    return GestureDetector(
      onTap: () {
        debugPrint('Resend Button Pressed');
        final otp = _otpController.text.trim();
        signInn(otp, data);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _timeEnd == true ? 'Resend OTP' : null,
              style: TextStyle(
                color: Colors.green[300],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  signInn(smsSent, verificationID) async {
    try {
      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: smsSent);

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      await getCollectionRef();
      if (_result == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      }
      // .then((user) => DataBaseService().getCollectionRef() != null
      //     ? Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => BottomNavBar()))
      //     : Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => SignUpScreen())));
    } on FirebaseException catch (exception) {
      switch (exception.code) {
        case "invalid-verification-id":
          _showErrorDialog("Invalid sms code");
          break;
        case "invalid-verification-code":
          _showErrorDialog("Invalid sms code");
          break;
        case "session-expired":
          _showErrorDialog(
              "The sms code has expired. Please re-send the verification code to try again.");
          break;
      }
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
              title: Text('An Error Occured'),
              content: Text(msg),
            ));
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          onEnd: () {
            setState(() {
              _timeEnd = true;
            });
          },
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  Future getCollectionRef() async {
    DocumentReference dbref = FirebaseFirestore.instance
        .collection('_CtnSignUp')
        .doc(FirebaseAuth.instance.currentUser.uid);

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
