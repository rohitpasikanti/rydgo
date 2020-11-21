import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rydgo/Screens/Quotes.dart';
import 'package:rydgo/Services/NotificationService.dart';

class AvailableRides extends StatefulWidget {
  @override
  _AvailableRides createState() => _AvailableRides();
}

class _AvailableRides extends State<AvailableRides> {
  // dynamic data;

  // Future<dynamic> getUserData() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("_CtnMapDetails").get();
  //   setState(() {
  //     data = querySnapshot.docs;
  //     dataCount = querySnapshot.size;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUserData();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[200],
  //     appBar: AppBar(
  //       title: Text('Available Rides'),
  //       centerTitle: true,
  //       backgroundColor: Colors.green[300],
  //     ),
  //     body: getData(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Available Rides'),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("_CtnMapDetails")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text("There is no expense");
            return new ListView(children: getExpenseItems(snapshot));
          }),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(60 / 2),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg"))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(doc.get("destination"),
                              style: TextStyle(fontSize: 17)),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("Amount:"),
                              Text(doc.get("fare").toString(),
                                  style: TextStyle(fontSize: 17)),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                            onPressed: () {
                              NotiFication.sendNotification(
                                  "AunhTaNyrtXtTFbNe6YEHvkzCvj2");
                            },
                            color: Colors.green[300],
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            elevation: 30,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "CONFIRM",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }
}

// Widget getData() {
//   List items = dataCount;
//   return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return getCard();
//       });
// }

// Widget getCard(AsyncSnapshot<QuerySnapshot> snapshot) {
//   return Card(
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: ListTile(
//       title: Row(
//         children: <Widget>[
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//                 color: Colors.green[300],
//                 borderRadius: BorderRadius.circular(60 / 2),
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(
//                         "https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg"))),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Text("TestUser", style: TextStyle(fontSize: 17)),
//               SizedBox(
//                 width: 10,
//               ),
//               Text("TestUser", style: TextStyle(fontSize: 17)),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           )
//         ],
//       ),
//     ),
//   ));
// }
