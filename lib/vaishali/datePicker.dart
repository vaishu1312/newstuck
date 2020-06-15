import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget{

  final double height;
  MyDatePicker(this.height);
  @override
  MyDatePickerState createState() => MyDatePickerState();
}

class MyDatePickerState extends State<MyDatePicker>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Material(
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
      ],
    );
  }
}