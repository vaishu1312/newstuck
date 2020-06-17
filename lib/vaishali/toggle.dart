import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/request.dart';

class MyToggle extends StatefulWidget {

  final Function(bool) onToggleSelected;
  MyToggle(this.onToggleSelected);
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
        print("selected");
        print(value) ;       
          widget.onToggleSelected(value);
        setState(() {
          isSwitched = value;
        });
      },
      activeTrackColor: Color(0x999a2424),
      activeColor: Color(0xFF9a2424),
    );
  }
}

