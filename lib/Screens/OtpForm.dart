import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rydgo/Screens/SignUp.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpForm extends StatefulWidget {
  final data, mobile;

  OtpForm({this.data, this.mobile});

  @override
  _OtpState createState() => _OtpState(data: data, mobile: mobile);
}

class _OtpState extends State<OtpForm> {
  final data, mobile;
  _OtpState({this.data, this.mobile});
  bool _timeEnd = false;
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.00),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter Otp",
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
          FirebaseAuth.instance.authStateChanges().listen((User user) {
            if (user != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            } else {
              signInn(otp, data);
            }
          });
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
              text: 'Resend Otp',
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

  signInn(smsSent, verificationID) {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsSent);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            ))
        //.catchError((e) => print(e));
        .catchError((e) => _showErrorDialog(e.toString() ==
                "firebase_auth/invalid-verification-code"
            ? "Invalid Verification Code"
            : "The sms code has expired. Please re-send the verification code"));
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
            _timeEnd = true;
          },
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
