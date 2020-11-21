import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rydgo/Loaders/SignUpLoad.dart';
import 'package:rydgo/Screens/BottomNavBar.dart';
import 'package:rydgo/Screens/Login.dart';
import 'package:rydgo/Services/AuthService.dart';
import 'package:rydgo/Services/DataBase.dart';
import 'package:rydgo/Utilities/design.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _gender, _imgUrl, _image;
  static String _gendercontoller = '';
  int _selectedposition = 0;
  bool loading = false;

  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  dynamic data;
  Future<dynamic> getUserData() async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection("_CtnSignUp")
        .doc(FirebaseAuth.instance.currentUser.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data();
      });
    });
    setState(() {
      namecontroller.text = data['name'];
      emailcontroller.text = data['email'];
      _gendercontoller = data['gender'];
      _selectedposition = _gendercontoller.toString() == 'Male'
          ? 0
          : _gendercontoller.toString() == 'Female'
              ? 1
              : 2;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
    getUserData();
  }

  Future<void> getUserProfile() async {
    _imgUrl = await DataBaseService().getUserProfile();
    setState(() {
      _image = _imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      File image = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedFile) => pickedFile.path));

      _imgUrl = await DataBaseService().uploadProfile(image);
      setState(() {
        _image = _imgUrl;
      });

      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    }

    return loading
        ? ShowLoading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.green,
                ),
                onPressed: () {},
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       Icons.settings,
              //       color: Colors.green,
              //     ),
              //     onPressed: () {
              //       // Navigator.of(context).push(MaterialPageRoute(
              //       //     builder: (BuildContext context) => SettingsPage()));
              //     },
              //   ),
              // ],
            ),
            body: Form(
              key: _formKey,
              //padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  children: [
                    Text(
                      "Edit Profile",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Builder(
                      builder: (context) => Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 80,
                                        child: ClipOval(
                                          child: SizedBox(
                                            child: (_image != null)
                                                ? Image.network(
                                                    _image,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.network(
                                                    "https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg",
                                                    fit: BoxFit.fill,
                                                  ),
                                            width: 150,
                                            height: 150,
                                          ),
                                        ),
                                      ),
                                    )),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 60),
                                //   child: IconButton(
                                //     icon: Icon(
                                //       Icons.camera,
                                //       size: 30.0,
                                //     ),
                                //     onPressed: () {
                                //       getImage();
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    buildTextField("Full Name", namecontroller),
                    buildTextField("E-mail", emailcontroller),
                    buildTextField("Location", emailcontroller),
                    _buildGender(),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            await updateDetails();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar()));
                          },
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "UPDATE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            await AuthService.signOut();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildTextField(
      String labelText, TextEditingController controllerdata) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Please Enter Your $labelText';
          }
          if (labelText == 'E-mail') {
            if (!input.contains('@')) {
              return 'Invalid Email';
            } else {
              return null;
            }
          } else {
            return null;
          }
        },
        controller: controllerdata,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  List<String> lst = ['Male', 'Female', 'Others'];

  void changeIndex(int index) {
    setState(() {
      _selectedposition = index;
    });
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

  Future<void> updateDetails() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      setState(() {
        loading = true;
      });
      formState.save();
      await DataBaseService().updateUserData(
          namecontroller.text,
          _selectedposition == 0
              ? 'Male'
              : _selectedposition == 1
                  ? 'Female'
                  : 'Others',
          emailcontroller.text);
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }
}
