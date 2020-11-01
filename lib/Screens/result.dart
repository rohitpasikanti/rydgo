import 'package:flutter/material.dart';
import 'model.dart';

class Result extends StatelessWidget {
  Model model;
  Result({this.model});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text('Successful')),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(model.source, style: TextStyle(fontSize: 22)),
            Text(model.destination, style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    ));
  }
} // TODO Implement this library.
