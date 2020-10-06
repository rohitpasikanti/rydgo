import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rydgo/Screens/OtpForm.dart';
import 'package:rydgo/Screens/MapScreen.dart';
import 'package:rydgo/Utilities/design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rydgo/Loaders/SignUpLoad.dart';
import 'package:rydgo/Services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  String _email;
  String phoneNo, verificationID, smsSent;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool codeSent = false;
  bool _loginbtn;

  @override
  void initState() {
    _loginbtn = false;
  }

  Widget _buildMobileF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: rLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecoration,
          height: 50.0,
          child: TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return 'Please Enter Your Email';
              } else if (!input.contains('@')) {
                return 'Invalid Email';
              } else {
                return null;
              }
            },
            onChanged: (val) {
              if (val.length == 10) {
                setState(() {
                  _loginbtn = true;
                });
              } else {
                setState(() {
                  _loginbtn = false;
                });
              }
            },
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: TextStyle(height: 0),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.green[300],
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: rHintText,
            ),
            controller: _phoneController,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.2,
        onPressed: _loginbtn == false ? null : () => verifyPhone(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.green[300],
        child: Text(
          'LOGIN',
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

  Future<void> verifyPhone(BuildContext context) async {
    final mobile = "+91" + _phoneController.text.trim();
    setState(() {
      loading = true;
    });
    final PhoneVerificationCompleted verified = (AuthCredential authresult) {
      AuthService().signIn(authresult);
    };
    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verID, [int forceResend]) {
      this.verificationID = verID;
      setState(() {
        this.codeSent = true;
        loading = false;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpForm(data: verID, mobile: mobile)));
        //smsdialog(context).then((value) => print("Sign IN"));
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeOut = (String verID) {
      this.verificationID = verID;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeOut,
        timeout: const Duration(seconds: 60));
  }

  Future<bool> smsdialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Enter Code",
              style: TextStyle(color: Colors.green[300]),
            ),
            content: TextField(
              onChanged: (value) {
                smsSent = value;
              },
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child:
                    Text("Verify", style: TextStyle(color: Colors.green[300])),
                onPressed: () {
                  FirebaseAuth.instance.authStateChanges().listen((User user) {
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    } else {
                      Navigator.of(context).pop();
                      signInn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signInn() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsSent);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            ))
        .catchError((e) => print(e));
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? ShowLoading()
        : Scaffold(
            body: Form(
              key: _formKey,
              //value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 80.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.green[400],
                                fontFamily: 'OpenSans',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildMobileF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildLoginBtn(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
