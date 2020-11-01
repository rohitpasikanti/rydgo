import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final DateTime date;
  final DateTime time;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.greenAccent[100],
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
