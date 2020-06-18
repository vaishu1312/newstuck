import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<dynamic> filter(String text, bool selectedArticles) {
  var feedItems = new List<dynamic>();
  if (!selectedArticles) {
    if (text == 'Last 3 days') {
      var formatter1 = new DateFormat('EEE, d MMM y 18:30:00 ');
      var subDt = DateTime.now().toUtc().subtract(Duration(days: 3));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);

      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 24 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y 18:30:00 ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 24));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now = new DateTime.now();
      var formatter = new DateFormat('EEE MMM d y HH:mm:ss ');
      String ToDate = formatter.format(now);
      ToDate = ToDate + "GMT 0530 (India Standard Time)";
      print(ToDate + "GMT 0530 (India Standard Time)");
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 5 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 5));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 4 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 4));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 3 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 3));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 2 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 2));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 1 hour') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 1));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeed(FromDate, "1", selectedArticles, ToDate);
    }
  } else {
    if (text == 'Last 3 days') {
      var formatter1 = new DateFormat('EEE, d MMM y 18:30:00 ');
      var subDt = DateTime.now().toUtc().subtract(Duration(days: 3));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);

      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 24 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y 18:30:00 ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 24));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now = new DateTime.now();
      var formatter = new DateFormat('EEE MMM d y HH:mm:ss ');
      String ToDate = formatter.format(now);
      print(ToDate + "GMT 0530 (India Standard Time)");
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 5 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 5));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 4 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 4));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 3 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 3));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 2 hours') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 2));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    } else if (text == 'Last 1 hour') {
      var formatter1 = new DateFormat('EEE, d MMM y hh:mm:ss ');
      var subDt = DateTime.now().toUtc().subtract(Duration(hours: 1));
      String formatted1 = formatter1.format(subDt);
      String FromDate = formatted1 + "GMT";
      print(FromDate);

      var now1 = DateTime.now().toUtc().add(Duration(days: 1));
      var formatter2 = new DateFormat('yyyy-M-d');
      String ToDate = formatter2.format(now1);
      print(ToDate);
      return filterfeedreview(FromDate, "1", selectedArticles, ToDate);
    }
  }
}

Future<http.Response> filterfeed(String FromDate, String pageNumber,
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
          "api/Feed/GetFeedItems?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=$pageNumber",
      headers: requestHeaders);

  prefs.setString("currentUrl",
      "api/Feed/GetFeedItems?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=");
  prefs.setInt("currentPage", int.parse(pageNumber));

  return response;
}

Future<http.Response> filterfeedreview(String FromDate, String pageNumber,
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
      
  prefs.setString("currentUrl", "api/Feed/GetReviewedArticles?SelectedArticles=$selectedArticles&UserId=$uid&FromDate=$FromDate&ToDate=$ToDate&PageNumber=");
  prefs.setInt("currentPage", int.parse(pageNumber));
  return response;
}
