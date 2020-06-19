import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newstuck/clement_activities/filters.dart';
import 'package:newstuck/clement_activities/validToken.dart';

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
  bool load = false;
  var totalPages;
  ScrollController _scrollController = new ScrollController();
  var prefs;
  void setText(String text) {
    setState(() {
      filterText = text;
    });
  }

  @override
  void initState() {
    initSP();
    filter('Last 24 hours', false).then((response) => {
          if (response.statusCode == 200)
            {
              firstFeed = json.decode(response.body),
              print(firstFeed),
              prefs.setInt("totalPage", firstFeed[0]["count"]),
              firstFeed = firstFeed[0]["feedItemViewModel"],
              dropFilter(firstFeed)
            }
        });

    _scrollController.addListener(() => scrollListener());
    super.initState();
  }

  void initSP() async {
    prefs = await SharedPreferences.getInstance();
  }

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      var sc = _scrollController.position.maxScrollExtent - 200;
      print("This is Max Scroll Content : $sc");
      var currentUrl = prefs.getString("currentUrl");
      print("Success12");
      var currentPage = prefs.getInt("currentPage");
      print("currentPage : $currentPage");
      var totalPage = prefs.getInt("totalPage");
      print("totalPage :$totalPage");
      double pages1 = totalPage / 20;
      print("DoubleDiv : $pages1");
      int pages = pages1.toInt();
      print("Div : $pages");
      int rem = totalPage % 20;
      print("Rem : $rem");
      int TotalPages = pages;
      print("Success16");
      if (rem > 0) {
        TotalPages = TotalPages + 1;
        setState(() {
          totalPage = TotalPages;
        });
      }
      print("TotalPages : $TotalPages");
      print("Success7");

      print(
          "The Current Url : $currentUrl with current page : $currentPage with total Page: $TotalPages");
      int nextPage = currentPage + 1;
      String next = nextPage.toString();
      print("Next as String: $next ");
      if (currentPage < TotalPages) {
        setState(() {
          load = true;
        });
        getRemainingFeed(currentUrl, next);
      }
    }
  }

  void getRemainingFeed(String url, String pageNo) async {
    checkTokenValid();
    print("Function Called");
    String token = prefs.getString("token");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };

    String uid = prefs.getString("u_id");
    http.Response response =
        await http.get(returnDomain() + url + pageNo, headers: requestHeaders);

    prefs.setInt("currentPage", int.parse(pageNo));
    print(json.decode(response.body));
    var newFeed = json.decode(response.body);
    newFeed = newFeed[0]["feedItemViewModel"];
    appendFeed(newFeed);
  }

  void appendFeed(feeditems) {
    // setState(() {
    //   load = true;
    // });
    setState(() {
      feedItems.addAll(feeditems);
    });
    setState(() {
      load = false;
    });
  }

  void dropFilter(feeditems) {
    print("SMith Awesome 1");
    // print("Inside Drop Filter");
    print("dropFilter : " + feeditems.length.toString());
    setState(() {
      feedItems.clear();
      
    });
    setState(() {
      load = true;
    });
    if (feedItems.length == 0) {
      Timer(
          Duration(seconds: 2),
          () => {
                setState(() {
                  feedItems = feeditems;

                  // print("After SetState");
                  // print(feedItems);
                }),
              });
    }
    setState(() {
      load = false;
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
    if (filterText.contains("-") == false) {
      filter(filterText, isToggleSelected).then((response) => {
            if (response.statusCode == 200)
              {
                firstFeed = json.decode(response.body),
                print(firstFeed),
                prefs.setInt("totalPage", firstFeed[0]["count"]),
                firstFeed = firstFeed[0]["feedItemViewModel"],
                print("Smith Awesome"),
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
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: load?feedItems.length + 1:feedItems.length,
              itemBuilder: (context, index) {
                if (index == feedItems.length && load) {
                  return CupertinoActivityIndicator(
                    radius: 20,
                  );
                }

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
    checkTokenValid();
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
      feedItems.clear();
    });
    setState(() {
      feedItems = json.decode(response.body);
      feedItems = feedItems[0]["feedItemViewModel"];
      //print(feedItems);
    });
  }

  void filterfeedCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
        checkTokenValid();
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
    prefs.setString("currentUrl",
        "api/Feed/GetFeedItems?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=");
    prefs.setInt("currentPage", int.parse(pageNumber));
    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    feedItems = feedItems[0]["feedItemViewModel"];
    prefs.setInt("totalPage", feedItems[0]["count"]);
    print("After Print");
    print(feedItems);
    dropFilter(feedItems);
    // return response;
  }

  void filterfeedreviewCurrent(String FromDate, String pageNumber,
      bool selectedArticles, String ToDate) async {
        checkTokenValid();
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
    prefs.setString("currentUrl",
        "api/Feed/GetReviewedArticles?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=");
    prefs.setInt("currentPage", int.parse(pageNumber));
    var feedItems = new List<dynamic>();
    feedItems = json.decode(response.body);
    prefs.setInt("totalPage", feedItems[0]["count"]);
    feedItems = feedItems[0]["feedItemViewModel"];

    print("After Print");
    print(feedItems);
    dropFilter(feedItems);

    // return response;
  }
}
