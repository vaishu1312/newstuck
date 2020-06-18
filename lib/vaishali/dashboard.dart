import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newstuck/clement_activities/filters.dart';
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
  var firstFeed = new List<dynamic>();
  var filterText = "Last 24 hours";

  void setText(String text) {
    setState(() {
      filterText = text;
    });
  }

  @override
  void initState() {
    super.initState();
    filter('Last 24 hours', false).then((response) => {
          if (response.statusCode == 200)
            {
              firstFeed = json.decode(response.body),
              print(firstFeed),
              firstFeed = firstFeed[0]["feedItemViewModel"],
              dropFilter(firstFeed)
            }
        });
  }

  void dropFilter(feeditems) {
    // print("Inside Drop Filter");
    print("dropFilter : " + feeditems.length.toString());
    setState(() {
      feedItems = feeditems;
      print("After SetState");
      print(feedItems);
    });
  }

  void onToggleSelected(val) {
    print("in dash selected");
    print(val);
    setState(() {
      isToggleSelected = val;
    });
    print(filterText);
    print("SMith State Change");
    print(filterText.contains("-"));
    if (filterText.contains("-") == false ) {
      filter(filterText, isToggleSelected).then((response) => {
            if (response.statusCode == 200)
              {
                firstFeed = json.decode(response.body),
                print(firstFeed),
                firstFeed = firstFeed[0]["feedItemViewModel"],
                dropFilter(firstFeed)
              }
          });
    } else {
      DateTime date = DateTime.parse(filterText);
      print("After Parsing");
      print(filterText);
      var formatter1 = new DateFormat('EEE, d MMM y 18:30:00 ');
      var subDt = date.toUtc().subtract(Duration(days: 1));
      subDt = subDt.add(Duration(days: 1));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);
      print("After Date Selected");

      var now = new DateTime.now();
      var formatter = new DateFormat('EEE MMM d y HH:mm:ss ');
      String ToDate = formatter.format(now);
      ToDate = ToDate + "GMT 0530 (India Standard Time)";
      print(ToDate + "GMT 0530 (India Standard Time)");

      if (isToggleSelected) {
        filterfeedreviewCurrent(FromDate, "1", isToggleSelected, ToDate);
      } else {
        filterfeedCurrent(FromDate, "1", isToggleSelected, ToDate);
      }
    }
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
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    CustomDropdown(dropFilter, isToggleSelected, setText)
                  ]),
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

    if (isToggleSelected) {
      print("new feed");
      String uid = prefs.getString("u_id");
      response = await http.get(
          returnDomain() +
              "api/Feed/GetReviewedArticles?SelectedArticles=true&UserId=" +
              uid,
          headers: requestHeaders);
    } else {
      response = await http.get(returnDomain() + "api/Feed/GetFeedItems",
          headers: requestHeaders);
    }

    setState(() {
      feedItems = json.decode(response.body);
      feedItems = feedItems[0]["feedItemViewModel"];
      //print(feedItems);
    });
  }

  void filterfeedCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    // print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

    String uid = prefs.getString("u_id");
    response = await http.get(
        returnDomain() +
            "api/Feed/GetFeedItems?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=$pageNumber",
        headers: requestHeaders);

    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    feedItems = feedItems[0]["feedItemViewModel"];
    print("After Print");
    print(feedItems);
    dropFilter(feedItems);
    // return response;
  }

  void filterfeedreviewCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

    String uid = prefs.getString("u_id");
    response = await http.get(
        returnDomain() +
            "api/Feed/GetReviewedArticles?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=$pageNumber",
        headers: requestHeaders);
    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    feedItems = feedItems[0]["feedItemViewModel"];
    print("After Print");
    print(feedItems);
    dropFilter(feedItems);

    // return response;
  }
}
