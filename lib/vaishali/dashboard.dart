import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/appBar.dart';
//import 'package:newstuck/vaishali/dropdown.dart';
import 'package:newstuck/vaishali/toggle.dart';
import 'package:newstuck/vaishali/customDrop.dart';

class MyDashBoard extends StatefulWidget {
  MyDashBoard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyDashBoardState createState() => MyDashBoardState();
}

class MyDashBoardState extends State<MyDashBoard> {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,                
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 4,
                    offset: Offset(0,3), 
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  MyToggle(),
                  Text('Selected Items Only',
                  style: TextStyle(color: Color(0xAA000000))),
                  Spacer(),
                  CustomDropdown(),
                  //MyDropDown(),
                ],
              )),
          Container(
          ),
        ]),
      ),
    );
  }
}
