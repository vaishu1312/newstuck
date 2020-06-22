import 'package:flutter/material.dart';
import 'package:newstuck/clement_activities/validToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:newstuck/clement_activities/const.dart';
import 'package:newstuck/clement_activities/home.dart';
import 'dart:convert';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String appTitle = "NEWSTUCK";
  final String AdminRoleId = "10a6ab6a-738d-4311-8c98-c1d911e7a2e7";
  final String EditorRoleId = "10a6ab6a-738d-4311-8c98-c1d911e7a2e8";
  final String SubEditorRoleId = "10a6ab6a-738d-4311-8c98-c1d911e7a2e9";

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  CustomAppBarState createState() => CustomAppBarState();
}

class CustomAppBarState extends State<CustomAppBar> {
  List<String> options = <String>[
    'Curator',
    'Name',
    'Email',
    'Change password',
    'Logout',
  ];

  void getUid() async {
    var prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("u_id");
    String uri = returnDomain() + "Users/$uid";
    String token = prefs.getString("token");
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      "Authorization": "Bearer " + token
    };
    checkTokenValid();
    http.Response response = await http.get(uri, headers: requestHeaders);
    var user_details = new Map<String, dynamic>();
    if (response.statusCode == 200) {
      user_details = json.decode(response.body);
      //options[1]=role
      options[1] = user_details["userName"];
      options[2] = user_details["email"];
    } else
      Get.offAll(Home());
  }

  @override
  Widget build(BuildContext context) {
    getUid();

    return AppBar(
      title: Text(
        widget.appTitle,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      backgroundColor: Color(0xFF9a2424),
      elevation: 0.0,
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) {
            return options.map((choice) {
              return PopupMenuItem(
                enabled: (options.indexOf(choice) == 3 ||
                        options.indexOf(choice) == 4)
                    ? true
                    : false,
                value: options.indexOf(choice),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      choice,
                      style: TextStyle(
                          color: (options.indexOf(choice) == 3 ||
                                  options.indexOf(choice) == 4)
                              ? Color(0xFF9a2424)
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          icon: Icon(
            Icons.account_circle,
            size: 34.0,
          ),
          offset: Offset(0, 100),
          elevation: 4.0,
          onSelected: (value) {
            if (value == 3) {
              //change pwd
            } else if (value == 4) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
            }
          },
        )
        /*IconButton(
          onPressed: () {
            //print('object');
          },
          icon: Icon(Icons.account_circle),
          iconSize: 45,
          splashColor: Colors.red,
        ),*/
      ],
    );
  }
}
