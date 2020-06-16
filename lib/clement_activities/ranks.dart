import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';

class rankBar extends StatefulWidget {
  @override
  _rankBar createState() {
    // TODO: implement createState
    return _rankBar();
  }
}

class _rankBar extends State<rankBar> {
  String competency = "None";
  List<String> competencyList = [
    "None",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  String trustworthiness = "None";
  String factsvsopinion = "None";

  Widget build(BuildContext context) {
    return  Wrap(children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 200,
                child: Text('Competency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: new Color(0xff9a2424),
                        fontFamily: 'Lobster')),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(30)),

                // dropdown below..
                child: DropdownButton<String>(
                    value: competency,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (String newValue) {
                      setState(() {
                        competency = newValue;
                      });
                    },
                    items: competencyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 200,
                child: Text('TrustWorthiness',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: new Color(0xff9a2424),
                        fontFamily: 'Lobster')),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(30)),

                // dropdown below..
                child: DropdownButton<String>(
                    value: trustworthiness,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (String newValue) {
                      setState(() {
                        trustworthiness = newValue;
                      });
                      // print(competency);
                    },
                    items: competencyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 200,
                child: Text('FactVsOpinion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: new Color(0xff9a2424),
                        fontFamily: 'Lobster')),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(30)),

                // dropdown below..
                child: DropdownButton<String>(
                    value: factsvsopinion,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (String newValue) {
                      setState(() {
                        factsvsopinion = newValue;
                      });
                      // print(competency);
                    },
                    items: competencyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ),
            ],
          ),
        ),
      ]);
  }
}
