// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:rydgo/Screens/Login.dart';
// import 'package:rydgo/Screens/MapScreen.dart';
// import 'package:rydgo/Services/app_state.dart';

// class Landing extends StatefulWidget {
//   @override
//   _Landing createState() => _Landing();
// }

// class _Landing extends State<Landing> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();

//     _auth.authStateChanges().listen((User user) {
//       if (user == null) {
//         WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
//             context, MaterialPageRoute(builder: (context) => LoginScreen())));
//       } else {
//         WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => MultiProvider(
//                       providers: [
//                         ChangeNotifierProvider.value(
//                           value: AppState(),
//                         )
//                       ],
//                       child: MyHomePage(),
//                     ))));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
