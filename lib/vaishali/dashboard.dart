import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/appBar.dart';
//import 'package:newstuck/vaishali/dropdown.dart';
import 'package:newstuck/vaishali/toggle.dart';
import 'dart:convert';
import 'package:newstuck/vaishali/customDrop.dart';
import 'package:newstuck/vaishali/headline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'package:newstuck/vaishali/expand.dart';

import 'package:newstuck/clement_activities/ranks.dart';
import 'package:newstuck/clement_activities/tags.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDashBoard extends StatefulWidget {
  MyDashBoard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyDashBoardState createState() => MyDashBoardState();
}

class MyDashBoardState extends State<MyDashBoard> {
  var feedItems = new List<dynamic>();
  var isToggleSelected = false;

  @override
  void initState() {
    super.initState();
    getFeed();
  }

  void onToggleSelected(val) {
    print("in dash selected");
    print(val);
    setState(() {
      isToggleSelected = val;
      getFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    //print(MediaQuery.of(context).size.width);
    //print(h);
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
                    MyToggle(onToggleSelected),
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
              itemCount: feedItems.length,
              itemBuilder: (context, index) {
                return Container(
                  //height: h - CustomAppBar().preferredSize.height - (h * 0.15),
                  padding: EdgeInsets.all(10.0),
                  color: Color(0xFF9a2424),
                  child: Card(
                    //child: ExpandRow(),
                    child: HeaderRow(feedItems[index]),
                  ),

                  /*margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              HeaderRow(feedItems[index]),
                              //Expanded(flex: 1, child: HeaderRow()),
                              Expanded(flex: 1, child: rankBar()),
                              Expanded(flex: 1, child: TagBuild()),
                              //rankBar(),
                              //TagBuild(),
                            ],
                          ))),*/
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  void getFeed() async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    //print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

   
    if (isToggleSelected){
      print("new feed");
      String uid=prefs.getString("u_id");
       response = await http.get(
          returnDomain() + "api/Feed/GetReviewedArticles?SelectedArticles=true&UserId="+uid,
          headers: requestHeaders);
    }
    else{
       response = await http.get(
          returnDomain() + "api/Feed/GetFeedItems",
          headers: requestHeaders);
    }

    setState(() {
      feedItems = json.decode(response.body);
      feedItems = feedItems[0]["feedItemViewModel"];
      //print(feedItems);
    });
  }
}
