import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rydgo/Screens/BottomNavBar.dart';
import 'package:rydgo/Utilities/design.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rydgo/Services/DataBase.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  String _email, _name, _gender;
  String phoneNo, verificationID, smsSent;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool codeSent = false;

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
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
                return 'Please Enter Your Name';
              } else {
                return null;
              }
            },
            onSaved: (input) => _name = input,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.green[300],
              ),
              hintText: 'Enter your Name',
              hintStyle: rHintText,
            ),
          ),
        ),
      ],
    );
  }

  List<String> lst = ['Male', 'Female', 'Others'];
  int _selectedposition = 0;

  void changeIndex(int index) {
    setState(() {
      _selectedposition = index;
    });
  }

  Widget _buidGenderBtn(String txt, int index) {
    return FlatButton(
      onPressed: () => changeIndex(index),
      onHighlightChanged: (input) => _gender,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
            color: _selectedposition == index
                ? Colors.green[300]
                : Colors.black12),
      ),
      child: Text(txt,
          style: TextStyle(
              color:
                  _selectedposition == index ? Colors.green[300] : Colors.black,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Gender',
          style: rLabelStyle,
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            _buidGenderBtn(lst[0], 0),
            SizedBox(
              width: 20.0,
            ),
            _buidGenderBtn(lst[1], 1),
            SizedBox(
              width: 20.0,
            ),
            _buidGenderBtn(lst[2], 2),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
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
            onSaved: (input) => _email = input,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.green[300],
              ),
              hintText: 'Enter your Email',
              hintStyle: rHintText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          signUp();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.green[300],
        child: Text(
          'SUBMIT',
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

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      setState(() {
        loading = true;
      });
      formState.save();
      try {
        DataBaseService().updateUserData(
            _name,
            _selectedposition == 0
                ? 'Male'
                : _selectedposition == 1
                    ? 'Female'
                    : 'Others',
            _email);
        setState(() {
          loading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = false;
        });
        if (e.code == 'weak-password') {
          _showErrorDialog('The account already exists for that email.');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog('The account already exists for that email.');
          print('The account already exists for that email.');
        }
      } catch (e) {
        setState(() => loading = false);
        _showErrorDialog(e.toString());
        print(e.toString());
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Form(
            key: _formKey,
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
                            'Create Your Profile',
                            style: TextStyle(
                              color: Colors.green[400],
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          _buildNameTF(),
                          SizedBox(height: 10.0),
                          _buildGender(),
                          SizedBox(height: 10.0),
                          _buildEmailTF(),
                          SizedBox(height: 10.0),
                          _buildSocialBtnRow(),
                          SizedBox(height: 10.0),
                          _buildRegisterBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
