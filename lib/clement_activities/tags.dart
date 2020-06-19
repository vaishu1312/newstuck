import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newstuck/clement_activities/validToken.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:newstuck/clement_activities/home.dart";
class TagBuild extends StatefulWidget {
  var feed = new Map<String, dynamic>();
  TagBuild(this.feed);
  _TagBuild createState() {
    return _TagBuild();
  }
}

class _TagBuild extends State<TagBuild> {
  var eduSelected = false;
  var polSelected = false;
  var covSelected = false;
  var cheSelected = false;
  var tnSelected = false;
  var ecoSelected = false;
  var tagItems = new List<dynamic>();
  var tagSelected;
  var roundButtonController;

  void initState() {
    super.initState();
    getTags();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(left: 10),
        itemCount: tagItems.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RoundedLoadingButton(
              width: 100,
              color: tagSelected[index] ? Colors.green : Colors.red,
              child: Text(tagItems[index]["tagName"],
                  style: TextStyle(color: Colors.white)),
              controller: roundButtonController[index],
              onPressed: () {
                updateTag(widget.feed["feedItemId"], tagItems[index]["tagId"],
                    !tagSelected[index]);
                setState(() {
                  tagSelected[index] = !tagSelected[index];
                });
                tagEdu(
                    tagItems[index]["tagName"], roundButtonController[index]);
              },
            ),
          );
        });
  }

  void updateTag(int feedItemId, int tagId, bool isTagExist) async {
    checkTokenValid();
    print(
        "The FeedItem with Id :$feedItemId and tag Selected : $tagId with bool value : $isTagExist");
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    String uid = prefs.getString("u_id");
    Map<String, dynamic> body = {
      "Id" : tagId,
      "FeedItemId": feedItemId,
      "IsTagExist" : isTagExist,
      "UserId": uid
    };
    //print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    http.Response response = await http.post(
        returnDomain() + "api/Feed/AddOrUpdateArticleTag",
        body: json.encode(body),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      print("Post Tag Updated");
    }else{
      Get.offAll(Home());
    }
  }

  void tagEdu(String tag, RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 1), () {
      controller.reset();
      // controller.reset();
      //   Timer(Duration(seconds: 2), () {
      //   controller.reset();
      //   // controller.reset();

      // });
    });
  }

  void getTags() async {
    checkTokenValid();
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    //print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    http.Response response = await http
        .get(returnDomain() + "api/Feed/GetFeedTags", headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        tagItems = json.decode(response.body);
        tagSelected = List<bool>.generate(tagItems.length, (index) => false);
        print(widget.feed["seletedTags"].runtimeType);
        print("BeforIf");
        
        if(widget.feed["seletedTags"].isEmpty){

        }else{
          // print(widget.feed["selectedTags"].runtimeType);
          print("Inside Else");
          print(widget.feed["seletedTags"].length);
          List<dynamic> st = widget.feed["seletedTags"];
          st.forEach((tag)=>{
            print(tag["id"]),
              tagSelected[tag["id"]-1] = true ,
              print(tagSelected[tag["id"]-1])
          });
          print(tagSelected);
          
          
        }
        roundButtonController =
            new List<RoundedLoadingButtonController>.generate(tagItems.length,
                (index) => new RoundedLoadingButtonController());
      });
    }else{
      Get.offAll(Home());
    }
    //
    //print("Hello");
    //print(tagItems);
  }
}
