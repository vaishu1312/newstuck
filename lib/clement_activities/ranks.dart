import 'dart:convert';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:newstuck/clement_activities/validToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:newstuck/clement_activities/home.dart";
class rankBar extends StatefulWidget {
  var feed = new Map<String, dynamic>();
  rankBar(this.feed);
  @override
  _rankBar createState() {
    // TODO: implement createState
    return _rankBar();
  }
}

class _rankBar extends State<rankBar> {
  var feedItems = new List<dynamic>();
  var itemValue;
  String competency = "0";

  List<String> competencyList = [
    "0",
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
  String trustworthiness = "0";
  String factsvsopinion = "0";

  void initState() {
    super.initState();
    getRanks();
  }

  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 200,
                child: Text(feedItems[index]["dimensionName"],
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
                    value: itemValue[index],
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (String newValue) {
                      UpdateFeed(feedItems[index]["dimensionID"],
                          int.parse(newValue), widget.feed["feedItemId"]);
                      setState(() {
                        itemValue[index] = newValue;
                      });
                    },
                    items: competencyList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              )
            ],
          ),
        );
      },
    );
  }

  void getRanks() async {
    checkTokenValid();
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    //print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    http.Response response = await http.get(
        returnDomain() + "api/Feed/Getfeeddimensions",
        headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        feedItems = json.decode(response.body);
        itemValue = List<String>.generate(feedItems.length, (index) => widget.feed["feedDimensions"][index]["dimensionRank"].toString());
      });
    }else{
      Get.offAll(Home());
    }
    //
    // print("Hello");
    // print(feedItems);
  }

  void UpdateFeed(int dimensionId, int dimensionRank, int feedItemId) async {
    checkTokenValid();
    print(
        "The DimensionId is : $dimensionId with Rank : $dimensionRank of the feed : $feedItemId");

    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    String uid = prefs.getString("u_id");
    Map<String,dynamic> body = {"dimensionId" : dimensionId, "dimensionRank" : dimensionRank , "feedItemId" :feedItemId,"isDeleted" : false,"userId" : uid} ;
    //print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    http.Response response = await http.post(
        returnDomain() + "api/Feed/PostArticleDimensionRank",
        body:json.encode(body),
        headers: requestHeaders);
    
    if(response.statusCode == 200){
      print("Post Feed Updated");
    }else{
      Get.offAll(Home());
    }
  }
}
