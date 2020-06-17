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
  HeaderRow(this.feed);
  @override
  State<StatefulWidget> createState() => HeaderRowState();
}

class HeaderRowState extends State<HeaderRow> {
  bool isPressed = false;
  bool isReviewed = false;

  var feedItem = new Map<String, dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedItem = widget.feed;
  }

  void updateReview(int feed_id,bool isDel) async {
    http.Response response;
    final prefs = await SharedPreferences.getInstance();
    //int feed_id =int.parse(id);
    String uid=prefs.getString("u_id");
    //dynamic body = {"feedItemId":feed_id, "isDeleted": isDel,"userId":uid};
    String token = prefs.getString("token");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    Map<String,dynamic> body_map ={
      'feedItemId':feed_id,
      'isDeleted':isDel,
      'userId':uid,
    };
       response = await http.post(
          returnDomain() + "api/Feed/UpdateReview",
          body: json.encode(body_map),
          headers: requestHeaders,
          );  
    
  }

  @override
  Widget build(BuildContext context) {

    var date_time=feedItem["publishDate"].split("T");

    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            title: MyLink(feedItem["title"],feedItem["href"]),
            subtitle: Text(date_time[0]+" | "+date_time[1]+" | "+feedItem["category"]),
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
                    if(!isPressed){
                        updateReview(feedItem["feedItemId"],false);
                        //make a post reqest with feed["feedItemId"] and isDeleted=false and userId
                      }
                      else{
                        updateReview(feedItem["feedItemId"],true);
                        //make a post reqest with feed["feedItemId"] and isDeleted=true and userId
                      }
                    setState(() {
                      isPressed = !isPressed;
                      
                      if (isReviewed == false) isReviewed = true;
                    });
                  },
                ),
              ),
            ),
            ),
            isReviewed
            ? SizedBox(height: 200.0, child: rankBar())
            : Container(height: 0),
        isReviewed
            ? SizedBox(height: 200.0, child: TagBuild())
            : Container(height: 0),
      ],
      );

    /*return ListTile(
        title: MyLink(feedItem["title"],feedItem["href"]),
        subtitle: Text(feedItem["publishDate"]+" | "+feedItem["category"]),
        trailing: ClipOval(
          child: Material(
            color: (isPressed)
                ? Color(0xff00AA00)
                : Color(0xff9A9A9A), // button color
            child: InkWell(
              splashColor: (isPressed)
                  ? Color(0x6600AA00)
                  : Color(0x669A9A9A), // inkwell color
              child: SizedBox(
                  width: 56, height: 56, child: Icon(Icons.done_outline)),
              onTap: () {
                setState(() {
                  isPressed = !isPressed;
                });
              },
            ),
          ),
        )
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
        
    );*/
  }
}

class MyLink extends StatelessWidget {
  MyLink(this.val,this.url);
  final String val;
  final String url;
  @override
  Widget build(BuildContext context) {
    return /*FittedBox(
      fit: BoxFit.contain,
      child:*/ GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyWebView(url)));
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