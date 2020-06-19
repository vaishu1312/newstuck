import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/webview.dart';
import 'package:newstuck/clement_activities/ranks.dart';
import 'package:newstuck/clement_activities/tags.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HeaderRow extends StatefulWidget {
  var feed = new Map<String, dynamic>();
  bool default_open;
  HeaderRow(this.feed,this.default_open);
  @override
  State<StatefulWidget> createState() => HeaderRowState();
}

class HeaderRowState extends State<HeaderRow> {
  bool isPressed;
  var feedItem = new Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    feedItem = widget.feed;
    isPressed=widget.default_open;
  }

  void updateReview(int feed_id, bool isDel) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("u_id");
    String token = prefs.getString("token");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    Map<String, dynamic> body_map = {
      'feedItemId': feed_id,
      'isDeleted': isDel,
      'userId': uid,
    };
    response = await http.post(
      returnDomain() + "api/Feed/UpdateReview",
      body: json.encode(body_map),
      headers: requestHeaders,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dialog_response;
    Map<int,String> week_day={1:'Mon',2:'Tue',3:'Wed',4:'Thu',5:'Fri',6:'Sat',7:'Sun'};
    Map<int,String> month_val ={1:'Jan',2:'Feb',3:'Mar',4:'Apr',5:'May',6:'Jun',7:'Jul',8:'Aug',9:'Sep',10:'Oct',11:'Nov',12:'Dec'};

    var date_time = feedItem["publishDate"].split("T"); 
   var date_arr= date_time[0].split("-");
   var date=new DateTime(int.parse(date_arr[0]),int.parse(date_arr[1]),int.parse(date_arr[2]));
   //year,month,day
   int n =date.weekday;
   int m= date.month;
   var idx = week_day.keys.firstWhere( (k) => (k==n) , orElse: () => null);
   var mon_idx= month_val.keys.firstWhere( (k) => (k==m) , orElse: () => null);
   var day=week_day[idx];
   var month =week_day[mon_idx];

    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: MyLink(feedItem["title"], feedItem["href"]),
          subtitle: Text(day+" "+month+" "+date_arr[1]+" "+date_arr[0]+" | " +
              date_time[1] +
              " | " +
              feedItem["category"]),
          /*Text(date_time[0] +
              " | " +
              date_time[1] +
              " | " +
              feedItem["category"]),*/
          trailing: ClipOval(
            child: Material(
              color: (isPressed)
                  ? Color(0xff00AA00)
                  : Colors.transparent, //Color(0xff9A9A9A), // button color
              child: InkWell(
                splashColor: (isPressed)
                    ? Color(0x6600AA00)
                    : Color(0x669A9A9A), // inkwell color
                child: SizedBox(
                    width: 56, height: 56, child: Icon(Icons.done_outline)),
                onTap: () {
                  print("tapped");
                  print(isPressed);
                  if (!isPressed) {
                    //selected
                    updateReview(feedItem["feedItemId"], false);
                    setState(() {
                      isPressed = !isPressed;
                    });
                    //make a post reqest with feed["feedItemId"] and isDeleted=false and userId
                  } else {
                    //unselected
                    //pop up -- if no , dont call set state
                    //if yes- update and call set state
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Remove this item from the list?'),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    print("pressed: yes $dialog_response");
                                    dialog_response = true;
                                    updateReview(feedItem["feedItemId"], true);
                                    print("inside: yes $dialog_response");
                                    Navigator.of(context).pop();
                                    setState(() {
                                      print("changing state");
                                      isPressed = !isPressed;
                                    });
                                  },
                                  child: Text('Yes')),
                              FlatButton(
                                  onPressed: () {
                                    print("pressed: no $dialog_response");
                                    dialog_response = false;
                                    print("inside: no $dialog_response");
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'))
                            ],
                          );
                        },
                        barrierDismissible: false);
                  }
                },
              ),
            ),
          ),
        ),
        isPressed
            ? SizedBox(height: 200.0, child: rankBar())
            : Container(height: 0),
        isPressed
            ? SizedBox(height: 200.0, child: TagBuild())
            : Container(height: 0),
      ],
    );

    /*trailing: IconButton(
          tooltip: 'Review article',
          icon: Icon(Icons.done_outline),
          highlightColor: (isPressed) ? Color(0x6600AA00) : Color(0x669A9A9A),
          color: (isPressed) ? Color(0xff00AA00) : Color(0xff9A9A9A),
          onPressed: () {
            setState(() {
              isPressed = !isPressed;
            });
          }),*/
  }
}

class MyLink extends StatelessWidget {
  MyLink(this.val, this.url);
  final String val;
  final String url;
  @override
  Widget build(BuildContext context) {
    return /*FittedBox(
      fit: BoxFit.contain,
      child:*/
        GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(url)));
      },
      child: Text(
        val,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue[700],
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      //),
    );
  }
}
