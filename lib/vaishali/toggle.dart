import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/request.dart';

class MyToggle extends StatefulWidget {
  @override
  MyToggleState createState() => MyToggleState();
  
}

class MyToggleState extends State<MyToggle> {
  
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        if(value)
          Requests.getReviewdArticles();
        else
          Requests.getFeeedItems();
        setState(() {
          isSwitched = value;
        });
      },
      activeTrackColor: Color(0x999a2424),
      activeColor: Color(0xFF9a2424),
    );
  }
}

