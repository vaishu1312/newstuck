import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/appBar.dart';
//import 'package:newstuck/vaishali/dropdown.dart';
import 'package:newstuck/vaishali/toggle.dart';
import 'package:newstuck/vaishali/customDrop.dart';
import 'package:newstuck/vaishali/headline.dart';
import 'package:newstuck/vaishali/expand.dart';
import 'package:newstuck/clement_activities/ranks.dart';
import 'package:newstuck/clement_activities/tags.dart';

class MyDashBoard extends StatefulWidget {
  MyDashBoard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyDashBoardState createState() => MyDashBoardState();
}

class MyDashBoardState extends State<MyDashBoard> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    print(MediaQuery.of(context).size.width);
    print(h);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: Column(children: [
          Container(
              height: h * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    MyToggle(),
                    Text('Selected Items Only',
                        style: TextStyle(color: Color(0xAA000000))),
                  ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [CustomDropdown()]),
                ],
              )),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  //height: h - CustomAppBar().preferredSize.height - (h * 0.15),
                  padding: EdgeInsets.all(10.0),
                  color: Color(0xFF9a2424),
                  child: Card(
                    child: ExpandRow(),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
